import 'package:financial_apps/controllers/category_controller.dart';
import 'package:financial_apps/controllers/history_controller.dart';
import 'package:financial_apps/controllers/total_per_type_controller.dart';
import 'package:financial_apps/controllers/transaction_controller.dart';
import 'package:get/get.dart';

class InitialBinding implements Bindings {
  @override
  void dependencies() async {
    // Get.put<TransactionController>(TransactionController());
    // Get.put<CategoryController>(CategoryController());
    // Get.put<HistoryController>(HistoryController());
    // Get.put<TotalPerTypeController>(TotalPerTypeController());
    // Get.lazyPut(() => TransactionController());
    Get.lazyPut(() => CategoryController());
    Get.lazyPut(() => HistoryController());
    Get.lazyPut(() => TotalPerTypeController());
  }
}
