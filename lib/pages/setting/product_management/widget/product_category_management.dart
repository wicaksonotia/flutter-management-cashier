import 'package:cashier_management/controllers/product_controller.dart';
import 'package:cashier_management/models/product_category_model.dart';
import 'package:cashier_management/pages/setting/product_management/widget/management_action_button.dart';
import 'package:cashier_management/routes.dart';
import 'package:cashier_management/utils/colors.dart';
import 'package:cashier_management/utils/confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductCategoryManagement extends StatelessWidget {
  const ProductCategoryManagement({super.key});

  ProductController get controller => Get.find<ProductController>();

  // ==========================================================
  // EDIT
  // ==========================================================

  Future<void> _edit(DataProductCategory item) async {
    controller.editProductCategory(item);

    final result = await Get.toNamed(
      RouterClass.addProductCategory,
    );

    if (result == true) {
      await controller.fetchDataListProductCategory();
    }
  }

  // ==========================================================
  // STATUS
  // ==========================================================

  Future<void> _status(
    BuildContext context,
    DataProductCategory item,
  ) async {
    final currentStatus = item.status ?? false;
    final newStatus = !currentStatus;

    final confirmed = await AppConfirmDialog.show(
      context,
      title: newStatus ? 'Aktifkan Kategori' : 'Nonaktifkan Kategori',
      message: newStatus
          ? 'Kategori "${item.name}" akan diaktifkan.'
          : 'Kategori "${item.name}" akan dinonaktifkan.',
      confirmText: newStatus ? 'Aktifkan' : 'Nonaktifkan',
      cancelText: 'Batal',
      icon:
          newStatus ? Icons.check_circle_outline_rounded : Icons.block_outlined,
      type: newStatus ? AppConfirmType.success : AppConfirmType.danger,
    );

    if (!confirmed) {
      return;
    }

    final id = item.idCategories;

    if (id == null || id <= 0) {
      return;
    }

    await controller.updateStatusProductCategory(
      id,
      newStatus,
    );
  }

  // ==========================================================
  // DELETE
  // ==========================================================

  Future<void> _delete(DataProductCategory item) async {
    final id = item.idCategories;

    if (id == null || id <= 0) {
      return;
    }

    final confirmed = await AppConfirmDialog.show(
      Get.context!,
      title: 'Hapus Kategori',
      message:
          'Kategori "${item.name}" akan dihapus. Data yang sudah dihapus tidak dapat dikembalikan.',
      confirmText: 'Hapus',
      cancelText: 'Batal',
      icon: Icons.delete_outline_rounded,
      type: AppConfirmType.danger,
    );

    if (!confirmed) {
      return;
    }

    await controller.deleteProductCategory(id);
  }

  // ==========================================================
  // REFRESH
  // ==========================================================

  Future<void> _refresh() async {
    await controller.fetchDataListProductCategory();
  }

  // ==========================================================
  // BUILD
  // ==========================================================

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: MyColors.primary,
      onRefresh: _refresh,
      child: Obx(() {
        final items = controller.resultDataProductCategory.toList();

        if (controller.isLoadingList.value && items.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(
              color: MyColors.primary,
            ),
          );
        }

        return CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          slivers: [
            // ==================================================
            // TOOLBAR
            // ==================================================

            SliverToBoxAdapter(
              child: _CategoryToolbar(
                total: items.length,
              ),
            ),

            // ==================================================
            // EMPTY
            // ==================================================

            if (items.isEmpty)
              const SliverFillRemaining(
                hasScrollBody: false,
                child: _EmptyCategoryState(),
              )

            // ==================================================
            // LIST
            // ==================================================

            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(
                  16,
                  0,
                  16,
                  28,
                ),
                sliver: SliverReorderableList(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];

                    return _CategoryCard(
                      key: ValueKey(item.idCategories),
                      item: item,
                      onEdit: () => _edit(item),
                      onDelete: () => _delete(item),
                      onStatus: () => _status(context, item),
                      canDelete: item.statusProduk != 1,
                    );
                  },
                  onReorder: controller.reorderCategory,
                ),
              ),
          ],
        );
      }),
    );
  }
}

// ==========================================================
// TOOLBAR
// ==========================================================

class _CategoryToolbar extends StatelessWidget {
  final int total;

  const _CategoryToolbar({
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        16,
        4,
        16,
        12,
      ),
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Kategori Produk',
                  style: TextStyle(
                    color: MyColors.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  'Kelola kategori dan urutan produk',
                  style: TextStyle(
                    color: MyColors.textSecondary,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 11,
              vertical: 7,
            ),
            decoration: BoxDecoration(
              color: MyColors.primaryLight,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              '$total kategori',
              style: const TextStyle(
                color: MyColors.primaryDark,
                fontSize: 11,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ==========================================================
// CATEGORY CARD
// ==========================================================

class _CategoryCard extends StatelessWidget {
  final bool canDelete;
  final DataProductCategory item;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onStatus;

  const _CategoryCard(
      {super.key,
      required this.item,
      required this.onEdit,
      required this.onDelete,
      required this.onStatus,
      required this.canDelete});

  @override
  Widget build(BuildContext context) {
    final active = item.status ?? false;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: MyColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: MyColors.border,
        ),
      ),
      child: Row(
        children: [
          // ==================================================
          // DRAG HANDLE
          // ==================================================

          const Icon(
            Icons.drag_indicator_rounded,
            color: MyColors.textMuted,
            size: 18,
          ),

          const SizedBox(width: 7),

          // ==================================================
          // CATEGORY ICON
          // ==================================================

          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: MyColors.primaryLight,
              borderRadius: BorderRadius.circular(11),
            ),
            child: const Icon(
              Icons.category_outlined,
              color: MyColors.primary,
              size: 18,
            ),
          ),

          const SizedBox(width: 10),

          // ==================================================
          // CONTENT
          // ==================================================

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name ?? '-',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: MyColors.textPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.inventory_2_outlined,
                      size: 12,
                      color: MyColors.textMuted,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        item.statusProduk == 1
                            ? 'Digunakan oleh produk'
                            : 'Belum digunakan',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: MyColors.textSecondary,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          // ==================================================
          // ACTIONS
          // ==================================================

          ManagementActionButton(
            icon: active
                ? Icons.check_circle_outline_rounded
                : Icons.block_outlined,
            label: active ? 'Aktif' : 'Nonaktif',
            background: active ? MyColors.successBg : MyColors.errorBg,
            foreground: active ? MyColors.success : MyColors.error,
            onTap: onStatus,
          ),

          const SizedBox(width: 5),

          ManagementActionButton(
            icon: Icons.edit_outlined,
            background: MyColors.primaryLight,
            foreground: MyColors.primaryDark,
            onTap: onEdit,
          ),

          const SizedBox(width: 5),

          ManagementActionButton(
            icon: Icons.delete_outline_rounded,
            background: canDelete ? MyColors.errorBg : MyColors.surfaceSoft,
            foreground: canDelete ? MyColors.error : MyColors.textMuted,
            onTap: canDelete ? onDelete : null,
          ),
        ],
      ),
    );
  }
}

// ==========================================================
// EMPTY
// ==========================================================

class _EmptyCategoryState extends StatelessWidget {
  const _EmptyCategoryState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 76,
              height: 76,
              decoration: BoxDecoration(
                color: MyColors.surfaceSoft,
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Icon(
                Icons.category_outlined,
                size: 34,
                color: MyColors.textMuted,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Belum ada kategori',
              style: TextStyle(
                color: MyColors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Buat kategori untuk mengelompokkan produk.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: MyColors.textSecondary,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
