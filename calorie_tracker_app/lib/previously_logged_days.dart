import 'package:flutter/material.dart';

class PreviouslyLoggedDaysScreen extends StatelessWidget {
  const PreviouslyLoggedDaysScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          "Previously Logged Days",
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: ListView.separated(
        itemCount: 15,
        itemBuilder: (
          context,
          index,
        ) {
          return ListTile(
            tileColor: Colors.black,
            title: Text(
              "Some meal",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            subtitle: const Text(
              "Some text",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            leading: Text(
              "A date",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            trailing: Icon(
              Icons.more_vert,
              color: Colors.white,
            ),
          );
        },
        separatorBuilder: (
          BuildContext context,
          int index,
        ) =>
            const Divider(),
      ),
    );
  }
}
