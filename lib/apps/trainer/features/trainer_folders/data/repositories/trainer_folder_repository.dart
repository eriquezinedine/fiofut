import 'package:authentication/authentication.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:fio_fut/apps/admin/features/meals/domain/models/food.dart';
import 'package:fio_fut/apps/admin/features/ingredients/domain/models/ingredient.dart';
import 'package:fio_fut/apps/client/features/exercise_detail/domain/models/serie_set.dart';
import 'package:fio_fut/core/widgets/modal/schedule_date_modal.dart';

import '../../domain/models/folder_exercise_item.dart';
import '../../domain/models/trainer_folder.dart';

final trainerFolderRepositoryProvider =
    Provider<TrainerFolderRepository>((ref) {
  return TrainerFolderRepository();
});

class TrainerFolderRepository {
  TrainerFolderRepository({SupabaseClient? client})
      : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

  String get _userId => _client.auth.currentUser!.id;

  // ─── Folder CRUD ───

  Future<List<TrainerFolder>> getFolders(String type) async {
    final data = await _client
        .from('trainer_folder')
        .select()
        .eq('trainer_id', _userId)
        .eq('folder_type', type)
        .order('created_at', ascending: false);

    final folders = <TrainerFolder>[];
    for (final json in data) {
      final folderId = json['id'] as String;
      final countTable = type == 'food'
          ? 'trainer_folder_food'
          : 'trainer_folder_exercise';
      final countData = await _client
          .from(countTable)
          .select('id')
          .eq('folder_id', folderId);
      folders.add(
        TrainerFolder.fromJson({...json, 'item_count': countData.length}),
      );
    }
    return folders;
  }

  Future<TrainerFolder> createFolder({
    required String title,
    String? description,
    required String folderType,
  }) async {
    final data = await _client
        .from('trainer_folder')
        .insert({
          'trainer_id': _userId,
          'title': title,
          'description': description,
          'folder_type': folderType,
        })
        .select()
        .single();

    return TrainerFolder.fromJson({...data, 'item_count': 0});
  }

  Future<void> updateFolder({
    required String folderId,
    required String title,
    String? description,
  }) async {
    await _client.from('trainer_folder').update({
      'title': title,
      'description': description,
    }).eq('id', folderId);
  }

  Future<void> deleteFolder(String folderId) async {
    await _client.from('trainer_folder').delete().eq('id', folderId);
  }

  // ─── Food Items ───

  Future<List<Food>> getFolderFoods(String folderId) async {
    final data = await _client
        .from('trainer_folder_food')
        .select('food_id, sort_order')
        .eq('folder_id', folderId)
        .order('sort_order');

    final foods = <Food>[];
    for (final row in data) {
      final foodId = row['food_id'] as String;
      final foodData =
          await _client.from('food').select().eq('id', foodId).single();
      final ingredients = await _getIngredientsForFood(foodId);
      foods.add(Food.fromJson(foodData, ingredients: ingredients));
    }
    return foods;
  }

  Future<void> addFoodsToFolder(String folderId, List<String> foodIds) async {
    final rows = foodIds.asMap().entries.map((e) => {
          'folder_id': folderId,
          'food_id': e.value,
          'sort_order': e.key,
        }).toList();
    await _client.from('trainer_folder_food').upsert(rows);
  }

  Future<void> removeFoodFromFolder(String folderId, String foodId) async {
    await _client
        .from('trainer_folder_food')
        .delete()
        .eq('folder_id', folderId)
        .eq('food_id', foodId);
  }

  Future<void> moveFoodToFolder({
    required String fromFolderId,
    required String toFolderId,
    required String foodId,
  }) async {
    await _client
        .from('trainer_folder_food')
        .delete()
        .eq('folder_id', fromFolderId)
        .eq('food_id', foodId);
    await _client.from('trainer_folder_food').insert({
      'folder_id': toFolderId,
      'food_id': foodId,
      'sort_order': 0,
    });
  }

  // ─── Exercise Items ───

  Future<List<FolderExerciseItem>> getFolderExercises(String folderId) async {
    final data = await _client
        .from('trainer_folder_exercise')
        .select('id, exercise_id, sets, reps, weight, minutes, seconds, sort_order')
        .eq('folder_id', folderId)
        .order('sort_order');

    final items = <FolderExerciseItem>[];
    for (final row in data) {
      final exerciseId = row['exercise_id'] as String;
      final folderExerciseId = row['id'] as String;

      final exerciseData = await _client
          .from('exercise')
          .select()
          .eq('id', exerciseId)
          .single();

      // Load per-set config
      final setsData = await _client
          .from('trainer_folder_exercise_set')
          .select()
          .eq('folder_exercise_id', folderExerciseId)
          .order('set_number');

      items.add(FolderExerciseItem.fromJson({
        ...row,
        'exercise': exerciseData,
        'config_sets': setsData,
      }));
    }
    return items;
  }

  Future<void> addExerciseToFolder({
    required String folderId,
    required String exerciseId,
    required List<SerieSet> series,
  }) async {
    // Derive flat summary from first serie
    final first = series.isNotEmpty ? series.first : null;

    // Check if already exists
    final existing = await _client
        .from('trainer_folder_exercise')
        .select('id')
        .eq('folder_id', folderId)
        .eq('exercise_id', exerciseId)
        .maybeSingle();

    String folderExerciseId;
    if (existing != null) {
      folderExerciseId = existing['id'] as String;
      await _client.from('trainer_folder_exercise').update({
        'sets': series.length,
        'reps': first?.reps ?? 0,
      }).eq('id', folderExerciseId);
    } else {
      final data = await _client
          .from('trainer_folder_exercise')
          .insert({
            'folder_id': folderId,
            'exercise_id': exerciseId,
            'sets': series.length,
            'reps': first?.reps ?? 0,
            'sort_order': 0,
          })
          .select('id')
          .single();
      folderExerciseId = data['id'] as String;
    }

    // Clear old per-set config
    await _client
        .from('trainer_folder_exercise_set')
        .delete()
        .eq('folder_exercise_id', folderExerciseId);

    // Insert per-set config
    if (series.isNotEmpty) {
      final setRows = series.map((s) => {
            'folder_exercise_id': folderExerciseId,
            'set_number': s.number,
            'reps': s.reps,
            'weight': s.kg,
            'minutes': s.mins,
            'seconds': s.segs,
          }).toList();
      await _client.from('trainer_folder_exercise_set').insert(setRows);
    }
  }

  Future<void> removeExerciseFromFolder(String itemId) async {
    await _client.from('trainer_folder_exercise').delete().eq('id', itemId);
  }

  Future<void> updateExerciseInFolder({
    required String itemId,
    required int sets,
    required int reps,
  }) async {
    await _client.from('trainer_folder_exercise').update({
      'sets': sets,
      'reps': reps,
    }).eq('id', itemId);
  }

  Future<void> updateExerciseSeries({
    required String itemId,
    required List<SerieSet> series,
  }) async {
    final first = series.isNotEmpty ? series.first : null;
    await _client.from('trainer_folder_exercise').update({
      'sets': series.length,
      'reps': first?.reps ?? 0,
    }).eq('id', itemId);

    // Replace per-set config
    await _client
        .from('trainer_folder_exercise_set')
        .delete()
        .eq('folder_exercise_id', itemId);

    if (series.isNotEmpty) {
      final setRows = series.map((s) => {
            'folder_exercise_id': itemId,
            'set_number': s.number,
            'reps': s.reps,
            'weight': s.kg,
            'minutes': s.mins,
            'seconds': s.segs,
          }).toList();
      await _client.from('trainer_folder_exercise_set').insert(setRows);
    }
  }

  // ─── Students ───

  Future<List<UserProfile>> getMyStudents() async {
    final data = await _client
        .from('trainer_student')
        .select('student_id, profiles!trainer_student_student_id_fkey(*)')
        .eq('trainer_id', _userId)
        .eq('status', 'active');

    return data
        .where((row) => row['profiles'] != null)
        .map((row) {
      final profileJson = row['profiles'] as Map<String, dynamic>;
      return UserProfile.fromJson(profileJson);
    }).toList();
  }

  // ─── Assignment: Food Folder → Student ───

  Future<void> assignFoodFolder({
    required String folderId,
    required String studentId,
    required ScheduleDateResult schedule,
  }) async {
    final foods = await getFolderFoods(folderId);
    final daysString = schedule.selectedDays.toList()
      ..sort();

    final rows = foods.map((food) => {
          'id_food': food.id,
          'id_user_profile': studentId,
          'id_created_by': _userId,
          'schedule_type': 'weekly',
          'start_date': schedule.startDate.toIso8601String().split('T').first,
          'end_date': schedule.endDate.toIso8601String().split('T').first,
          'days_of_week': daysString.join(','),
        }).toList();

    await _client.from('food_schedule').insert(rows);
  }

  Future<void> assignSingleFood({
    required String foodId,
    required String studentId,
    required ScheduleDateResult schedule,
  }) async {
    final daysString = schedule.selectedDays.toList()..sort();

    await _client.from('food_schedule').insert({
      'id_food': foodId,
      'id_user_profile': studentId,
      'id_created_by': _userId,
      'schedule_type': 'weekly',
      'start_date': schedule.startDate.toIso8601String().split('T').first,
      'end_date': schedule.endDate.toIso8601String().split('T').first,
      'days_of_week': daysString.join(','),
    });
  }

  // ─── Overlap check ───

  /// Returns exercise IDs that already have a schedule overlapping with
  /// the given date range AND sharing at least one day of the week.
  Future<Set<String>> getAlreadyScheduledExerciseIds({
    required List<String> exerciseIds,
    required String studentId,
    required ScheduleDateResult schedule,
  }) async {
    if (exerciseIds.isEmpty) return {};

    final startStr = schedule.startDate.toIso8601String().split('T').first;
    final endStr = schedule.endDate.toIso8601String().split('T').first;

    // Fetch schedules that overlap in date range for these exercises+student
    final data = await _client
        .from('exercise_schedule')
        .select('id_exercise, days_of_week')
        .eq('id_user_profile', studentId)
        .inFilter('id_exercise', exerciseIds)
        .lte('start_date', endStr)
        .gte('end_date', startStr);

    final requestedDays = schedule.selectedDays;
    final overlapping = <String>{};

    for (final row in data) {
      final existingDaysStr = row['days_of_week'] as String? ?? '';
      final existingDays =
          existingDaysStr.split(',').where((s) => s.isNotEmpty).toSet();
      final requestedDaysStr =
          requestedDays.map((d) => d.toString()).toSet();

      // If they share at least one day → overlap
      if (existingDays.intersection(requestedDaysStr).isNotEmpty) {
        overlapping.add(row['id_exercise'] as String);
      }
    }
    return overlapping;
  }

  // ─── Assignment: Exercise Folder → Student ───

  /// Assigns exercises from a folder. Returns names of skipped exercises
  /// (already scheduled in the given interval).
  Future<List<String>> assignExerciseFolder({
    required String folderId,
    required String studentId,
    required ScheduleDateResult schedule,
  }) async {
    final exercises = await getFolderExercises(folderId);
    final daysString = schedule.selectedDays.toList()..sort();

    final alreadyScheduled = await getAlreadyScheduledExerciseIds(
      exerciseIds: exercises.map((e) => e.exercise.id).toList(),
      studentId: studentId,
      schedule: schedule,
    );

    final skippedNames = <String>[];

    for (final item in exercises) {
      if (alreadyScheduled.contains(item.exercise.id)) {
        skippedNames.add(item.exercise.name);
        continue;
      }

      await _assignSingleItem(
        item: item,
        studentId: studentId,
        daysString: daysString,
        schedule: schedule,
      );
    }
    return skippedNames;
  }

  /// Assigns a single exercise. Returns the exercise name if it was already
  /// scheduled (skipped), or null if assigned successfully.
  Future<String?> assignSingleExerciseItem({
    required FolderExerciseItem item,
    required String studentId,
    required ScheduleDateResult schedule,
  }) async {
    final already = await getAlreadyScheduledExerciseIds(
      exerciseIds: [item.exercise.id],
      studentId: studentId,
      schedule: schedule,
    );
    if (already.isNotEmpty) return item.exercise.name;

    final daysString = schedule.selectedDays.toList()..sort();
    await _assignSingleItem(
      item: item,
      studentId: studentId,
      daysString: daysString,
      schedule: schedule,
    );
    return null;
  }

  /// Internal helper — inserts schedule + sets for one exercise item.
  Future<void> _assignSingleItem({
    required FolderExerciseItem item,
    required String studentId,
    required List<int> daysString,
    required ScheduleDateResult schedule,
  }) async {
    final scheduleData = await _client
        .from('exercise_schedule')
        .insert({
          'id_exercise': item.exercise.id,
          'id_user_profile': studentId,
          'id_created_by': _userId,
          'schedule_type': 'weekly',
          'start_date':
              schedule.startDate.toIso8601String().split('T').first,
          'end_date':
              schedule.endDate.toIso8601String().split('T').first,
          'days_of_week': daysString.join(','),
        })
        .select('id')
        .single();

    final scheduleId = scheduleData['id'] as String;

    final List<Map<String, dynamic>> setRows;
    if (item.configSets.isNotEmpty) {
      setRows = item.configSets.map((s) {
        final row = <String, dynamic>{
          'id_exercise_schedule': scheduleId,
          'set_number': s.number,
        };
        if (s.reps != null && s.reps! > 0) row['repetitions'] = s.reps;
        if (s.kg != null && s.kg! > 0) row['weight'] = s.kg;
        if (s.mins != null && s.mins! > 0) row['minutes'] = s.mins;
        if (s.segs != null && s.segs! > 0) row['seconds'] = s.segs;
        return row;
      }).toList();
    } else {
      setRows = List.generate(item.sets, (i) {
        final row = <String, dynamic>{
          'id_exercise_schedule': scheduleId,
          'set_number': i + 1,
        };
        if (item.reps > 0) row['repetitions'] = item.reps;
        if (item.weight != null && item.weight! > 0) {
          row['weight'] = item.weight;
        }
        if (item.minutes != null && item.minutes! > 0) {
          row['minutes'] = item.minutes;
        }
        if (item.seconds != null && item.seconds! > 0) {
          row['seconds'] = item.seconds;
        }
        return row;
      });
    }
    await _client.from('exercise_set').insert(setRows);
  }

  // ─── Helpers ───

  Future<List<SelectedIngredient>> _getIngredientsForFood(
      String foodId) async {
    final data = await _client
        .from('detail_food_ingredient')
        .select('quantity, ingredient(*)')
        .eq('id_food', foodId);

    return data.map((json) {
      final ingredientJson = json['ingredient'] as Map<String, dynamic>;
      return SelectedIngredient(
        ingredient: Ingredient.fromJson(ingredientJson),
        quantity: (json['quantity'] as num).toDouble(),
      );
    }).toList();
  }
}
