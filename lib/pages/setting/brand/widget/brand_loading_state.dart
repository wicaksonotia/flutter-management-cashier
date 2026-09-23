import 'package:cashier_management/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class BrandLoadingState extends StatelessWidget {
  const BrandLoadingState({super.key});

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
            Expanded(
              child: _ShimmerBox(
                width: double.infinity,
                height: 62,
                borderRadius: 14,
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: _ShimmerBox(
                width: double.infinity,
                height: 62,
                borderRadius: 14,
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: _ShimmerBox(
                width: double.infinity,
                height: 62,
                borderRadius: 14,
              ),
            ),
          ],
        ),
        SizedBox(height: 18),
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
        _BrandCardShimmer(),
        SizedBox(height: 12),
        _BrandCardShimmer(),
        SizedBox(height: 12),
        _BrandCardShimmer(),
      ],
    );
  }
}

class _BrandCardShimmer extends StatelessWidget {
  const _BrandCardShimmer();

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
              children: [
                Container(
                  width: 68,
                  height: 68,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 120,
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
                        width: 145,
                        height: 9,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Container(
                            width: 55,
                            height: 20,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          const SizedBox(width: 7),
                          Container(
                            width: 70,
                            height: 20,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ],
                      ),
                    ],
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
          borderRadius: BorderRadius.circular(
            borderRadius,
          ),
        ),
      ),
    );
  }
}
