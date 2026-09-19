import 'package:cashier_management/controllers/category_controller.dart';
import 'package:cashier_management/pages/setting/category_income_expenses/category_item.dart';
import 'package:cashier_management/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoryList extends StatefulWidget {
  final CategoryController controller;

  const CategoryList({
    super.key,
    required this.controller,
  });

  @override
  State<CategoryList> createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  final ScrollController _scrollController = ScrollController();

  CategoryController get controller => widget.controller;

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    final position = _scrollController.position;

    if (position.pixels >= position.maxScrollExtent - 250) {
      controller.loadMore();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoadingCategory.value &&
          controller.resultDataCategory.isEmpty) {
        return const Center(
          child: CircularProgressIndicator(
            strokeWidth: 2.5,
            color: MyColors.primary,
          ),
        );
      }

      if (controller.resultDataCategory.isEmpty) {
        return _buildEmptyState();
      }

      return ListView.separated(
        controller: _scrollController,
        padding: const EdgeInsets.fromLTRB(
          20,
          0,
          20,
          110,
        ),
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: controller.resultDataCategory.length +
            (controller.isLoadingMore.value ? 1 : 0),
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          if (index >= controller.resultDataCategory.length) {
            return const Padding(
              padding: EdgeInsets.symmetric(
                vertical: 18,
              ),
              child: Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: MyColors.primary,
                  ),
                ),
              ),
            );
          }

          final item = controller.resultDataCategory[index];

          return CategoryItem(
            model: item,
            controller: controller,
          );
        },
      );
    });
  }

  // ===============================================================
  // EMPTY STATE
  // ===============================================================

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 40,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: MyColors.primaryLight,
                borderRadius: BorderRadius.circular(22),
              ),
              child: const Icon(
                Icons.category_outlined,
                size: 32,
                color: MyColors.primaryDark,
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'Belum ada kategori',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: MyColors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Tambahkan kategori untuk mulai '
              'mengelompokkan transaksi.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                height: 1.45,
                color: MyColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
