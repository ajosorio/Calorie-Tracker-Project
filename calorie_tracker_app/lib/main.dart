import 'package:flutter/material.dart';

void main() {
  runApp(const HomeScreen());
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("Macro Mate")),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Login Screen stuff..."),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {
                  runApp(const AboutScreen());
                },
                child: Text("Go to About  Screen"),
              ),
            ],
          ),
        ),
      ),
    );
  }
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
                    runApp(const HomeScreen());
                  },
                  child: Text("Go to Home Screen"))
            ],
          ),
        ),
      ),
    );
  }
}
