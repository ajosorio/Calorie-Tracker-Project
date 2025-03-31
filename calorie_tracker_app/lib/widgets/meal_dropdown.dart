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
          child: foods.isEmpty
              ? ListView.separated(
                  // this will be set to print all the food objects for the respective meal
                  itemCount: foods.length,
                  itemBuilder: (context, index) {
                    if (foods.isNotEmpty) {
                      return ListTile(
                        tileColor: Colors.black,
                        title: Text(
                          foods[index].foodName,
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 17),
                        ),
                        subtitle: Text(
                          "F: ${foods[index].fat} P: ${foods[index].protein} C: ${foods[index].carbs}",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.w600),
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
                    }
                  },
                  separatorBuilder: (
                    BuildContext context,
                    int index,
                  ) =>
                      const Divider(),
                )
              : Center(
                  child: Text(
                    'NO DATA',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
        ),
      ],
    ),
  );
}
