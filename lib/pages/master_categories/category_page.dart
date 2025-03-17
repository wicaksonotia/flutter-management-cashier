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
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Categories',
          style: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: MyColors.green,
        actions: [
          IconButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) => const CategoryForm(),
                isScrollControlled: true,
                backgroundColor: Colors.white,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
              );
            },
            icon: const Icon(
              Icons.add_box,
              color: Colors.white,
              size: 30,
            ),
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
          Expanded(
            child: ListCategories(),
          ),
        ],
      ),
    );
  }
}
