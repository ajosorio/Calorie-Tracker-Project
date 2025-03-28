import 'package:flutter/material.dart';


Widget mealDropdown(String mealName, List<dynamic> foods) {
  // foods = List.from(foods);
  // print(foods[0].foodName);

  return Padding(
    padding: const EdgeInsets.symmetric(
      horizontal: 20,
      vertical: 10,
    ),
    child: ExpansionTile(
      collapsedIconColor: Colors.white,
      iconColor: Colors.white,
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
          child: ListView.separated(
            // this will be set to print all the food objects for the respective meal
            itemCount: foods.length,
            itemBuilder: (context, index) {
              return ListTile(
                tileColor: Colors.black,
                title: Text(
                  foods.isNotEmpty ? foods[index]['foodName'] : 'text',
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
            separatorBuilder: (
              BuildContext context,
              int index,
            ) =>
                const Divider(),
          ),
        ),
      ],
    ),
  );
}