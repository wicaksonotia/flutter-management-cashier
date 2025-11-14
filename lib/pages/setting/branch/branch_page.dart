import 'package:cashier_management/controllers/cabang_controller.dart';
import 'package:cashier_management/models/outlet_branch_model.dart';
import 'package:cashier_management/routes.dart';
import 'package:cashier_management/utils/colors.dart';
import 'package:cashier_management/utils/confirm_dialog.dart';
import 'package:cashier_management/utils/currency.dart';
import 'package:cashier_management/utils/sizes.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class BranchPage extends StatefulWidget {
  const BranchPage({super.key});

  @override
  State<BranchPage> createState() => _BranchPageState();
}

class _BranchPageState extends State<BranchPage> {
  final CabangController _cabangController = Get.put(CabangController());

  Future<void> _refresh() async {
    _cabangController.fetchDataListCabangFinancial();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Get.toNamed(RouterClass.outlet);
          },
        ),
        surfaceTintColor: Colors.transparent,
        title: RichText(
          text: TextSpan(
            text: '${_cabangController.headerNamaKios}',
            style: const TextStyle(
              fontSize: MySizes.fontSizeHeader,
              fontWeight: FontWeight.bold,
              color: MyColors.primary,
            ),
            children: const [
              TextSpan(
                text: ' Outlet Setting',
                style: TextStyle(
                  fontSize: MySizes.fontSizeHeader,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_box_outlined),
            onPressed: () {
              _cabangController.branchId.value = 0;
              Get.toNamed(RouterClass.addbranch);
            },
          ),
        ],
      ),
      body: Obx(() {
        if (_cabangController.isLoadingList.value) {
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
            itemCount: _cabangController.resultItem.length,
            itemBuilder: (context, index) {
              return QuotationCard(
                  controller: _cabangController,
                  quotation: _cabangController.resultItem[index]);
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

  final DataListOutletBranch quotation;
  final CabangController controller;

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
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                quotation.cabang ?? '',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const Gap(8),
                              InkWell(
                                onTap: () {
                                  // DIALOG CONFIRMATION ACTIVE OR INACTIVE
                                  Get.bottomSheet(
                                    ConfirmDialog(
                                        title: quotation.status == true
                                            ? 'Non-Activate Outlet'
                                            : 'Activate Outlet',
                                        message: quotation.status == true
                                            ? 'This outlet will be deactivated.\nAre you sure you want to continue?'
                                            : 'This outlet will be activated.\nAre you sure you want to continue?',
                                        onConfirm: () async {
                                          controller.updateStatusBranch(
                                              quotation.id!,
                                              !quotation.status!);
                                        }),
                                    isScrollControlled: true,
                                    backgroundColor: Colors.white,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(20)),
                                    ),
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: quotation.status == true
                                        ? Colors.green[200]
                                        : Colors.red[200],
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    quotation.status == true
                                        ? 'Active'
                                        : 'Inactive',
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const Gap(4),
                          Text(
                            quotation.alamat ?? '',
                            style: TextStyle(color: Colors.grey[600]),
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
                        controller.editBranch(quotation);
                        Get.toNamed(RouterClass.addbranch);
                        return;
                      }
                      if (value == "delete") {
                        // Check if the quotation has any financial records
                        if (quotation.details!.income != 0 ||
                            quotation.details!.expense != 0 ||
                            quotation.details!.balance != 0) {
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
                          ConfirmDialog(
                            title: 'Delete History',
                            message:
                                'Are you sure, you want to delete this history?',
                            onConfirm: () async {
                              controller.deleteBranch(quotation.id!);
                            },
                          ),
                          isScrollControlled: true,
                          backgroundColor: Colors.white,
                          shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(20)),
                          ),
                        );
                        return;
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: "edit",
                        child: Row(
                          children: [
                            Icon(Icons.edit_outlined),
                            Gap(8),
                            Text("Edit"),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: "delete",
                        child: Row(
                          children: [
                            Icon(Icons.delete_outline),
                            Gap(8),
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
                  value: quotation.details!.income ?? 0,
                  color: Colors.green,
                ),
                _buildFinancialInfo(
                  icon: Icons.arrow_upward,
                  label: "Expense",
                  value: quotation.details!.expense ?? 0,
                  color: Colors.red,
                ),
                _buildFinancialInfo(
                  icon: Icons.account_balance_wallet,
                  label: "Balance",
                  value: quotation.details!.balance ?? 0,
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
