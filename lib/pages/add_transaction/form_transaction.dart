import 'package:cashier_management/controllers/kios_controller.dart';
import 'package:cashier_management/pages/add_transaction/form_expense.dart';
import 'package:cashier_management/pages/add_transaction/form_income.dart';
import 'package:cashier_management/pages/change_outlet_page.dart';
import 'package:cashier_management/routes.dart';
import 'package:cashier_management/utils/colors.dart';
import 'package:cashier_management/utils/sizes.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class AddTransactionPage extends StatefulWidget {
  const AddTransactionPage({super.key});

  @override
  State<AddTransactionPage> createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends State<AddTransactionPage>
    with SingleTickerProviderStateMixin {
  final KiosController _kiosController = Get.find<KiosController>();
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
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Get.toNamed(RouterClass.transactionhistory);
            },
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Transaksi Belanja',
                style: TextStyle(
                    fontSize: MySizes.fontSizeHeader,
                    fontWeight: FontWeight.bold),
              ),
              Obx(() {
                return GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      constraints: const BoxConstraints(
                        minWidth: double.infinity,
                      ),
                      builder: (context) => const ChangeOutletPage(),
                      isScrollControlled: true,
                      backgroundColor: Colors.white,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      Text(
                        _kiosController.namaKios.value,
                        style: const TextStyle(
                          fontSize: MySizes.fontSizeSm,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                      const Gap(5),
                      const Icon(Icons.keyboard_arrow_down_rounded,
                          color: Colors.black54, size: 15),
                    ],
                  ),
                );
              }),
            ],
          ),
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
                      text: 'Pengeluaran',
                    ),
                    Tab(
                      text: 'Pemasukan',
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
