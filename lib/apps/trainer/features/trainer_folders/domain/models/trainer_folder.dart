import 'package:flutter/foundation.dart';

@immutable
class TrainerFolder {
  const TrainerFolder({
    required this.id,
    required this.trainerId,
    required this.title,
    required this.folderType,
    this.description,
    this.itemCount = 0,
    this.createdAt,
  });

  final String id;
  final String trainerId;
  final String title;
  final String? description;
  final String folderType; // 'food' | 'exercise'
  final int itemCount;
  final DateTime? createdAt;

  factory TrainerFolder.fromJson(Map<String, dynamic> json) {
    return TrainerFolder(
      id: json['id'] as String,
      trainerId: json['trainer_id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      folderType: json['folder_type'] as String,
      itemCount: (json['item_count'] as num?)?.toInt() ?? 0,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toInsertJson() {
    return {
      'trainer_id': trainerId,
      'title': title,
      'description': description,
      'folder_type': folderType,
    };
  }

  TrainerFolder copyWith({
    String? id,
    String? trainerId,
    String? title,
    String? description,
    String? folderType,
    int? itemCount,
    DateTime? createdAt,
  }) {
    return TrainerFolder(
      id: id ?? this.id,
      trainerId: trainerId ?? this.trainerId,
      title: title ?? this.title,
      description: description ?? this.description,
      folderType: folderType ?? this.folderType,
      itemCount: itemCount ?? this.itemCount,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TrainerFolder &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
