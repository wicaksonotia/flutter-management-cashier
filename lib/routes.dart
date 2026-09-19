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
import 'package:cashier_management/pages/setting/employee/add_employee_page.dart';
import 'package:cashier_management/pages/setting/employee/list_employee_page.dart';
import 'package:cashier_management/pages/setting/outlet/add_outlet_page.dart';
import 'package:cashier_management/pages/setting/outlet/outlet_page.dart';
import 'package:cashier_management/pages/setting/product_management/product_category_form_page.dart';
import 'package:cashier_management/pages/setting/product_management/product_form_page.dart';
import 'package:cashier_management/pages/setting/product_management/product_management_page.dart';
import 'package:cashier_management/pages/setting/setting_page.dart';
import 'package:cashier_management/pages/setting/user/change_password_page.dart';
import 'package:cashier_management/pages/setting/user/profile_page.dart';
import 'package:cashier_management/pages/setting/user/user_setting.dart';
import 'package:cashier_management/pages/splash_page.dart';
import 'package:get/get.dart';

import 'pages/home/home_page.dart';

class RouterClass {
  static String login = "/login";
  // static String navigation = '/navigation';
  static String home = '/home';
  static String addtransaction = '/addtransaction';
  static String transactionhistory = '/transactionhistory';
  static String monitoringoutlet = '/monitoringoutlet';
  static String calculator = '/calculator';
  // SETTING PROFILE
  static String profile = "/profile";
  static String userSetting = '/userSetting';
  static String changePassword = "/change_password";
  // SETTING OUTLET
  static String outlet = '/outlet';
  static String addoutlet = '/addoutlet';
  // SETTING OUTLET BRANCH
  static String branch = '/branch';
  static String addbranch = '/addbranch';
  // SETTING EMPLOYEE
  static String listemployee = "/listemployee";
  static String addemployee = "/addemployee";
  // PRODUCT MANAGEMENT
  static String product = "/product";
  static String addProductCategory = "/add-product-category";
  static String addProduct = "/add-product";
  // SETTING INCOME/EXPENSES CATEGORY
  static String category = "/category";
  static String splash = '/splash';
  static const String settings = '/settings';

  static List<GetPage> routes = [
    GetPage(
      page: () => const SplashPage(),
      name: splash,
      binding: BindingsBuilder(() {
        Get.put<SplashController>(SplashController(), permanent: true);
      }),
    ),
    GetPage(page: () => const LoginPage(), name: login),
    GetPage(
      page: () => const HomePage(),
      name: home,
      binding: BindingsBuilder(() {
        Get.put<TotalPerTypeController>(TotalPerTypeController());
        Get.put<HistoryController>(HistoryController());
        Get.put<KiosController>(KiosController());
      }),
    ),
    GetPage(page: () => const FormTransaction(), name: addtransaction),
    GetPage(
        page: () => const TransactionHistoryPage(), name: transactionhistory),
    GetPage(page: () => const MonitoringPage(), name: monitoringoutlet),
    GetPage(page: () => const CalculatorPage(), name: calculator),
    // =============================================================
    // SETTING
    // =============================================================
    // PROFILE
    GetPage(page: () => const UserSetting(), name: userSetting),
    GetPage(page: () => const ChangePassword(), name: changePassword),
    GetPage(page: () => const ProfilePage(), name: profile),
    // OUTLET
    GetPage(page: () => const OutletPage(), name: outlet),
    GetPage(page: () => const AddOutletPage(), name: addoutlet),
    // OUTLET BRANCH
    GetPage(page: () => const BranchPage(), name: branch),
    GetPage(page: () => const AddBranchPage(), name: addbranch),
    // EMPLOYEE
    GetPage(page: () => const AddEmployeePage(), name: addemployee),
    GetPage(page: () => const ListEmployeePage(), name: listemployee),
    // PRODUCT MANAGEMENT
    GetPage(page: () => const ProductManagementPage(), name: product),
    GetPage(page: () => const AddProductCategoryPage(), name: product),
    GetPage(page: () => const AddProductPage(), name: product),
    // INCOME/EXPENSES CATEGORY
    GetPage(page: () => const CategoryPage(), name: category),
    GetPage(
      name: RouterClass.settings,
      page: () => const SettingsPage(),
    ),
  ];
}
