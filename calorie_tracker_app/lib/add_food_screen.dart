import 'dart:ffi';

import 'package:flutter/material.dart';

class AddFoodScreen extends StatefulWidget {
  const AddFoodScreen({super.key});

  @override
  State<AddFoodScreen> createState() => _AddFoodScreenState();
}

class _AddFoodScreenState extends State<AddFoodScreen> {
  // controllers for user input
  final TextEditingController foodNameController = TextEditingController();
  final TextEditingController fatController = TextEditingController();
  final TextEditingController proteinController = TextEditingController();
  final TextEditingController carbsController = TextEditingController();

  String? mealSelction;
  String? foodName;
  int? protein;
  int? carbs;
  int? fat;
  final _formKey = GlobalKey<FormState>();

  // favorites list and selected favorite
  final List<String> favoriteFoods = [];
  String? selectedFavorite;

  // Handle when a favorite is selected
  void _onFavoriteSelected(String? value) {
    if (value == null) return;

    setState(() {
      selectedFavorite = value;
      // foodNameController.text = value;

      // Example: You can also load macros if you saved them with food later
      // For now, just fill in dummy values when selecting a favorite
      fatController.text = "5";
      proteinController.text = "10";
      carbsController.text = "15";
    });
  }

  // Add current food to favorites
  void _addToFavorites() {
    final foodName = foodNameController.text.trim();
    if (foodName.isNotEmpty && !favoriteFoods.contains(foodName)) {
      setState(() {
        favoriteFoods.add(foodName);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '$foodName added to favorites',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          "Add Food",
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
          ),
        ),
        backgroundColor: Colors.teal,
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Favorites dropdown
                Row(
                  children: [
                    const Text(
                      "Favorites: ",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    DropdownButton<String>(
                      value: selectedFavorite,
                      hint: const Text(
                        "Select favorite",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      items: favoriteFoods.map((String food) {
                        return DropdownMenuItem<String>(
                          value: food,
                          child: Text(
                            food,
                          ),
                        );
                      }).toList(),
                      onChanged: _onFavoriteSelected,
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      "Meal:",
                      style: TextStyle(color: Colors.white),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                      child: DropdownButton(
                        hint: Text(
                          "Select meal",
                          style: TextStyle(color: Colors.white),
                        ),
                        items: [
                          DropdownMenuItem(
                            value: "Breakfast",
                            child: Text("Breakfast"),
                          ),
                          DropdownMenuItem(
                            value: "Lunch",
                            child: Text("Lunch"),
                          )
                        ],
                        onChanged: (value) {
                          // TODO: Handle meal selection
                          mealSelction = value;
                          
                        },
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 20),
                // Food name input with scan button
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        controller: foodNameController,
                        cursorColor: Colors.teal,
                        decoration: const InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.teal,
                            ),
                          ),
                          fillColor: Colors.white,
                          labelText: "Food name",
                          labelStyle: TextStyle(
                            color: Colors.white,
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.white,
                            ),
                          ),
                        ),
                        onChanged: (value) {},
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // TODO: Add scan functionality
                      },
                      child: const Text(
                        "Scan",
                        style: TextStyle(
                          color: Colors.teal,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                // Macronutrient input fields
                const Text(
                  "Fat",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                TextFormField(
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  controller: fatController,
                  keyboardType: TextInputType.number,
                  cursorColor: Colors.teal,
                  decoration: const InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.teal,
                      ),
                    ),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),

                const Text(
                  "Protein",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                TextFormField(
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  controller: proteinController,
                  keyboardType: TextInputType.number,
                  cursorColor: Colors.teal,
                  decoration: const InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.teal,
                      ),
                    ),
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "Carbs",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                TextFormField(
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  controller: carbsController,
                  keyboardType: TextInputType.number,
                  cursorColor: Colors.teal,
                  decoration: const InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.teal,
                      ),
                    ),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),

                // Buttons: Log + Add to Favorites
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        foodName = foodNameController.text;
                        fat = int.parse(fatController.text);
                        protein = int.parse(proteinController.text);
                        carbs = int.parse(carbsController.text);

                        _formKey.currentState?.reset();

                        // Dispose of controllers after use
                        // foodNameController.dispose();
                        // fatController.dispose();
                        // proteinController.dispose();
                        // carbsController.dispose();

                        // TODO: Add log functionality... add to database. Do necessary local actions
                        // call a method here to add food to the database
                        // questions for professor, is this a good place to instantiate a food object, or when it comes back from the db?
                        print(
                            'meal: $mealSelction, name: $foodName, carbs: $carbs, protein: $protein, fat: $fat');
                      },
                      child: const Text(
                        "Log",
                        style: TextStyle(
                          color: Colors.teal,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: _addToFavorites,
                      child: const Text(
                        "Add to Favorites",
                        style: TextStyle(
                          color: Colors.teal,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
