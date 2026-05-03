enum MetricType {
  water,
  steps,
  calories;

  String get firestoreValue {
    switch (this) {
      case MetricType.water:
        return 'water';
      case MetricType.steps:
        return 'steps';
      case MetricType.calories:
        return 'calories';
    }
  }

  static MetricType? fromFirestore(String? value) {
    switch (value) {
      case 'water':
        return MetricType.water;
      case 'steps':
        return MetricType.steps;
      case 'calories':
        return MetricType.calories;
      default:
        return null;
    }
  }
}
