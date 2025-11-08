import 'package:cashier_management/controllers/history_controller.dart';
import 'package:cashier_management/controllers/kios_controller.dart';
import 'package:cashier_management/controllers/total_per_type_controller.dart';
import 'package:cashier_management/controllers/transaction_controller.dart';
import 'package:cashier_management/pages/add_transaction/calculator.dart';
import 'package:cashier_management/pages/add_transaction/category/expense_from_list.dart';
import 'package:cashier_management/pages/add_transaction/category/expense_kios.dart';
import 'package:cashier_management/pages/add_transaction/form_transaction.dart';
import 'package:cashier_management/pages/add_transaction/category/expense_list.dart';
import 'package:cashier_management/pages/add_transaction/category/income_list.dart';
import 'package:cashier_management/pages/login_page.dart';
import 'package:cashier_management/pages/monitoring_outlet/monitoring_page.dart';
// import 'package:cashier_management/pages/navigation_bottom_page.dart';
import 'package:cashier_management/pages/history/history_page.dart';
import 'package:cashier_management/pages/setting/branch/add_branch_page.dart';
import 'package:cashier_management/pages/setting/branch/branch_page.dart';
import 'package:cashier_management/pages/setting/outlet/add_outlet_page.dart';
import 'package:cashier_management/pages/setting/outlet/outlet_page.dart';
import 'package:cashier_management/pages/setting/user/change_password_page.dart';
import 'package:cashier_management/pages/setting/user/profile_page.dart';
import 'package:cashier_management/pages/setting/user/user_setting.dart';
import 'package:get/get.dart';

import 'pages/home/home_page.dart';

class RouterClass {
  static String login = "/login";
  // static String navigation = '/navigation';
  static String home = '/home';
  static String addtransaction = '/addtransaction';
  static String transactionhistory = '/transactionhistory';
  static String monitoringoutlet = '/monitoringoutlet';
  static String expense = '/expense';
  static String expensefrom = '/expensefrom';
  static String expenseKios = '/expensekios';
  static String income = '/income';
  static String calculator = '/calculator';
  // SETTING
  static String outlet = '/outlet';
  static String addoutlet = '/addoutlet';
  static String branch = '/branch';
  static String addbranch = '/addbranch';
  static String userSetting = '/userSetting';
  static String changePassword = "/change_password";
  static String profile = "/profile";

  static List<GetPage> routes = [
    GetPage(page: () => const LoginPage(), name: login),
    // GetPage(
    //   page: () => NavigationBottomPage(),
    //   name: navigation,
    //   binding: BindingsBuilder(() {
    //     Get.put<TotalPerTypeController>(TotalPerTypeController());
    //     Get.put<HistoryController>(HistoryController());
    //   }),
    // ),
    GetPage(
      page: () => const HomePage(),
      name: home,
      binding: BindingsBuilder(() {
        Get.put<TotalPerTypeController>(TotalPerTypeController());
        Get.put<HistoryController>(HistoryController());
        Get.put<KiosController>(KiosController());
      }),
    ),
    GetPage(
      page: () => const AddTransactionPage(),
      name: addtransaction,
      binding: BindingsBuilder(() {
        Get.put<TransactionController>(TransactionController());
      }),
    ),
    GetPage(
      page: () => const TransactionHistoryPage(),
      name: transactionhistory,
    ),
    GetPage(
      page: () => const MonitoringPage(),
      name: monitoringoutlet,
    ),
    GetPage(
        page: () => const ExpenseListPage(),
        name: expense,
        transition: Transition.rightToLeft,
        transitionDuration: const Duration(milliseconds: 500)),
    GetPage(
        page: () => const ExpenseFromListPage(),
        name: expensefrom,
        transition: Transition.rightToLeft,
        transitionDuration: const Duration(milliseconds: 500)),
    GetPage(
        page: () => const ExpenseKios(),
        name: expenseKios,
        transition: Transition.rightToLeft,
        transitionDuration: const Duration(milliseconds: 500)),
    GetPage(
        page: () => const IncomeListPage(),
        name: income,
        transition: Transition.rightToLeft,
        transitionDuration: const Duration(milliseconds: 500)),
    GetPage(page: () => const CalculatorPage(), name: calculator),
    // =============================================================
    // SETTING
    // =============================================================
    // OUTLET
    GetPage(
      page: () => const OutletPage(),
      name: outlet,
      binding: BindingsBuilder(() {
        Get.put<KiosController>(KiosController());
      }),
    ),
    GetPage(
      page: () => const AddOutletPage(),
      name: addoutlet,
    ),
    // BRANCH
    GetPage(
      page: () => const BranchPage(),
      name: branch,
    ),
    GetPage(
      page: () => const AddBranchPage(),
      name: addbranch,
    ),
    // PROFILE
    GetPage(page: () => const UserSetting(), name: userSetting),
    GetPage(page: () => const ChangePassword(), name: changePassword),
    GetPage(page: () => const ProfilePage(), name: profile),
  ];
}
