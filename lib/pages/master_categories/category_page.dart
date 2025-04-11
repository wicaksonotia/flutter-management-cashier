import 'package:financial_apps/pages/master_categories/category_form.dart';
import 'package:financial_apps/pages/master_categories/chips.dart';
import 'package:financial_apps/pages/master_categories/category_list.dart';
import 'package:financial_apps/utils/colors.dart';
import 'package:financial_apps/utils/search_bar_container.dart';
import 'package:flutter/material.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        title: const Text(
          'Categories',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: SearchBarContainer(),
          ),
          const Chips(),
          Divider(
            height: 1,
            thickness: .5,
            color: Colors.grey.shade300,
          ),
          Expanded(
            child: ListCategories(),
          ),
        ],
      ),
    );
  }
}
