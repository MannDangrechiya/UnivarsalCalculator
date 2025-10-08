import 'package:get/get.dart';
import '../controllers/calc_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(CalcController()); // Register controller globally
  }
}
