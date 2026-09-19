import 'package:cashier_management/controllers/category_controller.dart';
import 'package:cashier_management/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoryFilter extends StatelessWidget {
  final CategoryController controller;

  const CategoryFilter({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        0,
        20,
        18,
      ),
      child: Column(
        children: [
          // =========================================================
          // SEARCH
          // =========================================================

          Container(
            height: 50,
            decoration: BoxDecoration(
              color: MyColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: MyColors.border,
              ),
            ),
            child: TextField(
              controller: controller.searchBarController,
              textInputAction: TextInputAction.search,
              onChanged: (_) {
                controller.getData();
              },
              decoration: const InputDecoration(
                border: InputBorder.none,
                prefixIcon: Icon(
                  Icons.search_rounded,
                  color: MyColors.textMuted,
                ),
                hintText: 'Cari kategori...',
                hintStyle: TextStyle(
                  color: MyColors.textMuted,
                  fontSize: 14,
                ),
                contentPadding: EdgeInsets.symmetric(
                  vertical: 14,
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          // =========================================================
          // FILTER + SORT
          // =========================================================

          Row(
            children: [
              Expanded(
                child: Obx(
                  () => _FilterButton(
                    label: 'Semua',
                    selected: controller.tags.length == 2,
                    onTap: () {
                      controller.tags.assignAll([
                        'PENGELUARAN',
                        'PEMASUKAN',
                      ]);

                      controller.getData();
                    },
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Obx(
                  () => _FilterButton(
                    label: 'Pemasukan',
                    selected: controller.tags.length == 1 &&
                        controller.tags.first == 'PEMASUKAN',
                    onTap: () {
                      controller.tags.assignAll([
                        'PEMASUKAN',
                      ]);

                      controller.getData();
                    },
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Obx(
                  () => _FilterButton(
                    label: 'Pengeluaran',
                    selected: controller.tags.length == 1 &&
                        controller.tags.first == 'PENGELUARAN',
                    onTap: () {
                      controller.tags.assignAll([
                        'PENGELUARAN',
                      ]);

                      controller.getData();
                    },
                  ),
                ),
              ),
              const SizedBox(width: 8),
              _SortButton(
                controller: controller,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FilterButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FilterButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? MyColors.primary : MyColors.surface,
      borderRadius: BorderRadius.circular(13),
      child: InkWell(
        borderRadius: BorderRadius.circular(13),
        onTap: onTap,
        child: Container(
          height: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(13),
            border: Border.all(
              color: selected ? MyColors.primary : MyColors.border,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: selected ? MyColors.textOnPrimary : MyColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}

class _SortButton extends StatelessWidget {
  final CategoryController controller;

  const _SortButton({
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: MyColors.surface,
      borderRadius: BorderRadius.circular(13),
      child: InkWell(
        borderRadius: BorderRadius.circular(13),
        onTap: controller.toggleSort,
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(13),
            border: Border.all(
              color: MyColors.border,
            ),
          ),
          child: Obx(
            () => Icon(
              controller.sortOrder.value == 'ASC'
                  ? Icons.arrow_downward_rounded
                  : Icons.arrow_upward_rounded,
              size: 18,
              color: MyColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}
