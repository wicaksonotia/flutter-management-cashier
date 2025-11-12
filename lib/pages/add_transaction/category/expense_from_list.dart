import 'package:cashier_management/controllers/transaction_controller.dart';
import 'package:cashier_management/utils/colors.dart';
import 'package:cashier_management/utils/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class ExpenseFromListPage extends StatefulWidget {
  const ExpenseFromListPage({super.key});

  @override
  State<ExpenseFromListPage> createState() => _ExpenseFromListPageState();
}

class _ExpenseFromListPageState extends State<ExpenseFromListPage> {
  final TransactionController _transactionController =
      Get.find<TransactionController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Outlet Branch',
          style: TextStyle(
              fontSize: MySizes.fontSizeHeader, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.grey.shade50,
      body: Obx(() {
        return _transactionController.isLoading.value
            ? ListView.builder(
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
              )
            : ListView.separated(
                separatorBuilder: (context, index) {
                  return Divider(
                    thickness: .5,
                    color: Colors.grey.shade300,
                  );
                },
                itemCount: _transactionController.resultDataExpenseFrom.length,
                itemBuilder: (context, index) {
                  final category =
                      _transactionController.resultDataExpenseFrom[index];
                  return ListTile(
                    title: Text(
                      category.cabang!,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      category.alamat!,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: MySizes.fontSizeSm,
                      ),
                    ),
                    onTap: () {
                      _transactionController.idCabang.value = category.id!;
                      _transactionController.cabang.value = category.cabang!;
                      Get.back(result: category);
                    },
                    trailing: Icon(
                      Icons.check_circle,
                      color:
                          _transactionController.idCabang.value == category.id
                              ? MyColors.primary
                              : Colors.grey.shade300,
                    ),
                  );
                },
              );
      }),
    );
  }
}
