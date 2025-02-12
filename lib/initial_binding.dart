import 'package:financial_apps/controllers/category_controller.dart';
import 'package:financial_apps/controllers/transaction_controller.dart';
import 'package:get/get.dart';

class InitialBinding implements Bindings {
  @override
  void dependencies() async {
    // Get.lazyPut<CategoryController>(() => CategoryController());
    Get.put<CategoryController>(CategoryController());
    // Get.lazyPut<TransactionController>(() => TransactionController());
    Get.put<TransactionController>(TransactionController());
  }
}
