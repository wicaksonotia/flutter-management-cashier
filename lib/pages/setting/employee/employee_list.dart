import 'package:cashier_management/controllers/employee_controller.dart';
import 'package:cashier_management/pages/setting/employee/employee_item.dart';
import 'package:cashier_management/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EmployeeList extends StatefulWidget {
  final EmployeeController controller;

  const EmployeeList({
    super.key,
    required this.controller,
  });

  @override
  State<EmployeeList> createState() => _EmployeeListState();
}

class _EmployeeListState extends State<EmployeeList>
    with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();

  late final AnimationController _shimmerController;

  EmployeeController get controller => widget.controller;

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
    _scrollController.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // ==========================================================
      // LOADING
      // ==========================================================

      if (controller.isLoadingEmployee.value &&
          controller.resultDataEmployee.isEmpty) {
        return _buildLoadingState();
      }

      // ==========================================================
      // EMPTY
      // ==========================================================

      if (controller.resultDataEmployee.isEmpty) {
        return _buildEmptyState();
      }

      // ==========================================================
      // DATA
      // ==========================================================

      return ListView.separated(
        controller: _scrollController,
        padding: const EdgeInsets.fromLTRB(
          16,
          8,
          16,
          110,
        ),
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: controller.resultDataEmployee.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final item = controller.resultDataEmployee[index];

          return EmployeeItem(
            model: item,
            controller: controller,
          );
        },
      );
    });
  }

  // ==============================================================
  // LOADING
  // ==============================================================

  Widget _buildLoadingState() {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(
        16,
        8,
        16,
        110,
      ),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 6,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (_, __) {
        return _EmployeeItemShimmer(
          animation: _shimmerController,
        );
      },
    );
  }

  // ==============================================================
  // EMPTY
  // ==============================================================

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
              width: 68,
              height: 68,
              decoration: BoxDecoration(
                color: MyColors.primaryLight,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.groups_outlined,
                size: 32,
                color: MyColors.primaryDark,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Belum ada karyawan',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: MyColors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Tambahkan karyawan untuk mengatur akun '
              'kasir dan akses outlet.',
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

// ==================================================================
// SHIMMER
// ==================================================================

class _EmployeeItemShimmer extends StatelessWidget {
  final Animation<double> animation;

  const _EmployeeItemShimmer({
    required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: MyColors.surface,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.all(13),
        child: Column(
          children: [
            Row(
              children: [
                _ShimmerBox(
                  animation: animation,
                  width: 48,
                  height: 48,
                  borderRadius: 15,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _ShimmerBox(
                        animation: animation,
                        width: 130,
                        height: 13,
                        borderRadius: 6,
                      ),
                      const SizedBox(height: 8),
                      _ShimmerBox(
                        animation: animation,
                        width: 90,
                        height: 10,
                        borderRadius: 5,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                _ShimmerBox(
                  animation: animation,
                  width: 45,
                  height: 20,
                  borderRadius: 8,
                ),
              ],
            ),
            const SizedBox(height: 14),
            _ShimmerBox(
              animation: animation,
              width: double.infinity,
              height: 10,
              borderRadius: 5,
            ),
            const SizedBox(height: 8),
            _ShimmerBox(
              animation: animation,
              width: 180,
              height: 10,
              borderRadius: 5,
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: _ShimmerBox(
                    animation: animation,
                    width: double.infinity,
                    height: 30,
                    borderRadius: 8,
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: _ShimmerBox(
                    animation: animation,
                    width: double.infinity,
                    height: 30,
                    borderRadius: 8,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

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
              begin: Alignment(
                position - 1,
                0,
              ),
              end: Alignment(
                position + 1,
                0,
              ),
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
