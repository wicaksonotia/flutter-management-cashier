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

class _CategoryListState extends State<CategoryList>
    with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();

  late final AnimationController _shimmerController;

  CategoryController get controller => widget.controller;

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(_onScroll);

    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
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
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // =============================================================
      // INITIAL LOADING
      // =============================================================

      if (controller.isLoadingCategory.value &&
          controller.resultDataCategory.isEmpty) {
        return _buildLoadingState();
      }

      // =============================================================
      // EMPTY
      // =============================================================

      if (controller.resultDataCategory.isEmpty) {
        return _buildEmptyState();
      }

      // =============================================================
      // LIST
      // =============================================================

      return ListView.separated(
        controller: _scrollController,
        padding: const EdgeInsets.fromLTRB(
          16,
          4,
          16,
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
  // LOADING
  // ===============================================================

  Widget _buildLoadingState() {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(
        16,
        8,
        16,
        110,
      ),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 7,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (_, __) {
        return _CategoryItemShimmer(
          animation: _shimmerController,
        );
      },
    );
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
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: MyColors.primaryLight,
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Icon(
                Icons.category_outlined,
                size: 29,
                color: MyColors.primaryDark,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Belum ada kategori',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: MyColors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Tambahkan kategori pemasukan atau '
              'pengeluaran untuk mulai mengelola transaksi.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12.5,
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

// ===================================================================
// SHIMMER ITEM
// ===================================================================

class _CategoryItemShimmer extends StatelessWidget {
  final Animation<double> animation;

  const _CategoryItemShimmer({
    required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: MyColors.surface,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.all(13),
        child: Row(
          children: [
            _ShimmerBox(
              animation: animation,
              width: 44,
              height: 44,
              borderRadius: 13,
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _ShimmerBox(
                    animation: animation,
                    width: 125,
                    height: 12,
                    borderRadius: 6,
                  ),
                  const SizedBox(height: 8),
                  _ShimmerBox(
                    animation: animation,
                    width: 82,
                    height: 18,
                    borderRadius: 6,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            _ShimmerBox(
              animation: animation,
              width: 34,
              height: 20,
              borderRadius: 12,
            ),
            const SizedBox(width: 8),
            _ShimmerBox(
              animation: animation,
              width: 22,
              height: 28,
              borderRadius: 6,
            ),
          ],
        ),
      ),
    );
  }
}

// ===================================================================
// SHIMMER BOX
// ===================================================================

class _ShimmerBox extends StatelessWidget {
  final Animation<double> animation;
  final double width;
  final double height;
  final double borderRadius;

  const _ShimmerBox({
    required this.animation,
    required this.width,
    required this.height,
    required this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final position = animation.value * 2 - 1;

        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment(position - 1, 0),
              end: Alignment(position + 1, 0),
              colors: [
                MyColors.surfaceSoft,
                MyColors.border.withValues(alpha: .65),
                MyColors.surfaceSoft,
              ],
            ).createShader(bounds);
          },
          child: Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              color: MyColors.surfaceSoft,
              borderRadius: BorderRadius.circular(
                borderRadius,
              ),
            ),
          ),
        );
      },
    );
  }
}
