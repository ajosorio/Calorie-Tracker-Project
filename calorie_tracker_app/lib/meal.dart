import 'package:calorie_tracker_app/food.dart';

class Meal {
  // Will hold food objects per meal
  /// all macronutrient values will be in grams unless specified/ i.e. sodium will likely be in milligrams


  // ignore: prefer_final_fields
  List<Food> _foodList = [];
  double _protein = 0;
  double _carbs = 0;
  double _fat = 0;
  double _calories = 0;
  String? _mealName;

    Meal(this._mealName);
  
  List get getFoodList{
    return _foodList;
  }

  double get getProtein => _protein;
  set protein(double value) => _protein = value;

  double get getCarbs => _carbs;
  set carbs(double value) => _carbs = value;

  double get getFat => _fat;
  set fat(double value) => _fat = value;

  double get getCalories => _calories;
  set calories(double value) => _calories = value;

  String? get getMealName => _mealName;
  set mealName(String? value) => _mealName = value;


  void calculateMealMacros(){
    // iterate through foodList and access each food items macro attributes to tally them for the respective meal
    // this method should be called everytime a food object is added OR deleted from a meal
  //     void calculateMealMacros() {
  //   _protein = _foodList.fold(0, (sum, food) => sum + food.protein);
  //   _carbs = _foodList.fold(0, (sum, food) => sum + food.carbs);
  //   _fat = _foodList.fold(0, (sum, food) => sum + food.fat);
  //   _calories = _foodList.fold(0, (sum, food) => sum + food.calories);
  // }
  }

  void addFood(Food food) {
    _foodList.add(food);
    calculateMealMacros();
  }

  void removeFood(Food food) {
    _foodList.remove(food);
    calculateMealMacros();
  }


}