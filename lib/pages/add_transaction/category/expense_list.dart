import 'package:financial_apps/controllers/transaction_controller.dart';
import 'package:financial_apps/pages/master_categories/category_form.dart';
import 'package:financial_apps/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class ExpenseListPage extends StatefulWidget {
  const ExpenseListPage({super.key});

  @override
  State<ExpenseListPage> createState() => _ExpenseListPageState();
}

class _ExpenseListPageState extends State<ExpenseListPage> {
  final TransactionController _transactionController =
      Get.find<TransactionController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Category'),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_box, color: MyColors.green),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    backgroundColor: Colors.white,
                    contentPadding: const EdgeInsets.all(10),
                    content: const CategoryForm(),
                  );
                },
              );
            },
          ),
        ],
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
                            color: Colors.white),
                      ),
                    ),
                  );
                },
              )
            : ListView.separated(
                separatorBuilder: (context, index) {
                  return Divider(
                    thickness: .5,
                    // indent: 20,
                    // endIndent: 20,
                    color: Colors.grey.shade300,
                  );
                },
                itemCount: _transactionController.resultDataExpense.length,
                itemBuilder: (context, index) {
                  final category =
                      _transactionController.resultDataExpense[index];
                  return ListTile(
                    title: Text(category.categoryName!),
                    onTap: () {
                      _transactionController.dataCategoryExpenseId.value =
                          category.id!;
                      _transactionController.dataCategoryExpenseName.value =
                          category.categoryName!;
                      Get.back(result: category);
                    },
                    trailing: Icon(
                      Icons.check_circle,
                      color:
                          _transactionController.dataCategoryExpenseId.value ==
                                  category.id
                              ? MyColors.green
                              : Colors.grey.shade300,
                    ),
                  );
                },
              );
      }),
    );
  }
}
