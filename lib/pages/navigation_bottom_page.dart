import 'package:cashier_management/pages/home/home_page.dart';
import 'package:cashier_management/pages/master_categories/category_page.dart';
import 'package:cashier_management/pages/history/history_page.dart';
import 'package:cashier_management/pages/monitoring_outlet/monitoring_page.dart';
import 'package:cashier_management/utils/colors.dart';
// import 'package:cashier_management/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

// ignore: must_be_immutable
class NavigationBottomPage extends StatefulWidget {
  NavigationBottomPage({super.key});

  int currentIndex = 0;
  @override
  State<NavigationBottomPage> createState() => _NavigationBottomPageState();
}

class _NavigationBottomPageState extends State<NavigationBottomPage> {
  final screens = [
    const HomePage(),
    const TransactionHistoryPage(),
    const MonitoringPage(),
    const CategoryPage(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: widget.currentIndex,
        children: screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withOpacity(.1),
            )
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
            child: GNav(
              // rippleColor: Colors.grey[300]!,
              // hoverColor: Colors.grey[100]!,
              gap: 8,
              activeColor: Colors.white,
              iconSize: 24,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              duration: const Duration(milliseconds: 400),
              tabBackgroundColor: MyColors.primary,
              color: MyColors.primary,
              tabs: const [
                GButton(
                  icon: Icons.home,
                  text: 'Home',
                ),
                GButton(
                  icon: Icons.money,
                  text: 'History',
                ),
                GButton(
                  icon: Icons.outlet,
                  text: 'Outlet',
                ),
                GButton(
                  icon: Icons.settings,
                  text: 'Category',
                ),
              ],
              selectedIndex: widget.currentIndex,
              onTabChange: (index) {
                setState(() {
                  widget.currentIndex = index;
                });
              },
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add-transaction');
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: MyColors.primary,
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
