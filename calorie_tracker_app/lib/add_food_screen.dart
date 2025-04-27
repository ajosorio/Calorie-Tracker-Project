// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'food.dart';
import 'widgets/food_dropdown.dart';

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
  List<dynamic> previousFoods = [];
  final TextEditingController controller = TextEditingController();
  List<dynamic> localResults = [];

  @override
  void initState() {
    super.initState();
    fetchPreviousFoods();
  }

  void addFoodForTheDay(Food food, bool previous) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("No user signed in."),
        ),
      );
      return;
    }
    if (mealSelction == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Please select a meal.",
          ),
        ),
      );
      return;
    }

    final now = DateTime.now();
    final justDate =
        "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

    final foodData = {
      'foodName': food.foodName,
      'fat': food.fat,
      'protein': food.protein,
      'carbs': food.carbs,
    };

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
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

      if (!previous) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('foodHistory')
            .doc(foodName)
            .set(
          {
            'foodName': foodName ?? 'Unknown food',
            'fat': fat ?? 0,
            'protein': protein ?? 0,
            'carbs': carbs ?? 0,
            'timeStamp': FieldValue.serverTimestamp(),
          },
        );

        _formKey.currentState?.reset();
        foodNameController.clear();
        fatController.clear();
        proteinController.clear();
        carbsController.clear();
      }

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          'Food Logged Successfully!',
        ),
      )); // Clear

      setState(() {
        mealSelction = null;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Error logging food: $e",
          ),
        ),
      );
    }

    setState(() {});
  }

  /// Fetches all previous logged foods for a user within their foodHistory collection. This is subject to change to foods previously logged through an arbitrary amount of time.
  Future<void> fetchPreviousFoods() async {
    try {
      final previousFoodsSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('foodHistory')
          .get();

      final foods =
          previousFoodsSnapshot.docs.map((foodDoc) => foodDoc.data()).toList();

      for (var food in foods) {
        previousFoods.add(Food(
            foodName: food['foodName'],
            protein: food['protein'],
            carbs: food['carbs'],
            fat: food['fat']));
      }
      setState(() {
        localResults = previousFoods;
      });
    } catch (e) {
      print(
        "Error fetching previous foods: $e",
      );
    }
  }

  void localQuery(String query) {
    setState(() {
      if (query.isEmpty) {
        localResults = previousFoods;
      } else {
        localResults = previousFoods.where(
          (
            food,
          ) {
            final foodName = food.foodName.toLowerCase();
            return foodName.contains(
              query.toLowerCase(),
            );
          },
        ).toList();
      }
    });
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
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(5, 15, 5, 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Search previous foods",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
              TextField(
                style: TextStyle(
                  color: Colors.white,
                ),
                controller: controller,
                cursorColor: Colors.teal,
                decoration: const InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Color.fromARGB(255, 71, 122, 110), width: 2.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.tealAccent,
                      width: 2.0,
                    ),
                  ),
                  hintText: "Enter a food",
                  hintStyle: TextStyle(
                    color: Colors.white,
                  ),
                ),
                onChanged: (value) {
                  localQuery(
                    controller.text,
                  );
                },
              ),
              foodDropdown(
                "Previously Logged",
                localResults,
                (food, previous) => addFoodForTheDay(
                  food,
                  previous,
                ),
              ),
              Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(
                    24.0,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              "Meal:",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
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
                                    value: "Snacks",
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
                        const SizedBox(
                          height: 20,
                        ),
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
                                onChanged: (
                                  value,
                                ) {},
                              ),
                            ),
                            const SizedBox(
                              width: 10,
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
                          mainAxisAlignment: MainAxisAlignment.center,
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

                                var food = Food(
                                  foodName: foodName!,
                                  carbs: carbs!,
                                  fat: fat!,
                                  protein: protein!,
                                );

                                // ✅ Only call the logger, which handles the SnackBar
                                addFoodForTheDay(food, false);
                              },
                              child: const Text(
                                "Log",
                                style: TextStyle(color: Colors.teal),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
