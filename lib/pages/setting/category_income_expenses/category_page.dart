import 'package:cashier_management/controllers/category_controller.dart';
import 'package:cashier_management/pages/setting/category_income_expenses/category_form.dart';
import 'package:cashier_management/pages/setting/category_income_expenses/chips.dart';
import 'package:cashier_management/pages/setting/category_income_expenses/category_list.dart';
import 'package:cashier_management/pages/setting/category_income_expenses/search_bar_container.dart';
import 'package:cashier_management/utils/sizes.dart';
import 'package:flutter/material.dart';
import 'package:cashier_management/pages/navigation_drawer.dart'
    as custom_drawer;
import 'package:get/get.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  final CategoryController _categoryController = Get.put(CategoryController());

  @override
  void initState() {
    super.initState();
    _categoryController.getData();
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
              'Income/Expenditure Category',
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
              _categoryController.clearCategoryController();
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
          const Expanded(
            child: CategoryList(),
          ),
        ],
      ),
    );
  }
}
