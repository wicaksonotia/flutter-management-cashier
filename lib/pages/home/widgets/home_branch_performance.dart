import 'package:cashier_management/controllers/total_per_type_controller.dart';
import 'package:cashier_management/models/outlet_branch_model.dart';
import 'package:cashier_management/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeBranchPerformance extends StatelessWidget {
  const HomeBranchPerformance({super.key});

  @override
  Widget build(BuildContext context) {
    final TotalPerTypeController controller =
        Get.find<TotalPerTypeController>();

    return Obx(() {
      if (controller.isLoading.value && controller.resultItem.isEmpty) {
        return const _BranchLoading();
      }

      final branches = controller.resultItem
          .where(
            (item) =>
                item.status != false &&
                item.cabang != null &&
                item.cabang!.trim().isNotEmpty,
          )
          .toList();

      if (branches.isEmpty) {
        return const _BranchEmpty();
      }

      branches.sort((a, b) {
        final incomeA = a.details?.income ?? 0;
        final incomeB = b.details?.income ?? 0;

        return incomeB.compareTo(incomeA);
      });

      final visibleBranches = branches.take(3).toList();

      int maxIncome = 0;

      for (final branch in branches) {
        final income = branch.details?.income ?? 0;

        if (income > maxIncome) {
          maxIncome = income;
        }
      }

      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: MyColors.surface,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: MyColors.border,
          ),
        ),
        child: Column(
          children: [
            for (int index = 0; index < visibleBranches.length; index++) ...[
              _BranchItem(
                branch: visibleBranches[index],
                maxIncome: maxIncome,
                rank: index + 1,
              ),
              if (index < visibleBranches.length - 1)
                const SizedBox(height: 18),
            ],
          ],
        ),
      );
    });
  }
}

class _BranchItem extends StatelessWidget {
  final DataListOutletBranch branch;
  final int maxIncome;
  final int rank;

  const _BranchItem({
    required this.branch,
    required this.maxIncome,
    required this.rank,
  });

  @override
  Widget build(BuildContext context) {
    final int income = branch.details?.income ?? 0;

    final double percentage =
        maxIncome <= 0 ? 0 : (income / maxIncome).clamp(0.0, 1.0);

    return Column(
      children: [
        Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: MyColors.primaryLight,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.storefront_rounded,
                size: 17,
                color: MyColors.primary,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    branch.cabang ?? '-',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: MyColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    branch.kode ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 9,
                      color: MyColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              _formatRupiah(income),
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: MyColors.textSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 9),
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: LinearProgressIndicator(
            value: percentage,
            minHeight: 6,
            backgroundColor: MyColors.surfaceSoft,
            color: rank == 1
                ? MyColors.primary
                : MyColors.primary.withValues(alpha: .65),
          ),
        ),
      ],
    );
  }

  String _formatRupiah(int value) {
    if (value >= 1000000) {
      final juta = value / 1000000;

      if (juta == juta.roundToDouble()) {
        return 'Rp ${juta.toInt()} Jt';
      }

      return 'Rp ${juta.toStringAsFixed(1)} Jt';
    }

    if (value >= 1000) {
      final ribu = value / 1000;

      if (ribu == ribu.roundToDouble()) {
        return 'Rp ${ribu.toInt()}K';
      }

      return 'Rp ${ribu.toStringAsFixed(1)}K';
    }

    return 'Rp $value';
  }
}

class _BranchLoading extends StatelessWidget {
  const _BranchLoading();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: MyColors.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: MyColors.border,
        ),
      ),
      child: const Column(
        children: [
          _LoadingBranchItem(),
          SizedBox(height: 18),
          _LoadingBranchItem(),
          SizedBox(height: 18),
          _LoadingBranchItem(),
        ],
      ),
    );
  }
}

class _LoadingBranchItem extends StatelessWidget {
  const _LoadingBranchItem();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: MyColors.background,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Container(
                height: 12,
                decoration: BoxDecoration(
                  color: MyColors.background,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Container(
              width: 60,
              height: 11,
              decoration: BoxDecoration(
                color: MyColors.background,
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ],
        ),
        const SizedBox(height: 9),
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: const LinearProgressIndicator(
            value: .45,
            minHeight: 6,
            backgroundColor: MyColors.background,
            color: MyColors.primaryLight,
          ),
        ),
      ],
    );
  }
}

class _BranchEmpty extends StatelessWidget {
  const _BranchEmpty();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 28,
      ),
      decoration: BoxDecoration(
        color: MyColors.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: MyColors.border,
        ),
      ),
      child: const Column(
        children: [
          Icon(
            Icons.storefront_outlined,
            size: 32,
            color: MyColors.textMuted,
          ),
          SizedBox(height: 10),
          Text(
            'Belum ada data outlet',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: MyColors.textSecondary,
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Data performa outlet akan muncul setelah tersedia.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              color: MyColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}
