// ignore_for_file: unused_field, prefer_final_fields, unnecessary_getters_setters

class Food {
  int _protein = 0;
  int _carbs = 0;
  int _fat = 0;
  int _sodium = 0;
  int _sugar = 0;
  int _fiber = 0;
  String _foodName = "food";
  String? _docId; // ✅ Add this

  Food({
    int protein = 0,
    int carbs = 0,
    int fat = 0,
    int sodium = 0,
    int sugar = 0,
    int fiber = 0,
    String foodName = "food",
    String? docId, // ✅ Add this too
  })  : _protein = protein,
        _carbs = carbs,
        _fat = fat,
        _sodium = sodium,
        _sugar = sugar,
        _fiber = fiber,
        _foodName = foodName,
        _docId = docId; // ✅

  String get foodName => _foodName;
  set foodName(String value) => _foodName = value;

  int get protein => _protein;
  set protein(int value) => _protein = value;

  int get carbs => _carbs;
  set carbs(int value) => _carbs = value;

  int get fat => _fat;
  set fat(int value) => _fat = value;

  int get sodium => _sodium;
  set sodium(int value) => _sodium = value;

  int get sugar => _sugar;
  set sugar(int value) => _sugar = value;

  int get fiber => _fiber;
  set fiber(int value) => _fiber = value;

  // ✅ Add getter and setter for docId
  String? get docId => _docId;
  set docId(String? value) => _docId = value;
}
