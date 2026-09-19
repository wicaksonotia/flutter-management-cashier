import 'package:cashier_management/controllers/category_controller.dart';
import 'package:cashier_management/pages/navigation_drawer.dart'
    as custom_drawer;
import 'package:cashier_management/pages/setting/category_income_expenses/category_filter.dart';
import 'package:cashier_management/pages/setting/category_income_expenses/category_form.dart';
import 'package:cashier_management/pages/setting/category_income_expenses/category_header.dart';
import 'package:cashier_management/pages/setting/category_income_expenses/category_list.dart';
import 'package:cashier_management/pages/setting/category_income_expenses/category_summary.dart';
import 'package:cashier_management/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  late final CategoryController categoryController;

  @override
  void initState() {
    super.initState();

    categoryController = Get.isRegistered<CategoryController>()
        ? Get.find<CategoryController>()
        : Get.put(CategoryController());

    categoryController.getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const custom_drawer.NavigationDrawer(),
      backgroundColor: MyColors.background,
      resizeToAvoidBottomInset: false,

      // =========================================================
      // APP BAR
      // =========================================================

      appBar: _buildAppBar(),

      // =========================================================
      // BODY
      // =========================================================

      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: RefreshIndicator(
                color: MyColors.primary,
                backgroundColor: MyColors.surface,
                onRefresh: categoryController.refreshData,
                child: CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    // ===================================================
                    // HEADER
                    // ===================================================

                    const SliverToBoxAdapter(
                      child: CategoryHeader(),
                    ),

                    // ===================================================
                    // SUMMARY
                    // ===================================================

                    SliverToBoxAdapter(
                      child: CategorySummary(
                        controller: categoryController,
                      ),
                    ),

                    // ===================================================
                    // FILTER
                    // ===================================================

                    SliverToBoxAdapter(
                      child: CategoryFilter(
                        controller: categoryController,
                      ),
                    ),

                    // ===================================================
                    // LIST
                    // ===================================================

                    SliverFillRemaining(
                      hasScrollBody: true,
                      child: CategoryList(
                        controller: categoryController,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      // ===========================================================
      // FLOATING ACTION BUTTON
      // ===========================================================

      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  // ===============================================================
  // APP BAR
  // ===============================================================

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: MyColors.background,
      surfaceTintColor: Colors.transparent,
      leading: Builder(
        builder: (context) {
          return IconButton(
            tooltip: 'Menu',
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            icon: const Icon(
              Icons.menu_rounded,
              color: MyColors.textPrimary,
            ),
          );
        },
      ),
      titleSpacing: 0,
      title: const Text(
        'Kategori',
        style: TextStyle(
          fontSize: 21,
          fontWeight: FontWeight.w700,
          color: MyColors.textPrimary,
          letterSpacing: -.3,
        ),
      ),
    );
  }

  // ===============================================================
  // FLOATING ACTION BUTTON
  // ===============================================================

  Widget _buildFloatingActionButton() {
    return FloatingActionButton.extended(
      elevation: 2,
      backgroundColor: MyColors.primary,
      foregroundColor: MyColors.textOnPrimary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      onPressed: () {
        categoryController.clearCategoryController();

        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          useSafeArea: true,
          builder: (_) {
            return const _CategoryFormSheet();
          },
        );
      },
      icon: const Icon(
        Icons.add_rounded,
        size: 21,
      ),
      label: const Text(
        'Kategori',
        style: TextStyle(
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

// ===================================================================
// CATEGORY FORM SHEET
// ===================================================================

class _CategoryFormSheet extends StatelessWidget {
  const _CategoryFormSheet();

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        maxHeight: 700,
      ),
      decoration: const BoxDecoration(
        color: MyColors.surface,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(28),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // =========================================================
          // HANDLE
          // =========================================================

          const SizedBox(height: 10),

          Container(
            width: 42,
            height: 4,
            decoration: BoxDecoration(
              color: MyColors.border,
              borderRadius: BorderRadius.circular(10),
            ),
          ),

          const SizedBox(height: 8),

          // =========================================================
          // FORM
          // =========================================================

          Flexible(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: const Padding(
                padding: EdgeInsets.fromLTRB(
                  20,
                  8,
                  20,
                  24,
                ),
                child: CategoryForm(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
