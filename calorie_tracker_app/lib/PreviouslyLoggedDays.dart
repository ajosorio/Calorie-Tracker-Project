import 'package:flutter/material.dart';

class PreviouslyLoggedDaysScreen extends StatelessWidget {
  const PreviouslyLoggedDaysScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Previously Logged Days")),
        body: ListView.builder(
            itemCount: 15,
            itemBuilder: (context, index) {
              return ListTile(
                tileColor: Colors.white,
                title: Text("Some meal"),
                subtitle: const Text("Some text"),
                leading: Text("A date"),
                trailing: Icon(Icons.more_vert),
              );
            }));
  }
}
