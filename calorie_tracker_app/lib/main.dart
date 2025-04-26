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
  int _selectedIndex = 0;

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

        for (var foodDoc in foodSnapshot.docs) {
          var foodData = foodDoc.data();
          var food = Food(
            foodName: foodData['foodName'],
            protein: foodData['protein'],
            carbs: foodData['carbs'],
            fat: foodData['fat'],
            docId: foodDoc.id, // ✅ Now setting docId too
          );
          foodList.add(food);
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
      appBar: _selectedIndex == 0
          ? AppBar(
              title: const Text(
                "Macro Mate",
                style: TextStyle(color: Colors.white, fontSize: 28),
              ),
              backgroundColor: Colors.teal,
            )
          : null,
      // show different screen depending on selectedIndex
      body: _selectedIndex == 0
          ? ListView(
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
                            height: 200,
                            width: 200,
                            child: noData
                                ? const Center(
                                    child: Text(
                                      "No data to display for today.",
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 16,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  )
                                : MyPieChart(dataMap: dataMap),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
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
                                      fontSize: 14,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: [
                                  const Icon(Icons.square,
                                      color: Color.fromARGB(255, 85, 214, 186)),
                                  Text(
                                    "Carbs: ${totalCarbs.toInt()}g",
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.square,
                                    color: Color.fromARGB(255, 129, 181, 233),
                                  ),
                                  Text(
                                    "Fats: ${totalFats.toInt()}g",
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                "Calories: ${calories.toInt()}",
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      thickness: 7,
                      color: Colors.teal,
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: meals.length,
                      itemBuilder: (context, index) {
                        return mealDropdown(
                          meals[index].getMealName!,
                          meals[index].getFoodList,
                          deleteFoodCallback: (mealName, docId) async {
                            final user = FirebaseAuth.instance.currentUser;
                            final justDate =
                                "${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')}";

                            final foodRef = FirebaseFirestore.instance
                                .collection('users')
                                .doc(user!.uid)
                                .collection('dates')
                                .doc(justDate)
                                .collection('meals')
                                .doc(mealName)
                                .collection('foods')
                                .doc(docId);

                            await FirebaseFirestore.instance
                                .runTransaction((transaction) async {
                              transaction.delete(foodRef);
                            });

                            print("Deleted food $docId successfully.");

                            await fetchFoods(); // re-fetch meals
                            setState(() {}); // refresh UI
                          },
                        );
                      },
                    )
                  ],
                ),
              ],
            )
          : _selectedIndex == 1
              ? const AddFoodScreen()
              : _selectedIndex == 2
                  ? const PreviouslyLoggedDaysScreen()
                  : const LoginScreen(),

      // bottom nav bar with icons
      bottomNavigationBar: _selectedIndex == 0
          ? BottomNavigationBar(
              backgroundColor: Colors.teal,
              selectedLabelStyle: const TextStyle(
                color: Colors.white,
              ),
              unselectedLabelStyle: const TextStyle(
                color: Colors.white,
              ),
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.home,
                    color: Colors.white,
                  ),
                  label: "Home",
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                  label: "Add Food",
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.calendar_today,
                    color: Colors.white,
                  ),
                  label: "Previous",
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.logout,
                    color: Colors.white,
                  ),
                  label: "Log Out",
                ),
              ],
              currentIndex: _selectedIndex,
              selectedItemColor: Colors.white,
              unselectedItemColor: Colors.white,
              onTap: (value) async {
                if (value == 3) {
                  // Log out
                  await FirebaseAuth.instance.signOut();
                  if (context.mounted) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                      (route) => false,
                    );
                  }
                } else if (value == 1) {
                  // Go to Add Food screen, then refresh on return
                  Navigator.of(context)
                      .push(
                    MaterialPageRoute(
                      builder: (context) => const AddFoodScreen(),
                    ),
                  )
                      .then((_) async {
                    await intializeMealsAndFetchFoods();
                    setState(() {
                      _selectedIndex = 0;
                    });
                  });
                } else if (value == 2) {
                  // Push Previous Meals screen
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const PreviouslyLoggedDaysScreen(),
                    ),
                  );
                } else {
                  setState(() => _selectedIndex = value);
                }
              },
              type: BottomNavigationBarType.fixed,
            )
          : null,
    );
  }
}
