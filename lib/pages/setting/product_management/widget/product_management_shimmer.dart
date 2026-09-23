import 'package:cashier_management/utils/colors.dart';
import 'package:cashier_management/utils/management_shimmer_box.dart';
import 'package:flutter/material.dart';

class ProductManagementShimmer extends StatefulWidget {
  final bool isGrid;

  const ProductManagementShimmer({
    super.key,
    required this.isGrid,
  });

  @override
  State<ProductManagementShimmer> createState() =>
      _ProductManagementShimmerState();
}

class _ProductManagementShimmerState extends State<ProductManagementShimmer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.isGrid ? _buildGrid() : _buildList();
  }

  // ============================================================
  // GRID
  // ============================================================

  Widget _buildGrid() {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(
        16,
        0,
        16,
        28,
      ),
      sliver: SliverGrid(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            return _ShimmerGridCard(
              animation: _controller,
            );
          },
          childCount: 6,
        ),
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 330,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          mainAxisExtent: 250,
        ),
      ),
    );
  }

  // ============================================================
  // LIST
  // ============================================================

  Widget _buildList() {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(
        16,
        0,
        16,
        28,
      ),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            return Padding(
              padding: const EdgeInsets.only(
                bottom: 8,
              ),
              child: _ShimmerListCard(
                animation: _controller,
              ),
            );
          },
          childCount: 5,
        ),
      ),
    );
  }
}

// ================================================================
// GRID CARD
// ================================================================

class _ShimmerGridCard extends StatelessWidget {
  final Animation<double> animation;

  const _ShimmerGridCard({
    required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    return _ShimmerContainer(
      animation: animation,
      borderRadius: 18,
      child: Container(
        decoration: BoxDecoration(
          color: MyColors.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: MyColors.border,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ManagementShimmerBox(
              animation: animation,
              width: double.infinity,
              height: 104,
              borderRadius: 0,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  12,
                  10,
                  12,
                  12,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ManagementShimmerBox(
                      animation: animation,
                      width: double.infinity,
                      height: 12,
                      borderRadius: 5,
                    ),
                    const SizedBox(height: 7),
                    ManagementShimmerBox(
                      animation: animation,
                      width: 85,
                      height: 10,
                      borderRadius: 5,
                    ),
                    const SizedBox(height: 12),
                    ManagementShimmerBox(
                      animation: animation,
                      width: 80,
                      height: 14,
                      borderRadius: 5,
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Expanded(
                          child: ManagementShimmerBox(
                            animation: animation,
                            width: double.infinity,
                            height: 32,
                            borderRadius: 8,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          child: ManagementShimmerBox(
                            animation: animation,
                            width: double.infinity,
                            height: 32,
                            borderRadius: 8,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          child: ManagementShimmerBox(
                            animation: animation,
                            width: double.infinity,
                            height: 32,
                            borderRadius: 8,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ================================================================
// LIST CARD
// ================================================================

class _ShimmerListCard extends StatelessWidget {
  final Animation<double> animation;

  const _ShimmerListCard({
    required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    return _ShimmerContainer(
      animation: animation,
      borderRadius: 15,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: MyColors.surface,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: MyColors.border,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ManagementShimmerBox(
              animation: animation,
              width: 76,
              height: 76,
              borderRadius: 12,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: ManagementShimmerBox(
                          animation: animation,
                          width: double.infinity,
                          height: 12,
                          borderRadius: 5,
                        ),
                      ),
                      const SizedBox(width: 10),
                      ManagementShimmerBox(
                        animation: animation,
                        width: 18,
                        height: 18,
                        borderRadius: 20,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ManagementShimmerBox(
                    animation: animation,
                    width: double.infinity,
                    height: 9,
                    borderRadius: 5,
                  ),
                  const SizedBox(height: 5),
                  ManagementShimmerBox(
                    animation: animation,
                    width: 120,
                    height: 9,
                    borderRadius: 5,
                  ),
                  const SizedBox(height: 9),
                  Row(
                    children: [
                      ManagementShimmerBox(
                        animation: animation,
                        width: 75,
                        height: 12,
                        borderRadius: 5,
                      ),
                      const SizedBox(width: 8),
                      ManagementShimmerBox(
                        animation: animation,
                        width: 55,
                        height: 18,
                        borderRadius: 9,
                      ),
                    ],
                  ),
                  const SizedBox(height: 9),
                  Row(
                    children: [
                      ManagementShimmerBox(
                        animation: animation,
                        width: 55,
                        height: 30,
                        borderRadius: 8,
                      ),
                      const SizedBox(width: 5),
                      ManagementShimmerBox(
                        animation: animation,
                        width: 78,
                        height: 30,
                        borderRadius: 8,
                      ),
                      const SizedBox(width: 5),
                      ManagementShimmerBox(
                        animation: animation,
                        width: 55,
                        height: 30,
                        borderRadius: 8,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ================================================================
// SHIMMER CONTAINER
// ================================================================

class _ShimmerContainer extends StatelessWidget {
  final Animation<double> animation;
  final double borderRadius;
  final Widget child;

  const _ShimmerContainer({
    required this.animation,
    required this.borderRadius,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return child;
  }
}
