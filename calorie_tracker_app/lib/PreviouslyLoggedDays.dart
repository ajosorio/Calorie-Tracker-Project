import 'package:flutter/material.dart';

class PreviouslyLoggedDaysScreen extends StatelessWidget {
  const PreviouslyLoggedDaysScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Previously Logged Days")),
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
              child: Text("Go to Home Screen"),
            ),
          ],
        ),
      ),
    );
  }
}