import 'package:cashier_management/controllers/history_controller.dart';
import 'package:cashier_management/controllers/kios_controller.dart';
import 'package:cashier_management/controllers/splash_controller.dart';
import 'package:cashier_management/controllers/total_per_type_controller.dart';

import 'package:cashier_management/pages/add_transaction/calculator.dart';
import 'package:cashier_management/pages/add_transaction/form_transaction.dart';

import 'package:cashier_management/pages/login_page.dart';

import 'package:cashier_management/pages/monitoring_outlet/monitoring_page.dart';

import 'package:cashier_management/pages/history/history_page.dart';

import 'package:cashier_management/pages/setting/branch/add_branch_page.dart';
import 'package:cashier_management/pages/setting/branch/branch_page.dart';

import 'package:cashier_management/pages/setting/category_income_expenses/category_page.dart';
import 'package:cashier_management/pages/setting/employee/employee_form.dart';

import 'package:cashier_management/pages/setting/employee/employee_page.dart';

import 'package:cashier_management/pages/setting/outlet/add_outlet_page.dart';
import 'package:cashier_management/pages/setting/outlet/outlet_page.dart';

import 'package:cashier_management/pages/setting/product_management/product_category_form_page.dart';
import 'package:cashier_management/pages/setting/product_management/product_form_page.dart';
import 'package:cashier_management/pages/setting/product_management/product_management_page.dart';

import 'package:cashier_management/pages/setting/user/change_password_page.dart';
import 'package:cashier_management/pages/setting/user/profile_page.dart';
import 'package:cashier_management/pages/setting/user/user_setting.dart';

import 'package:cashier_management/pages/splash_page.dart';

import 'package:get/get.dart';

import 'pages/home/home_page.dart';

class RouterClass {
  // ==========================================================
  // AUTH
  // ==========================================================

  static const String login = '/login';

  // ==========================================================
  // HOME
  // ==========================================================

  static const String home = '/home';

  // ==========================================================
  // TRANSACTION
  // ==========================================================

  static const String addtransaction = '/addtransaction';
  static const String transactionhistory = '/transactionhistory';
  static const String monitoringoutlet = '/monitoringoutlet';
  static const String calculator = '/calculator';

  // ==========================================================
  // SETTING - USER
  // ==========================================================

  static const String profile = '/profile';
  static const String userSetting = '/userSetting';
  static const String changePassword = '/change_password';

  // ==========================================================
  // SETTING - OUTLET
  // ==========================================================

  static const String outlet = '/outlet';
  static const String addoutlet = '/addoutlet';

  // ==========================================================
  // SETTING - BRANCH
  // ==========================================================

  static const String branch = '/branch';
  static const String addbranch = '/addbranch';

  // ==========================================================
  // SETTING - EMPLOYEE
  // ==========================================================

  static const String employee = '/employee';
  static const String addemployee = '/addemployee';

  // ==========================================================
  // SETTING - PRODUCT MANAGEMENT
  // ==========================================================

  static const String product = '/product';
  static const String addProductCategory = '/add-product-category';
  static const String addProduct = '/add-product';

  // ==========================================================
  // SETTING - INCOME / EXPENSE CATEGORY
  // ==========================================================

  static const String category = '/category';

  // ==========================================================
  // SPLASH
  // ==========================================================

  static const String splash = '/splash';

  // ==========================================================
  // ROUTES
  // ==========================================================

  static final List<GetPage> routes = [
    // ========================================================
    // SPLASH
    // ========================================================

    GetPage(
      name: splash,
      page: () => const SplashPage(),
      binding: BindingsBuilder(() {
        Get.put<SplashController>(
          SplashController(),
          permanent: true,
        );
      }),
    ),

    // ========================================================
    // LOGIN
    // ========================================================

    GetPage(
      name: login,
      page: () => const LoginPage(),
    ),

    // ========================================================
    // HOME
    // ========================================================

    GetPage(
      name: home,
      page: () => const HomePage(),
      binding: BindingsBuilder(() {
        Get.put<TotalPerTypeController>(
          TotalPerTypeController(),
        );

        Get.put<HistoryController>(
          HistoryController(),
        );

        Get.put<KiosController>(
          KiosController(),
        );
      }),
    ),

    // ========================================================
    // TRANSACTION
    // ========================================================

    GetPage(
      name: addtransaction,
      page: () => const FormTransaction(),
    ),

    GetPage(
      name: transactionhistory,
      page: () => const TransactionHistoryPage(),
    ),

    GetPage(
      name: monitoringoutlet,
      page: () => const MonitoringPage(),
    ),

    GetPage(
      name: calculator,
      page: () => const CalculatorPage(),
    ),

    // ========================================================
    // SETTING - USER
    // ========================================================

    GetPage(
      name: userSetting,
      page: () => const UserSetting(),
    ),

    GetPage(
      name: changePassword,
      page: () => const ChangePassword(),
    ),

    GetPage(
      name: profile,
      page: () => const ProfilePage(),
    ),

    // ========================================================
    // SETTING - OUTLET
    // ========================================================

    GetPage(
      name: outlet,
      page: () => const OutletPage(),
    ),

    GetPage(
      name: addoutlet,
      page: () => const AddOutletPage(),
    ),

    // ========================================================
    // SETTING - BRANCH
    // ========================================================

    GetPage(
      name: branch,
      page: () => const BranchPage(),
    ),

    GetPage(
      name: addbranch,
      page: () => const AddBranchPage(),
    ),

    // ========================================================
    // SETTING - EMPLOYEE
    // ========================================================

    GetPage(
      name: addemployee,
      page: () => EmployeeForm(),
    ),

    GetPage(
      name: employee,
      page: () => const EmployeePage(),
    ),

    // ========================================================
    // PRODUCT MANAGEMENT
    // ========================================================

    GetPage(
      name: product,
      page: () => const ProductManagementPage(),
    ),

    GetPage(
      name: addProductCategory,
      page: () => const AddProductCategoryPage(),
    ),

    GetPage(
      name: addProduct,
      page: () => AddProductPage(),
    ),

    // ========================================================
    // INCOME / EXPENSE CATEGORY
    // ========================================================

    GetPage(
      name: category,
      page: () => const CategoryPage(),
    ),
  ];
}
