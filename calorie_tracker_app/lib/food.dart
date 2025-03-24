// ignore_for_file: unused_field, prefer_final_fields, unnecessary_getters_setters

class Food {
  // A class to model food objects, contains information relating to nutrient values
  double _protein = 0;
  double _carbs = 0;
  double _fat = 0;
  double _sodium = 0;
  double _sugar = 0;
  double _fiber = 0;
  String _foodName = "food";

  Food({
    double protein = 0,
    double carbs = 0,
    double fat = 0,
    double sodium = 0,
    double sugar = 0,
    double fiber = 0,
    String foodName = "food",
  })  : _protein = protein,
        _carbs = carbs,
        _fat = fat,
        _sodium = sodium,
        _sugar = sugar,
        _fiber = fiber,
        _foodName = foodName;

  String get foodName => _foodName;
  set foodName(String value) => _foodName = value;

  double get protein => _protein;
  set protein(double value) => _protein = value;

  double get carbs => _carbs;
  set carbs(double value) => _carbs = value;

  double get fat => _fat;
  set fat(double value) => _fat = value;

  double get sodium => _sodium;
  set sodium(double value) => _sodium = value;

  double get sugar => _sugar;
  set sugar(double value) => _sugar = value;

  double get fiber => _fiber;
  set fiber(double value) => _fiber = value;

  Map<String, dynamic> foodDict() {
    return {
      "name": _foodName,
      "protein": _protein,
      "carbs": _carbs,
      "fat": _fat,
      "sodium": _sodium,
      "sugar": _sugar,
      "fiber": _fiber,
    };
  }
}
