import 'package:financial_apps/pages/add_transaction/form_transaction.dart';
import 'package:financial_apps/pages/navigation_page.dart';
import 'package:financial_apps/pages/transaction/transaction_page.dart';
import 'package:get/get.dart';

import '../pages/home/home_page.dart';

class RouterClass {
  static String navigation = '/navigation';
  static String home = '/home';
  static String addtransaction = '/addtransaction';
  static String transaction = '/transaction';

  // static String navigations() => navigation;
  // static String goToHome() => home;
  // static String goToAddTransaction() => addtransaction;
  // static String goToTransaction() => transaction;
  // static String goToPastTransaction() => pastTransaction;

  static List<GetPage> routes = [
    GetPage(page: () => NavigationPage(), name: navigation),
    GetPage(page: () => const HomePage(), name: home),
    GetPage(page: () => const AddTransactionPage(), name: addtransaction),
    GetPage(page: () => const TransactionPage(), name: transaction),
  ];
}
