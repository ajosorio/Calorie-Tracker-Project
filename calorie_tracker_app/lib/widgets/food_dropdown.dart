import 'package:calorie_tracker_app/food.dart';
import 'package:flutter/material.dart';

Widget foodDropdown(
    String title, List<dynamic> foods, Function(Food, bool) onFoodSelected) {
  return Padding(
    padding: const EdgeInsets.symmetric(
      horizontal: 20,
      vertical: 10,
    ),
    child: ExpansionTile(
      collapsedIconColor: Colors.white,
      iconColor: Colors.white,
      title: Text(
        title,
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
          height: foods.isNotEmpty ? 300 : 70,
          child: foods.isNotEmpty
              ? ListView.separated(
                  itemCount: foods.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      tileColor: Colors.black,
                      title: Text(
                        foods[index].foodName,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 17,
                        ),
                      ),
                      subtitle: Text(
                        "F: ${foods[index].fat} P: ${foods[index].protein} C: ${foods[index].carbs}",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      // This will icon will display a dropdown to delete a food item
                      trailing: IconButton(
                        splashColor: Colors.tealAccent,
                        icon: Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 40,
                        ),
                        onPressed: () => onFoodSelected(
                          foods[index],
                          true,
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (
                    BuildContext context,
                    int index,
                  ) =>
                      const Divider(),
                )
              : const Center(
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
