import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
                        value: mealSelction,
                        hint: Text(
                          "Select meal",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        items: [
                          DropdownMenuItem(
                            value: "Breakfast",
                            child: Text(
                              "Breakfast",
                              style: TextStyle(
                                color: Colors.teal,
                              ),
                            ),
                          ),
                          DropdownMenuItem(
                            value: "Lunch",
                            child: Text(
                              "Lunch",
                              style: TextStyle(
                                color: Colors.teal,
                              ),
                            ),
                          ),
                          DropdownMenuItem(
                            value: "Dinner",
                            child: Text(
                              "Dinner",
                              style: TextStyle(
                                color: Colors.teal,
                              ),
                            ),
                          ),
                          DropdownMenuItem(
                            value: "Snack",
                            child: Text(
                              "Snack",
                              style: TextStyle(
                                color: Colors.teal,
                              ),
                            ),
                          )
                        ],
                        onChanged: (value) {
                          setState(
                            () {
                              mealSelction = value as String;
                            },
                          );
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
                      onPressed: () async {
                        if (mealSelction == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Please Select A Meal',
                              ),
                            ),
                          );
                          return;
                        }
                        foodName = foodNameController.text.trim();
                        fat = int.tryParse(fatController.text);
                        protein = int.tryParse(proteinController.text);
                        carbs = int.tryParse(carbsController.text);

                        if (foodName!.isEmpty ||
                            fat == null ||
                            protein == null ||
                            carbs == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Please Fill All Fields',
                              ),
                            ),
                          );
                          return;
                        }

                        _formKey.currentState?.reset();

                        final user = FirebaseAuth.instance.currentUser;
                        final now = DateTime.now();
                        final justDate =
                            "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

                        final foodData = {
                          'foodName': foodName ?? 'Unknown food',
                          'fat': fat ?? 0,
                          'protein': protein ?? 0,
                          'carbs': carbs ?? 0,
                        };

                        try {
                          await FirebaseFirestore.instance
                              .collection('users')
                              .doc(user!.uid)
                              .collection('dates')
                              .doc(justDate)
                              .collection('meals')
                              .doc(mealSelction!)
                              .set({
                            'mealName': mealSelction,
                          }, SetOptions(merge: true));

                          await FirebaseFirestore.instance
                              .collection('users')
                              .doc(user.uid)
                              .collection('dates')
                              .doc(justDate)
                              .collection('meals')
                              .doc(mealSelction!)
                              .collection('foods')
                              .add(foodData);

                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                              'Food Logged Successfully!',
                            ),
                          )); // Clear the form and selection
                          _formKey.currentState?.reset();
                          foodNameController.clear();
                          fatController.clear();
                          proteinController.clear();
                          carbsController.clear();

                          setState(() {
                            mealSelction = null;
                          });
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Error logging food: $e")),
                          );
                        }

                        // print(
                        //     'meal: $mealSelction, name: $foodName, carbs: $carbs, protein: $protein, fat: $fat');
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
