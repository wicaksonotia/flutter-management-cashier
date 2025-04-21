import 'package:financial_apps/controllers/transaction_controller.dart';
import 'package:financial_apps/pages/add_transaction/calculator.dart';
import 'package:financial_apps/pages/add_transaction/category/expense_from_list.dart';
import 'package:financial_apps/pages/add_transaction/form_transaction.dart';
import 'package:financial_apps/pages/add_transaction/category/expense_list.dart';
import 'package:financial_apps/pages/add_transaction/category/income_list.dart';
import 'package:financial_apps/pages/navigation_page.dart';
import 'package:financial_apps/pages/history/history_page.dart';
import 'package:get/get.dart';

import '../pages/home/home_page.dart';

class RouterClass {
  static String navigation = '/navigation';
  static String home = '/home';
  static String addtransaction = '/addtransaction';
  static String transactionhistory = '/transactionhistory';
  static String expense = '/expense';
  static String expensefrom = '/expensefrom';
  static String income = '/income';
  static String calculator = '/calculator';

  // static String navigations() => navigation;
  // static String goToHome() => home;
  // static String goToAddTransaction() => addtransaction;
  // static String goToTransaction() => transaction;
  // static String goToPastTransaction() => pastTransaction;

  static List<GetPage> routes = [
    GetPage(
      page: () => NavigationPage(),
      name: navigation,
    ),
    GetPage(
      page: () => const HomePage(),
      name: home,
    ),
    GetPage(
      page: () => const AddTransactionPage(),
      name: addtransaction,
      binding: BindingsBuilder(() {
        Get.lazyPut(() => TransactionController());
      }),
    ),
    GetPage(
        page: () => const TransactionHistoryPage(), name: transactionhistory),
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
        page: () => const IncomeListPage(),
        name: income,
        transition: Transition.rightToLeft,
        transitionDuration: const Duration(milliseconds: 500)),
    GetPage(page: () => const CalculatorPage(), name: calculator),
  ];
}
