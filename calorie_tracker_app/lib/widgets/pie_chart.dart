import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

// stateless widget to create pie chart
class MyPieChart extends StatelessWidget {
  // data for pie chart
  final Map<String, double> dataMap;

  const MyPieChart({super.key, required this.dataMap});

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
      chartRadius: 215,
      centerText: "Macros",
      ringStrokeWidth: 16,
      animationDuration: const Duration(
        seconds: 2,
      ),
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
