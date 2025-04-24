// ignore_for_file: unused_import, avoid_print

import 'package:calorie_tracker_app/add_food_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:calorie_tracker_app/food.dart';
import 'package:calorie_tracker_app/meal.dart';
import 'previously_logged_days.dart';
import 'signup_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login_screen.dart';
import 'widgets/meal_dropdown.dart';
import 'widgets/pie_chart.dart';

void main() async {
  runApp(const MaterialApp(title: "Firebase Example", home: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool firebaseReady = false;
  @override
  void initState() {
    super.initState();
    Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    ).then((value) => setState(() => firebaseReady = true));
  }

  @override
  Widget build(BuildContext context) {
    if (!firebaseReady) return const Center(child: CircularProgressIndicator());

    // currentUser will be null if no one is signed in.
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) return const LoginScreen();
    return const LoginScreen();
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Meal> meals = [
    Meal("Breakfast", []),
    Meal("Lunch", []),
    Meal("Dinner", []),
    Meal("Snacks", [])
  ];

  var justDate =
      '${DateTime.now().year}-${DateTime.now().month < 10 ? '0${DateTime.now().month}' : DateTime.now().month}-${DateTime.now().day < 10 ? '0${DateTime.now().day}' : DateTime.now().day}';

  User? user = FirebaseAuth.instance.currentUser;
  List<Map<String, dynamic>> foods = [];

  @override
  void initState() {
    super.initState();
    intializeMealsAndFetchFoods();
  }

  Future<void> intializeMealsAndFetchFoods() async {
    await initMeals();
    await fetchFoods();
  }

  Future<void> initMeals() async {
    try {
      // Write something into the date doc to prevent it from being italicized
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .collection('dates')
          .doc(justDate)
          .set({'createdAt': FieldValue.serverTimestamp()},
              SetOptions(merge: true));

      int c = 0;
      for (var meal in meals) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .collection('dates')
            .doc(justDate)
            .collection('meals')
            .doc(meal.getMealName)
            .set({
          'mealName': meal.getMealName,
          'order': c,
        }, SetOptions(merge: true));
        c++;
        setState(() {});
      }
      print('meals initialized');
    } catch (e) {
      print('Error initializing meals: $e');
    }
  }

  Future<void> fetchFoods() async {
    try {
      final mealsSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .collection('dates')
          .doc(justDate)
          .collection('meals')
          .orderBy('order')
          .get();

      List<Meal> fetchedMeals = [];
      for (var mealDoc in mealsSnapshot.docs) {
        List<Food> foodList = [];
        final mealName = mealDoc.id;

        final foodSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .collection('dates')
            .doc(justDate)
            .collection('meals')
            .doc(mealName)
            .collection('foods')
            .get();

        final foods =
            foodSnapshot.docs.map((foodDoc) => foodDoc.data()).toList();

        for (var food in foods) {
          foodList.add(Food(
              foodName: food['foodName'],
              protein: food['protein'],
              carbs: food['carbs'],
              fat: food['fat']));
        }

        fetchedMeals.add(Meal(mealName, foodList));
      }

      setState(() {
        meals = fetchedMeals;
      });
    } catch (e) {
      print('Error fetching meals: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // print out all foods (for debugging)
    for (var meal in meals) {
      print(meal.getFoodList);
    }

    // sum the macros for the current day from all meals
    double totalProtein = 0;
    double totalCarbs = 0;
    double totalFats = 0;

    for (var meal in meals) {
      for (var food in meal.getFoodList) {
        totalProtein += food.protein.toDouble();
        totalCarbs += food.carbs.toDouble();
        totalFats += food.fat.toDouble();
      }
    }

    // this map feeds the pie chart
    final Map<String, double> dataMap = {
      "Protein": totalProtein,
      "Fats": totalFats,
      "Carbs": totalCarbs,
    };

    // calc calories using standard values
    final double calories =
        (totalProtein * 4) + (totalCarbs * 4) + (totalFats * 9);

    final bool noData = totalProtein == 0 && totalCarbs == 0 && totalFats == 0;

    return Scaffold(
      backgroundColor: Colors.black12,
      appBar: AppBar(
        title: const Text(
          "Macro Mate",
          style: TextStyle(color: Colors.white, fontSize: 28),
        ),
        backgroundColor: Colors.teal,
      ),
      body: ListView(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(),
                child:
                    // this row contains the pie chart and macro values
                    Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // pie chart or message if no data
                    SizedBox(
                      height: 250,
                      width: 230,
                      child: noData
                          ? const Center(
                              child: Text(
                                "No foods logged yet today.",
                                style: TextStyle(
                                    color: Colors.white70, fontSize: 16),
                                textAlign: TextAlign.center,
                              ),
                            )
                          : MyPieChart(dataMap: dataMap),
                    ),
                    const SizedBox(width: 20),
                    // column displaying macro breakdown as text
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.square,
                                color: Color.fromARGB(255, 10, 134, 251)),
                            Text(
                              "Protein: ${totalProtein.toInt()}g",
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.white),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            const Icon(Icons.square,
                                color: Color.fromARGB(255, 85, 214, 186)),
                            Text(
                              "Carbs: ${totalCarbs.toInt()}g",
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.white),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            const Icon(Icons.square,
                                color: Color.fromARGB(255, 129, 181, 233)),
                            Text(
                              "Fats: ${totalFats.toInt()}g",
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.white),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Text(
                          "Calories: ${calories.toInt()} kcal",
                          style: const TextStyle(
                              fontSize: 14, color: Colors.white),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Divider(thickness: 7, color: Colors.teal),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: meals.length,
                itemBuilder: (context, index) {
                  return mealDropdown(
                    meals[index].getMealName!.toUpperCase(),
                    meals[index].getFoodList,
                  );
                },
              )
            ],
          ),
        ],
      ),
      // bottom nav bar with icons
      bottomNavigationBar: BottomAppBar(
        color: Colors.teal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
                icon: const Icon(
                  Icons.home,
                  color: Colors.white,
                ),
                onPressed: () {}),
            IconButton(
              icon: const Icon(Icons.add, color: Colors.white, size: 32),
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(
                      builder: (context) => const AddFoodScreen(),
                    ))
                    .then((_) => fetchFoods());
              },
            ),
            IconButton(
              icon: const Icon(Icons.calendar_today, color: Colors.white),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const PreviouslyLoggedDaysScreen(),
                  ),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.logout, color: Colors.white),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
