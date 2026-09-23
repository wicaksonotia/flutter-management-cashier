import 'package:cashier_management/utils/colors.dart';
import 'package:cashier_management/utils/management_shimmer_box.dart';
import 'package:flutter/material.dart';

class BrandLoadingState extends StatefulWidget {
  const BrandLoadingState({super.key});

  @override
  State<BrandLoadingState> createState() => _BrandLoadingStateState();
}

class _BrandLoadingStateState extends State<BrandLoadingState>
    with SingleTickerProviderStateMixin {
  late final AnimationController _shimmerController;

  @override
  void initState() {
    super.initState();

    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(
        16,
        4,
        16,
        24,
      ),
      children: [
        _buildSummaryShimmer(),
        const SizedBox(height: 18),
        _buildSectionHeaderShimmer(),
        const SizedBox(height: 10),
        ...List.generate(
          3,
          (index) => Padding(
            padding: EdgeInsets.only(
              bottom: index == 2 ? 0 : 12,
            ),
            child: _BrandCardShimmer(
              animation: _shimmerController,
            ),
          ),
        ),
      ],
    );
  }

  // ==============================================================
  // SUMMARY
  // ==============================================================

  Widget _buildSummaryShimmer() {
    return Row(
      children: [
        Expanded(
          child: ManagementShimmerBox(
            animation: _shimmerController,
            width: double.infinity,
            height: 62,
            borderRadius: 14,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: ManagementShimmerBox(
            animation: _shimmerController,
            width: double.infinity,
            height: 62,
            borderRadius: 14,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: ManagementShimmerBox(
            animation: _shimmerController,
            width: double.infinity,
            height: 62,
            borderRadius: 14,
          ),
        ),
      ],
    );
  }

  // ==============================================================
  // SECTION HEADER
  // ==============================================================

  Widget _buildSectionHeaderShimmer() {
    return Row(
      children: [
        ManagementShimmerBox(
          animation: _shimmerController,
          width: 90,
          height: 14,
          borderRadius: 6,
        ),
        const Spacer(),
        ManagementShimmerBox(
          animation: _shimmerController,
          width: 48,
          height: 22,
          borderRadius: 8,
        ),
      ],
    );
  }
}

// ==================================================================
// BRAND CARD
// ==================================================================

class _BrandCardShimmer extends StatelessWidget {
  final Animation<double> animation;

  const _BrandCardShimmer({
    required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: MyColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: MyColors.border,
        ),
        boxShadow: [
          BoxShadow(
            color: MyColors.textPrimary.withValues(alpha: .025),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildIdentity(),
          const SizedBox(height: 14),
          _buildFinancialInfo(),
        ],
      ),
    );
  }

  // ==============================================================
  // IDENTITY
  // ==============================================================

  Widget _buildIdentity() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ==========================================================
        // LOGO
        // ==========================================================

        ManagementShimmerBox(
          animation: animation,
          width: 68,
          height: 68,
          borderRadius: 15,
        ),

        const SizedBox(width: 12),

        // ==========================================================
        // CONTENT
        // ==========================================================

        Expanded(
          child: SizedBox(
            height: 68,
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    right: 32,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Nama brand
                      ManagementShimmerBox(
                        animation: animation,
                        width: 125,
                        height: 15,
                        borderRadius: 6,
                      ),

                      const SizedBox(height: 6),

                      // Keterangan baris pertama
                      ManagementShimmerBox(
                        animation: animation,
                        width: double.infinity,
                        height: 10,
                        borderRadius: 5,
                      ),

                      const SizedBox(height: 5),

                      // Keterangan baris kedua
                      ManagementShimmerBox(
                        animation: animation,
                        width: 145,
                        height: 10,
                        borderRadius: 5,
                      ),

                      const Spacer(),

                      // Meta badge
                      Row(
                        children: [
                          ManagementShimmerBox(
                            animation: animation,
                            width: 48,
                            height: 19,
                            borderRadius: 7,
                          ),
                          const SizedBox(width: 7),
                          ManagementShimmerBox(
                            animation: animation,
                            width: 68,
                            height: 22,
                            borderRadius: 8,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // ==================================================
                // POPUP MENU
                // ==================================================

                Positioned(
                  top: -2,
                  right: -2,
                  child: ManagementShimmerBox(
                    animation: animation,
                    width: 25,
                    height: 25,
                    borderRadius: 8,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ==============================================================
  // FINANCIAL
  // ==============================================================

  Widget _buildFinancialInfo() {
    return Container(
      width: double.infinity,
      height: 62,
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: MyColors.background,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(
          color: MyColors.divider,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: _FinancialItemShimmer(
              animation: animation,
            ),
          ),
          _buildDivider(),
          Expanded(
            child: _FinancialItemShimmer(
              animation: animation,
            ),
          ),
          _buildDivider(),
          Expanded(
            child: _FinancialItemShimmer(
              animation: animation,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      width: 1,
      height: 38,
      margin: const EdgeInsets.symmetric(
        horizontal: 5,
      ),
      color: MyColors.divider,
    );
  }
}

// ==================================================================
// FINANCIAL ITEM
// ==================================================================

class _FinancialItemShimmer extends StatelessWidget {
  final Animation<double> animation;

  const _FinancialItemShimmer({
    required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            ManagementShimmerBox(
              animation: animation,
              width: 22,
              height: 22,
              borderRadius: 7,
            ),
            const SizedBox(width: 6),
            Expanded(
              child: ManagementShimmerBox(
                animation: animation,
                width: double.infinity,
                height: 9,
                borderRadius: 4,
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        ManagementShimmerBox(
          animation: animation,
          width: 70,
          height: 11,
          borderRadius: 5,
        ),
      ],
    );
  }
}
