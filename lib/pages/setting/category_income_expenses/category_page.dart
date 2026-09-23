import 'package:cashier_management/controllers/category_controller.dart';
import 'package:cashier_management/pages/navigation_drawer.dart'
    as custom_drawer;
import 'package:cashier_management/pages/setting/category_income_expenses/category_filter.dart';
import 'package:cashier_management/pages/setting/category_income_expenses/category_form.dart';
import 'package:cashier_management/pages/setting/category_income_expenses/category_list.dart';
import 'package:cashier_management/utils/colors.dart';
import 'package:cashier_management/utils/management_header.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({
    super.key,
  });

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

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
      key: scaffoldKey,
      drawer: const custom_drawer.NavigationDrawer(),
      backgroundColor: MyColors.background,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: RefreshIndicator(
          color: MyColors.primary,
          backgroundColor: MyColors.surface,
          onRefresh: categoryController.refreshData,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              // =====================================================
              // HEADER
              // =====================================================

              SliverToBoxAdapter(
                child: ManagementHeader(
                  title: 'Kategori',
                  subtitle: 'Kelola pemasukan dan pengeluaran',
                  addLabel: 'Kategori',
                  onMenuTap: () {
                    scaffoldKey.currentState?.openDrawer();
                  },
                  onAddTap: _onAddCategory,
                ),
              ),

              const SliverToBoxAdapter(
                child: SizedBox(height: 10),
              ),
              // =====================================================
              // FILTER
              // =====================================================

              SliverToBoxAdapter(
                child: CategoryFilter(
                  controller: categoryController,
                ),
              ),

              // =====================================================
              // LIST
              // =====================================================

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
    );
  }

  // ===============================================================
  // ADD CATEGORY
  // ===============================================================

  void _onAddCategory() {
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
