import 'package:cashier_management/pages/add_transaction/form_expense.dart';
import 'package:cashier_management/pages/add_transaction/form_income.dart';
import 'package:cashier_management/utils/colors.dart';
import 'package:flutter/material.dart';

class AddTransactionPage extends StatefulWidget {
  const AddTransactionPage({super.key});

  @override
  State<AddTransactionPage> createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends State<AddTransactionPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {}); // Rebuild the widget when the tab index changes
    });
  }

  @override
  void dispose() {
    _tabController
        .removeListener(() {}); // Remove the listener before disposing
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text('Add Transaction'),
          backgroundColor: Colors.white,
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(AppBar().preferredSize.height),
            child: Container(
              height: 50,
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 5,
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    10,
                  ),
                  color: Colors.grey[200],
                ),
                child: TabBar(
                  controller: _tabController,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.black,
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      10,
                    ),
                    color: ColorTween(
                      begin: MyColors.red,
                      end: MyColors.primary,
                    )
                        .animate(
                          CurvedAnimation(
                            parent: _tabController.animation!,
                            curve: Curves.easeInOut,
                          ),
                        )
                        .value,
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  dividerColor: Colors.transparent,
                  tabs: const [
                    Tab(
                      text: 'Expense',
                    ),
                    Tab(
                      text: 'Income',
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          physics: const NeverScrollableScrollPhysics(),
          children: const [
            // Expense Tab
            FormExpense(),
            // Income Tab
            FormIncome(),
          ],
        ),
      ),
    );
  }
}
