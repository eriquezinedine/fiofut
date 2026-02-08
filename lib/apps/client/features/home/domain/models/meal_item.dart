/// Represents a meal or exercise item in the feed.
class MealItem {
  const MealItem({
    required this.id,
    required this.name,
    required this.description,
    required this.calories,
    required this.imageUrl,
    required this.type,
    this.protein = 0,
    this.carbs = 0,
    this.fat = 0,
    this.isCompleted = false,
    this.time,
  });

  /// Unique identifier for the meal item
  final String id;

  /// Name of the meal or exercise
  final String name;

  /// Description or details
  final String description;

  /// Calories for the meal or burned in exercise
  final int calories;

  /// Image URL for the meal/exercise
  final String imageUrl;

  /// Type of item (meal or exercise)
  final MealItemType type;

  /// Protein in grams
  final int protein;

  /// Carbohydrates in grams
  final int carbs;

  /// Fat in grams
  final int fat;

  /// Whether the meal/exercise is completed
  final bool isCompleted;

  /// Time of the meal/exercise
  final String? time;

  MealItem copyWith({
    String? id,
    String? name,
    String? description,
    int? calories,
    String? imageUrl,
    MealItemType? type,
    int? protein,
    int? carbs,
    int? fat,
    bool? isCompleted,
    String? time,
  }) {
    return MealItem(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      calories: calories ?? this.calories,
      imageUrl: imageUrl ?? this.imageUrl,
      type: type ?? this.type,
      protein: protein ?? this.protein,
      carbs: carbs ?? this.carbs,
      fat: fat ?? this.fat,
      isCompleted: isCompleted ?? this.isCompleted,
      time: time ?? this.time,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! MealItem) return false;

    return other.id == id &&
        other.name == name &&
        other.description == description &&
        other.calories == calories &&
        other.imageUrl == imageUrl &&
        other.type == type &&
        other.protein == protein &&
        other.carbs == carbs &&
        other.fat == fat &&
        other.isCompleted == isCompleted &&
        other.time == time;
  }

  @override
  int get hashCode => Object.hash(
        id,
        name,
        description,
        calories,
        imageUrl,
        type,
        protein,
        carbs,
        fat,
        isCompleted,
        time,
      );

  @override
  String toString() => 'MealItem('
      'id: $id, '
      'name: $name, '
      'description: $description, '
      'calories: $calories, '
      'imageUrl: $imageUrl, '
      'type: $type, '
      'protein: $protein, '
      'carbs: $carbs, '
      'fat: $fat, '
      'isCompleted: $isCompleted, '
      'time: $time)';
}

/// Type of meal item.
enum MealItemType {
  /// Food/meal item
  meal,

  /// Exercise/workout item
  exercise,
}
