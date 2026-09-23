import 'package:cashier_management/utils/colors.dart';
import 'package:cashier_management/utils/management_shimmer_box.dart';
import 'package:flutter/material.dart';

class BranchLoadingState extends StatefulWidget {
  const BranchLoadingState({super.key});

  @override
  State<BranchLoadingState> createState() => _BranchLoadingStateState();
}

class _BranchLoadingStateState extends State<BranchLoadingState>
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
        _buildSectionHeaderShimmer(),
        const SizedBox(height: 10),
        ...List.generate(
          5,
          (index) => Padding(
            padding: EdgeInsets.only(
              bottom: index == 4 ? 0 : 12,
            ),
            child: _BranchCardShimmer(
              animation: _shimmerController,
            ),
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
          width: 105,
          height: 14,
          borderRadius: 6,
        ),
        const Spacer(),
        ManagementShimmerBox(
          animation: _shimmerController,
          width: 62,
          height: 24,
          borderRadius: 8,
        ),
      ],
    );
  }
}

// ==================================================================
// BRANCH CARD
// ==================================================================

class _BranchCardShimmer extends StatelessWidget {
  final Animation<double> animation;

  const _BranchCardShimmer({
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
    return SizedBox(
      height: 58,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Nama outlet
                    ManagementShimmerBox(
                      animation: animation,
                      width: 135,
                      height: 15,
                      borderRadius: 6,
                    ),

                    const SizedBox(height: 7),

                    // Alamat baris pertama
                    ManagementShimmerBox(
                      animation: animation,
                      width: double.infinity,
                      height: 10,
                      borderRadius: 5,
                    ),

                    const SizedBox(height: 5),

                    // Alamat baris kedua
                    ManagementShimmerBox(
                      animation: animation,
                      width: 165,
                      height: 10,
                      borderRadius: 5,
                    ),
                  ],
                ),

                // Status berada di bagian bawah,
                // tanpa ikut menambah tinggi Column.
                Positioned(
                  left: 0,
                  bottom: 0,
                  child: ManagementShimmerBox(
                    animation: animation,
                    width: 48,
                    height: 19,
                    borderRadius: 7,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          // More menu
          ManagementShimmerBox(
            animation: animation,
            width: 25,
            height: 25,
            borderRadius: 8,
          ),
        ],
      ),
    );
  }

  // ==============================================================
  // FINANCIAL INFO
  // ==============================================================

  Widget _buildFinancialInfo() {
    return Container(
      width: double.infinity,
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
          width: 72,
          height: 11,
          borderRadius: 5,
        ),
      ],
    );
  }
}
