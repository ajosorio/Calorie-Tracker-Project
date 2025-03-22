// ignore_for_file: unused_import, avoid_print

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pie_chart/pie_chart.dart';

import 'package:calorie_tracker_app/food.dart';
import 'package:calorie_tracker_app/meal.dart';
import 'previously_logged_days.dart';
import 'signup_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MaterialApp(title: "Firebase Example", home: LoginScreen()));
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Meal> meals = [
    Meal("Breakfast"),
    Meal("Lunch"),
    Meal("Dinner"),
    Meal("Snacks")
  ];

  @override
  Widget build(BuildContext context) {
    // set macros here for pie chart
    final Map<String, double> dataMap = {
      "Protein": 40,
      "Fats": 25,
      "Carbs": 35,
    };
    // get values for the dataMap
    final double protein = dataMap["Protein"]!;
    final double fats = dataMap["Fats"]!;
    final double carbs = dataMap["Carbs"]!;
    // calc calories using standard values
    final double calories = (protein * 4) + (carbs * 4) + (fats * 9);

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
                padding: EdgeInsets.symmetric(),
                child:
                    // this row contains the pie chart and macro values
                    Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // pie chart
                    SizedBox(
                      height: 250,
                      width: 230,
                      child: _MyPieChart(dataMap: dataMap),
                    ),
                    const SizedBox(width: 20),
                    // colummn displaying macro breakdown as text
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.square,
                              color: Color.fromARGB(255, 10, 134, 251),
                            ),
                            Text(
                              "Protein: ${protein.toInt()}g",
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.square,
                              color: Color.fromARGB(255, 85, 214, 186),
                            ),
                            Text(
                              "Carbs: ${carbs.toInt()}g",
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            Icon(
                              Icons.square,
                              color: Color.fromARGB(255, 129, 181, 233),
                            ),
                            Text(
                              "Fats: ${fats.toInt()}g",
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Text(
                          "Calories: ${calories.toInt()} kcal",
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
              // list of meal breakdown
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: 4,
                itemBuilder: (context, index) {
                  return mealDropdown("${meals[index].getMealName}");
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
              icon: const Icon(
                Icons.track_changes,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const AddFoodScreen(),
                  ),
                );
              },
            ),
            IconButton(
                icon: const Icon(
                  Icons.calendar_today,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const PreviouslyLoggedDaysScreen(),
                    ),
                  );
                }),
            IconButton(
                icon: const Icon(
                  Icons.logout,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  );
                }),
          ],
        ),
      ),
    );
  }
}

// function to create dropdown menu
Widget mealDropdown(String mealName) {
  return Padding(
    padding: const EdgeInsets.symmetric(
      horizontal: 20,
      vertical: 10,
    ),
    child: ExpansionTile(
      title: Text(
        mealName,
        style: TextStyle(
          color: Colors.white,
          fontSize: 22,
          fontWeight: FontWeight.w600,
        ),
      ),
      children: [
        // display meal name
        // dropdown to select a meal
        SizedBox(
          height: 200,
          child: ListView.builder(
            // this will be set to print all the food objects for the respective meal
            itemCount: 5,
            itemBuilder: (context, index) {
              return ListTile(
                tileColor: Colors.black,
                title: Text(
                  "food",
                  style: TextStyle(color: Colors.white),
                ),
                subtitle: const Text(
                  "F: 5 P: 21 C: 34",
                  style: TextStyle(color: Colors.white),
                ),
                leading: Text(
                  "IDK",
                  style: TextStyle(color: Colors.white),
                ),
                // This will icon will display a dropdown to delete a food item
                trailing: Icon(
                  Icons.delete_outlined,
                  color: Colors.white,
                ),
              );
            },
          ),
        ),
      ],
    ),
  );
}

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("This page was made by Alejandro"),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Go to Home Screen"))
            ],
          ),
        ),
      ),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String? email;
  String? password;
  String? error;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                style: TextStyle(
                  color: Colors.white,
                ),
                cursorColor: Colors.teal,
                decoration: const InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey,
                    ),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.teal),
                  ),
                  hintText: 'Enter your email',
                  hintStyle: TextStyle(
                    color: Colors.white,
                  ),
                ),
                maxLength: 64,
                onChanged: (value) => email = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null; // Returning null means "no issues"
                },
              ),
              TextFormField(
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  cursorColor: Colors.teal,
                  decoration: const InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                        color: Colors.teal,
                      )),
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                        color: Colors.grey,
                      )),
                      hintText: "Enter a password",
                      hintStyle: TextStyle(
                        color: Colors.white,
                      )),
                  obscureText: true,
                  onChanged: (value) => password = value,
                  validator: (value) {
                    if (value == null || value.length < 8) {
                      return 'Your password must contain at least 8 characters.';
                    }
                    return null; // Returning null means "no issues"
                  }),
              const SizedBox(height: 16),
              ElevatedButton(
                  child: const Text(
                    'Login',
                    style: TextStyle(
                      color: Colors.teal,
                    ),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      tryLogin();
                    }
                  }),
              if (error != null)
                Text(
                  "Error: $error",
                  style: TextStyle(
                    color: Colors.red[800],
                    fontSize: 12,
                  ),
                ),
              ElevatedButton(
                  child: const Text(
                    'Sign up',
                    style: TextStyle(
                      color: Colors.teal,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const SignupScreen()));
                  })
            ],
          ),
        ),
      ),
    );
  }

  void tryLogin() async {
    try {
      // The await keyword blocks execution to wait for
      // signInWithEmailAndPassword to complete its asynchronous execution and
      // return a result.
      //
      // FirebaseAuth will raise an exception if the email or password
      // are determined to be invalid, e.g., the email doesn't exist.
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email!,
        password: password!,
      );
      print("Logged in ${credential.user}");
      error = null; // clear the error message if exists.
      setState(() {}); // Trigger a rebuild

      // We need this next check to use the Navigator in an async method.
      // It basically makes sure LoginScreen is still visible.
      if (!mounted) return;

      // pop the navigation stack so people cannot "go back" to the login screen
      // after logging in.
      Navigator.of(context).pop();
      // Now go to the HomeScreen.
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => const HomeScreen(),
      ));
    } on FirebaseAuthException catch (e) {
      // Exceptions are raised if the Firebase Auth service
      // encounters an error. We need to display these to the user.
      if (e.code == 'user-not-found') {
        error = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        error = 'Wrong password provided for that user.';
      } else {
        error = 'An error occurred: ${e.message}';
      }

      // Call setState to redraw the widget, which will display
      // the updated error text.
      setState(() {});
    }
  }
}

// stateless widget to create pie chart
class _MyPieChart extends StatelessWidget {
  // data for pie chart
  final Map<String, double> dataMap;

  const _MyPieChart({required this.dataMap});

  @override
  Widget build(BuildContext context) {
    // defines colors for pie chart
    final List<Color> colorList = [
      const Color.fromARGB(255, 10, 134, 251), // Protein
      const Color.fromARGB(255, 129, 181, 233), // Fats
      const Color.fromARGB(255, 85, 214, 186), // Carbs
    ];

    return PieChart(
      // macro data for visualization
      dataMap: dataMap,
      chartRadius: 200,
      centerText: "Macros",
      ringStrokeWidth: 16,
      animationDuration: const Duration(seconds: 2),
      // options for displaying chart values
      chartValuesOptions: const ChartValuesOptions(
        showChartValues: true,
        showChartValuesOutside: false,
        showChartValuesInPercentage: false,
      ),
      // options for chart legend
      legendOptions: const LegendOptions(
        showLegends: false,
      ),
      colorList: colorList,
    );
  }
}

class AddFoodScreen extends StatefulWidget {
  const AddFoodScreen({super.key});

  @override
  State<AddFoodScreen> createState() => _AddFoodScreenState();
}

class _AddFoodScreenState extends State<AddFoodScreen> {
  // Controllers for user input
  final TextEditingController foodNameController = TextEditingController();
  final TextEditingController fatController = TextEditingController();
  final TextEditingController proteinController = TextEditingController();
  final TextEditingController carbsController = TextEditingController();

  // Favorites list and selected favorite
  final List<String> favoriteFoods = [];
  String? selectedFavorite;

  // Handle when a favorite is selected
  void _onFavoriteSelected(String? value) {
    if (value == null) return;

    setState(() {
      selectedFavorite = value;
      foodNameController.text = value;

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
        SnackBar(content: Text('$foodName added to favorites')),
      );
    }
  }

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
      body: Padding(
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
                  const SizedBox(width: 10),
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
                        child: Text(food),
                      );
                    }).toList(),
                    onChanged: _onFavoriteSelected,
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Food name input with scan button
              Row(
                children: [
                  Expanded(
                    child: TextField(
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
                    ),
                  ),
                  const SizedBox(width: 10),
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
              TextField(
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
              const SizedBox(height: 10),

              const Text(
                "Protein",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              TextField(
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
              TextField(
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
                      // TODO: Add log functionality
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
    );
  }
}










// class SignupScreen extends StatefulWidget {
//   const SignupScreen({super.key});

//   @override
//   State<SignupScreen> createState() => _SignupScreenState();
// }

// class _SignupScreenState extends State<SignupScreen> {
//   String? email;
//   String? password;
//   String? repeatPassword;
//   String? error;
//   final _formKey = GlobalKey<FormState>();
//   @override
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               TextFormField(
//                   decoration:
//                       const InputDecoration(hintText: 'Enter your email'),
//                   maxLength: 64,
//                   onChanged: (value) => email = value,
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter some text';
//                     }
//                     return null; // Returning null means "no issues"
//                   }),
//               TextFormField(
//                   decoration:
//                       const InputDecoration(hintText: "Enter a password"),
//                   obscureText: true,
//                   onChanged: (value) => password = value,
//                   validator: (value) {
//                     if (value == null || value.length < 8) {
//                       return 'Your password must contain at least 8 characters.';
//                     }
//                     return null; // Returning null means "no issues"
//                   }),
//               TextFormField(
//                   decoration:
//                       const InputDecoration(hintText: "Confirm password"),
//                   obscureText: true,
//                   onChanged: (value) => repeatPassword = value,
//                   validator: (value) {
//                     if (value == null || value.length < 8) {
//                       return 'Your password must contain at least 8 characters.';
//                     } else if (password != repeatPassword) {
//                       return "Your passwords must match";
//                     }
//                     return null; // Returning null means "no issues"
//                   }),
//               const SizedBox(height: 16),
//               ElevatedButton(
//                   child: const Text('Sign up'),
//                   onPressed: () {
//                     if (_formKey.currentState!.validate()) {
//                       trySignup();
//                     }
//                   }),
//               if (error != null)
//                 Text(
//                   "Error: $error",
//                   style: TextStyle(color: Colors.red[800], fontSize: 12),
//                 )
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   void trySignup() async {
//     try {
//       // The await keyword blocks execution to wait for
//       // signInWithEmailAndPassword to complete its asynchronous execution and
//       // return a result.
//       //
//       // FirebaseAuth will raise an exception if the email or password
//       // are determined to be invalid, e.g., the email doesn't exist.
//       final credential = await FirebaseAuth.instance
//           .createUserWithEmailAndPassword(email: email!, password: password!);
//       print("Created account ${credential.user}");
//       error = null; // clear the error message if exists.
//       setState(() {}); // Trigger a rebuild

//       // We need this next check to use the Navigator in an async method.
//       // It basically makes sure LoginScreen is still visible.
//       if (!mounted) return;

//       // pop the navigation stack so people cannot "go back" to the login screen
//       // after logging in.
//       Navigator.of(context).pop();
//       // Now go to the HomeScreen.
//       Navigator.of(context).push(MaterialPageRoute(
//         builder: (context) => const HomeScreen(),
//       ));
//     } on FirebaseAuthException catch (e) {
//       // Exceptions are raised if the Firebase Auth service
//       // encounters an error. We need to display these to the user.
//       if (e.code == 'user-not-found') {
//         error = 'No user found for that email.';
//       } else if (e.code == 'wrong-password') {
//         error = 'Wrong password provided for that user.';
//       } else {
//         error = 'An error occurred: ${e.message}';
//       }

//       // Call setState to redraw the widget, which will display
//       // the updated error text.
//       setState(() {});
//     }
//   }
// }