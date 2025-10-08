import 'package:flutter/material.dart';
import '../widgets/category_card.dart';
import 'basic_calc_screen.dart';
import 'scientific_calc_screen.dart';
import 'unit_converter_screen.dart';
import 'financial_calc_screen.dart';
import 'programmer_calc_screen.dart';
import 'health_calc_screen.dart';
import 'business_calc_screen.dart';
import 'conversion_calc_screen.dart';
import 'engineering_calc_screen.dart';
import 'fun_calc_screen.dart';
import 'graphing_calc_screen.dart';
import 'statistics_calc_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  List<Map<String, dynamic>> get categories => [
    {
      'title': 'Basic',
      'icon': Icons.calculate,
      'screen': const BasicCalcScreen(),
    },
    {
      'title': 'Scientific',
      'icon': Icons.science,
      'screen': const ScientificCalcScreen(),
    },
    {
      'title': 'Unit Converter',
      'icon': Icons.swap_horiz,
      'screen': const UnitConverterScreen(),
    },
    {
      'title': 'Financial',
      'icon': Icons.attach_money,
      'screen': const FinancialCalcScreen(),
    },
    {
      'title': 'Programmer',
      'icon': Icons.computer,
      'screen': const ProgrammerCalcScreen(),
    },
    {
      'title': 'Health',
      'icon': Icons.health_and_safety,
      'screen': const HealthCalcScreen(),
    },
    {
      'title': 'Business',
      'icon': Icons.business,
      'screen': const BusinessCalcScreen(),
    },
    {
      'title': 'Conversion',
      'icon': Icons.compare_arrows,
      'screen': const ConversionCalcScreen(),
    },
    {
      'title': 'Engineering',
      'icon': Icons.engineering,
      'screen': const EngineeringCalcScreen(),
    },
    {
      'title': 'Functional',
      'icon': Icons.functions,
      'screen': const FunCalcScreen(),
    },
    {
      'title': 'Graphing',
      'icon': Icons.graphic_eq,
      'screen': const GraphingCalcScreen(),
    },
    {
      'title': 'Statistics',
      'icon': Icons.stacked_line_chart,
      'screen': const StatisticsCalcScreen(),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Universal Calculator',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          itemCount: categories.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio:
                MediaQuery.of(context).size.width /
                (MediaQuery.of(context).size.height * 0.55),
          ),
          itemBuilder: (context, index) {
            final category = categories[index];
            return CategoryCard(
              title: category['title'],
              icon: category['icon'],
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => category['screen']),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
