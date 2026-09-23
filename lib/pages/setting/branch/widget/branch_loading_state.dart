import 'package:cashier_management/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class BranchLoadingState extends StatelessWidget {
  const BranchLoadingState({super.key});

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
      children: const [
        Row(
          children: [
            _ShimmerBox(
              width: 90,
              height: 13,
              borderRadius: 6,
            ),
            Spacer(),
            _ShimmerBox(
              width: 48,
              height: 22,
              borderRadius: 8,
            ),
          ],
        ),
        SizedBox(height: 10),
        _BranchCardShimmer(),
        SizedBox(height: 12),
        _BranchCardShimmer(),
        SizedBox(height: 12),
        _BranchCardShimmer(),
      ],
    );
  }
}

class _BranchCardShimmer extends StatelessWidget {
  const _BranchCardShimmer();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: MyColors.surfaceSoft,
      highlightColor: MyColors.surface,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: MyColors.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: MyColors.border,
          ),
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 130,
                        height: 13,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        height: 9,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        width: 170,
                        height: 9,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        width: 55,
                        height: 20,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Container(
              height: 62,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(13),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ShimmerBox extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;

  const _ShimmerBox({
    required this.width,
    required this.height,
    required this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: MyColors.surfaceSoft,
      highlightColor: MyColors.surface,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: MyColors.surfaceSoft,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}
