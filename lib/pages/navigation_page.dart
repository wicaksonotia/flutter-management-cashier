import 'package:financial_apps/pages/AccountPage.dart';
import 'package:financial_apps/pages/home/home_page.dart';
import 'package:financial_apps/pages/master_categories/categories.dart';
import 'package:financial_apps/pages/transaction/history_page.dart';
import 'package:financial_apps/utils/colors.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class NavigationPage extends StatefulWidget {
  NavigationPage({super.key});

  int currentIndex = 0;
  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  final screens = [
    const HomePage(),
    const TransactionHistoryPage(),
    const FormCategories(),
    const AccountPage(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: IndexedStack(
          index: widget.currentIndex,
          children: screens,
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          unselectedItemColor: Colors.grey[400],
          selectedItemColor: MyColors.green,
          currentIndex: widget.currentIndex,
          onTap: (index) => setState(() {
            widget.currentIndex = index;
          }),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(
                icon: Icon(Icons.money), label: "Transactions"),
            BottomNavigationBarItem(
                icon: Icon(Icons.credit_card), label: "Master"),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: "Account"),
          ],
        ));
  }
}
