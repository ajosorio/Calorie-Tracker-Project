import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PreviouslyLoggedDaysScreen extends StatefulWidget {
  const PreviouslyLoggedDaysScreen({super.key});

  @override
  State<PreviouslyLoggedDaysScreen> createState() =>
      _PreviouslyLoggedDaysScreenState();
}

class _PreviouslyLoggedDaysScreenState
    extends State<PreviouslyLoggedDaysScreen> {
  final user = FirebaseAuth.instance.currentUser;

  // Fetch and organize the data by: date -> meal -> list of foods
  Future<Map<String, Map<String, List<Map<String, dynamic>>>>>
      fetchLoggedData() async {
    final result = <String, Map<String, List<Map<String, dynamic>>>>{};

    // Get all dates
    final dateSnapshots = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('dates')
        .get();

    print(dateSnapshots);
    // prints how many dates are retrieved for trouble shooting
    print('Total dates found: ${dateSnapshots.docs.length}');

    for (final dateDoc in dateSnapshots.docs) {
      final date = dateDoc.id;
      final Map<String, List<Map<String, dynamic>>> meals = {};

      // get meals for the current date
      final mealsSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .collection('dates')
          .doc(date)
          .collection('meals')
          .get();

      for (final mealDoc in mealsSnapshot.docs) {
        final mealName = mealDoc.id;

        // Get foods for the current meal
        final foodsSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .collection('dates')
            .doc(date)
            .collection('meals')
            .doc(mealName)
            .collection('foods')
            .get();

        final foods = foodsSnapshot.docs.map((f) => f.data()).toList();
        meals[mealName] = foods;
      }

      result[date] = meals;
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          "Previously Logged Days",
          style: TextStyle(color: Colors.white, fontSize: 28),
        ),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: FutureBuilder<Map<String, Map<String, List<Map<String, dynamic>>>>>(
        future: fetchLoggedData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(color: Colors.teal));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text("No meals logged yet.",
                  style: TextStyle(color: Colors.white)),
            );
          }

          final data = snapshot.data!;
          final sortedDates = data.keys.toList()
            ..sort((a, b) => b.compareTo(a)); // newest first

          return ListView(
            children: sortedDates.map((date) {
              final meals = data[date]!;

              return ExpansionTile(
                title: Text(
                  date,
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                backgroundColor: Colors.grey[900],
                collapsedBackgroundColor: Colors.black,
                iconColor: Colors.teal,
                collapsedIconColor: Colors.teal,
                children: meals.entries.map((entry) {
                  final mealName = entry.key;
                  final foods = entry.value;

                  return ExpansionTile(
                    title: Text(
                      mealName,
                      style: const TextStyle(color: Colors.teal),
                    ),
                    backgroundColor: Colors.black,
                    collapsedBackgroundColor: Colors.grey[850],
                    iconColor: Colors.white,
                    collapsedIconColor: Colors.white,
                    children: foods.isEmpty
                        ? [
                            const ListTile(
                              title: Text(
                                "No foods logged",
                                style: TextStyle(color: Colors.white54),
                              ),
                            )
                          ]
                        : foods.map((food) {
                            return ListTile(
                              title: Text(
                                food['foodName'] ?? 'Unnamed Food',
                                style: const TextStyle(color: Colors.white),
                              ),
                              subtitle: Text(
                                "Fat: ${food['fat']}g, Protein: ${food['protein']}g, Carbs: ${food['carbs']}g",
                                style: const TextStyle(color: Colors.white70),
                              ),
                            );
                          }).toList(),
                  );
                }).toList(),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
