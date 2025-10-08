import 'package:get/get.dart';
import '../ui/screens/home_screen.dart';
import '../ui/screens/basic_calc_screen.dart';
import '../ui/screens/scientific_calc_screen.dart';
import '../ui/screens/unit_converter_screen.dart';
import '../ui/screens/financial_calc_screen.dart';
import '../ui/screens/programmer_calc_screen.dart';
import '../ui/screens/health_calc_screen.dart';
import '../ui/screens/settings_screen.dart';

part 'app_routes.dart';

class AppPages {
  static final routes = [
    GetPage(name: Routes.home, page: () => const HomeScreen()),
    GetPage(name: Routes.basic, page: () => const BasicCalcScreen()),
    GetPage(name: Routes.scientific, page: () => const ScientificCalcScreen()),
    GetPage(
      name: Routes.unitConverter,
      page: () => const UnitConverterScreen(),
    ),
    GetPage(name: Routes.financial, page: () => const FinancialCalcScreen()),
    GetPage(name: Routes.programmer, page: () => const ProgrammerCalcScreen()),
    GetPage(name: Routes.health, page: () => const HealthCalcScreen()),
    GetPage(name: Routes.settings, page: () => const SettingsScreen()),
  ];
}
