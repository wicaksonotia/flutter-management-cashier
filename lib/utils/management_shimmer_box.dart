import 'package:cashier_management/utils/colors.dart';
import 'package:flutter/material.dart';

class ManagementShimmerBox extends StatelessWidget {
  final Animation<double> animation;
  final double width;
  final double height;
  final double borderRadius;

  const ManagementShimmerBox({
    super.key,
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
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            final slide = animation.value;

            return LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              stops: const [
                0.0,
                0.5,
                1.0,
              ],
              colors: [
                MyColors.surfaceSoft,
                MyColors.border.withValues(alpha: .55),
                MyColors.surfaceSoft,
              ],
              transform: _ShimmerGradientTransform(
                slide,
              ),
            ).createShader(bounds);
          },
          child: child,
        );
      },
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

// ================================================================
// GRADIENT TRANSFORM
// ================================================================

class _ShimmerGradientTransform extends GradientTransform {
  final double slidePercent;

  const _ShimmerGradientTransform(
    this.slidePercent,
  );

  @override
  Matrix4 transform(
    Rect bounds, {
    TextDirection? textDirection,
  }) {
    return Matrix4.translationValues(
      bounds.width * slidePercent,
      0,
      0,
    );
  }
}
