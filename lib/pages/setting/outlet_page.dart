import 'package:cashier_management/controllers/kios_controller.dart';
import 'package:cashier_management/database/api_endpoints.dart';
import 'package:cashier_management/models/kios_model.dart';
import 'package:cashier_management/routes.dart';
import 'package:cashier_management/utils/confirm_delete.dart';
import 'package:cashier_management/utils/currency.dart';
import 'package:cashier_management/utils/sizes.dart';
import 'package:flutter/material.dart';
import 'package:cashier_management/pages/navigation_drawer.dart'
    as custom_drawer;
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class OutletPage extends StatefulWidget {
  const OutletPage({super.key});

  @override
  State<OutletPage> createState() => _OutletPageState();
}

class _OutletPageState extends State<OutletPage> {
  final KiosController _kiosController = Get.put(KiosController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _kiosController.fetchDataListKiosFinancial();
    });
  }

  Future<void> _refresh() async {
    _kiosController.fetchDataListKiosFinancial();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const custom_drawer.NavigationDrawer(),
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        surfaceTintColor: Colors.transparent,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Outlet Settings',
              style: TextStyle(
                  fontSize: MySizes.fontSizeHeader,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_box_outlined),
            onPressed: () {
              _kiosController.clearController();
              Get.toNamed(RouterClass.addoutlet);
            },
          ),
        ],
      ),
      body: Obx(() {
        if (_kiosController.isLoadingFinancialKios.value) {
          return ListView.builder(
            itemCount: 8,
            itemBuilder: (context, index) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                child: Shimmer.fromColors(
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.white,
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white,
                    ),
                  ),
                ),
              );
            },
          );
        }
        return RefreshIndicator(
          onRefresh: _refresh,
          child: ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: _kiosController.listKiosFinancial.length,
            itemBuilder: (context, index) {
              return QuotationCard(
                  controller: _kiosController,
                  quotation: _kiosController.listKiosFinancial[index]);
            },
          ),
        );
      }),
    );
  }
}

class QuotationCard extends StatelessWidget {
  const QuotationCard(
      {super.key, required this.quotation, required this.controller});

  final KiosModel quotation;
  final KiosController controller;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Stack(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: quotation.logo != null
                          ? Image.network(
                              '${ApiEndPoints.ipPublic}images/logo/${quotation.logo}',
                              width: 80,
                              height: 80,
                              fit: BoxFit.contain,
                            )
                          : Image.asset('assets/stmj.png',
                              width: 80, height: 80, fit: BoxFit.contain),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            quotation.kios ?? '',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const Gap(4),
                          Text(
                            quotation.keterangan ?? '',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                          const Gap(8),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: quotation.isActive == true
                                      ? Colors.green[200]
                                      : Colors.red[200],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  quotation.isActive == true
                                      ? 'Active'
                                      : 'Inactive',
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ),
                              const Gap(8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.blue[200],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  'Cabang: ${quotation.totalCabang ?? 0}',
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Positioned(
                  top: -10,
                  right: -10,
                  child: PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == "edit") {
                        final KiosController kiosController =
                            Get.find<KiosController>();
                        kiosController.editKios(quotation);
                        Get.toNamed(RouterClass.addoutlet);
                      } else if (value == "delete") {
                        if (quotation.totalCabang != 0) {
                          Get.snackbar(
                            'Error',
                            'Cannot delete this outlet, it has branches.',
                            snackPosition: SnackPosition.TOP,
                            backgroundColor: Colors.red[100],
                            colorText: Colors.red[800],
                          );
                          return;
                        }
                        // Check if the quotation has any financial records
                        if (quotation.totalIncome != 0 ||
                            quotation.totalExpense != 0 ||
                            quotation.totalBalance != 0) {
                          Get.snackbar(
                            'Error',
                            'Cannot delete this outlet, it has financial records.',
                            snackPosition: SnackPosition.TOP,
                            backgroundColor: Colors.red[100],
                            colorText: Colors.red[800],
                          );
                          return;
                        }

                        // Show confirmation dialog
                        Get.bottomSheet(
                          ConfirmDelete(
                            title: 'Delete History',
                            message:
                                'Are you sure, you want to delete this history?',
                            onConfirm: () async {
                              controller.deleteKios(quotation.idKios!);
                            },
                          ),
                          isScrollControlled: true,
                          backgroundColor: Colors.white,
                          shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(20)),
                          ),
                        );
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: "edit",
                        child: Row(
                          children: [
                            Icon(Icons.edit_outlined),
                            SizedBox(width: 8),
                            Text("Edit"),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: "delete",
                        child: Row(
                          children: [
                            Icon(Icons.delete_outline),
                            SizedBox(width: 8),
                            Text("Delete"),
                          ],
                        ),
                      ),
                    ],
                    icon: const Icon(Icons.more_vert),
                  ),
                ),
              ],
            ),
            const Divider(height: 20, thickness: 1),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildFinancialInfo(
                  icon: Icons.arrow_downward,
                  label: "Income",
                  value: quotation.totalIncome ?? 0,
                  color: Colors.green,
                ),
                _buildFinancialInfo(
                  icon: Icons.arrow_upward,
                  label: "Expense",
                  value: quotation.totalExpense ?? 0,
                  color: Colors.red,
                ),
                _buildFinancialInfo(
                  icon: Icons.account_balance_wallet,
                  label: "Balance",
                  value: quotation.totalBalance ?? 0,
                  color: Colors.blue,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFinancialInfo({
    required IconData icon,
    required String label,
    required int value,
    required Color color,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color.withOpacity(0.1),
              ),
              padding: const EdgeInsets.all(2),
              child: Icon(
                icon,
                color: color,
                size: 14,
              ),
            ),
            const Gap(5),
            Text(
              label,
              style: TextStyle(
                fontSize: MySizes.fontSizeSm,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        Text(
          CurrencyFormat.convertToIdr(
            value,
            0,
          ),
          style: const TextStyle(
            fontSize: MySizes.fontSizeMd,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
// ...existing code...
