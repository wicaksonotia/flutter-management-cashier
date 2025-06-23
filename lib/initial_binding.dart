import 'package:cashier_management/controllers/login_controller.dart';
import 'package:get/get.dart';

class InitialBinding implements Bindings {
  @override
  void dependencies() async {
    Get.put<LoginController>(LoginController());
    // Get.lazyPut(() => CategoryController());
    // Get.lazyPut(() => HistoryController());
    // Get.lazyPut(() => TotalPerTypeController());
    // Get.lazyPut(() => MonitoringOutletController());
  }
}
