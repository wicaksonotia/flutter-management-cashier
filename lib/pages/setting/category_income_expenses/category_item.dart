import 'package:cashier_management/controllers/category_controller.dart';
import 'package:cashier_management/models/category_model.dart';
import 'package:cashier_management/pages/setting/category_income_expenses/category_form.dart';
import 'package:cashier_management/utils/colors.dart';
import 'package:flutter/material.dart';

class CategoryItem extends StatelessWidget {
  final DataCategory model;
  final CategoryController controller;

  const CategoryItem({
    super.key,
    required this.model,
    required this.controller,
  });

  bool get isIncome => model.categoryType == 'PEMASUKAN';

  @override
  Widget build(BuildContext context) {
    final Color accent = isIncome ? MyColors.primary : MyColors.error;

    final Color accentBackground =
        isIncome ? MyColors.primaryLight : MyColors.errorBg;

    return Material(
      color: MyColors.surface,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () => _showEditForm(context),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              // =====================================================
              // ICON
              // =====================================================

              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: accentBackground,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  isIncome
                      ? Icons.south_west_rounded
                      : Icons.north_east_rounded,
                  color: accent,
                  size: 21,
                ),
              ),

              const SizedBox(width: 13),

              // =====================================================
              // CONTENT
              // =====================================================

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      model.categoryName ?? '-',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: MyColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 7,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: accentBackground,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            isIncome ? 'PEMASUKAN' : 'PENGELUARAN',
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              color: accent,
                              letterSpacing: .3,
                            ),
                          ),
                        ),
                        const SizedBox(width: 7),
                        Text(
                          model.status == true ? 'Aktif' : 'Nonaktif',
                          style: const TextStyle(
                            fontSize: 11,
                            color: MyColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              // =====================================================
              // STATUS
              // =====================================================

              Transform.scale(
                scale: .78,
                child: Switch.adaptive(
                  value: model.status ?? false,
                  activeTrackColor: MyColors.primary,
                  onChanged: (value) {
                    if (model.id != null) {
                      controller.updateStatusCategory(
                        model.id!,
                        value,
                      );
                    }
                  },
                ),
              ),

              // =====================================================
              // MENU
              // =====================================================

              PopupMenuButton<String>(
                padding: EdgeInsets.zero,
                icon: const Icon(
                  Icons.more_vert_rounded,
                  color: MyColors.textMuted,
                  size: 20,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                onSelected: (value) {
                  if (value == 'edit') {
                    _showEditForm(context);
                  }

                  if (value == 'delete') {
                    _confirmDelete(context);
                  }
                },
                itemBuilder: (_) => const [
                  PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(
                          Icons.edit_outlined,
                          size: 18,
                        ),
                        SizedBox(width: 10),
                        Text('Edit'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(
                          Icons.delete_outline_rounded,
                          size: 18,
                          color: MyColors.error,
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Hapus',
                          style: TextStyle(
                            color: MyColors.error,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ===============================================================
  // EDIT
  // ===============================================================

  void _showEditForm(BuildContext context) {
    controller.editCategory(model);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      builder: (_) {
        return Container(
          constraints: const BoxConstraints(
            maxHeight: 700,
          ),
          decoration: const BoxDecoration(
            color: MyColors.surface,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(28),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),
              Container(
                width: 42,
                height: 4,
                decoration: BoxDecoration(
                  color: MyColors.border,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              Flexible(
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: const Padding(
                    padding: EdgeInsets.fromLTRB(
                      20,
                      8,
                      20,
                      24,
                    ),
                    child: CategoryForm(),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ===============================================================
  // DELETE CONFIRMATION
  // ===============================================================

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          backgroundColor: MyColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'Hapus kategori?',
            style: TextStyle(
              fontWeight: FontWeight.w700,
            ),
          ),
          content: Text(
            'Kategori "${model.categoryName}" akan dihapus.',
            style: const TextStyle(
              color: MyColors.textSecondary,
              height: 1.4,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: MyColors.error,
              ),
              onPressed: () {
                Navigator.pop(context);

                if (model.id != null) {
                  controller.deleteCategory(model.id!);
                }
              },
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );
  }
}
