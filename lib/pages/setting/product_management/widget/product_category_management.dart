import 'package:cashier_management/controllers/product_controller.dart';
import 'package:cashier_management/models/product_category_model.dart';
import 'package:cashier_management/routes.dart';
import 'package:cashier_management/utils/colors.dart';
import 'package:cashier_management/utils/confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductCategoryManagement extends StatelessWidget {
  const ProductCategoryManagement({super.key});

  ProductController get controller => Get.find<ProductController>();

  void _edit(DataProductCategory item) {
    controller.editProductCategory(item);

    Get.toNamed(
      RouterClass.addProductCategory,
    );
  }

  void _status(DataProductCategory item) {
    final newStatus = !(item.status ?? false);

    Get.bottomSheet(
      ConfirmDialog(
        title: newStatus ? 'Aktifkan Kategori' : 'Nonaktifkan Kategori',
        message: newStatus
            ? 'Kategori "${item.name}" akan diaktifkan.'
            : 'Kategori "${item.name}" akan dinonaktifkan.',
        onConfirm: () async {
          controller.updateStatusProductCategory(
            item.idCategories!,
            newStatus,
          );
        },
      ),
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
    );
  }

  void _delete(DataProductCategory item) {
    if (item.statusProduk == 1) {
      Get.snackbar(
        'Tidak dapat dihapus',
        'Kategori ini masih digunakan oleh produk.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: MyColors.errorBg,
        colorText: MyColors.error,
        icon: const Icon(
          Icons.info_outline_rounded,
          color: MyColors.error,
        ),
      );
      return;
    }

    Get.bottomSheet(
      ConfirmDialog(
        title: 'Hapus Kategori',
        message: 'Kategori "${item.name}" akan dihapus.',
        onConfirm: () async {
          controller.deleteProductCategory(
            item.idCategories!,
          );
        },
      ),
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
    );
  }

  Future<void> _refresh() async {
    await controller.fetchDataListProductCategory();
  }

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
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: _CategoryToolbar(
                total: items.length,
              ),
            ),
            if (items.isEmpty)
              const SliverFillRemaining(
                hasScrollBody: false,
                child: _EmptyCategoryState(),
              )
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
                      onStatus: () => _status(item),
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
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: MyColors.surface,
          borderRadius: BorderRadius.circular(17),
          border: Border.all(
            color: MyColors.border,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: MyColors.primaryLight,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(
                Icons.category_outlined,
                color: MyColors.primary,
              ),
            ),
            const SizedBox(width: 12),
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
                    'Atur kelompok dan urutan produk',
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
                '$total',
                style: const TextStyle(
                  color: MyColors.primaryDark,
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================================
// CATEGORY CARD
// ==========================================================

class _CategoryCard extends StatelessWidget {
  final DataProductCategory item;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onStatus;

  const _CategoryCard({
    super.key,
    required this.item,
    required this.onEdit,
    required this.onDelete,
    required this.onStatus,
  });

  @override
  Widget build(BuildContext context) {
    final active = item.status ?? false;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: MyColors.surface,
        borderRadius: BorderRadius.circular(17),
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
            size: 20,
          ),

          const SizedBox(width: 8),

          // ==================================================
          // ICON
          // ==================================================

          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: MyColors.surfaceSoft,
              borderRadius: BorderRadius.circular(13),
            ),
            child: const Icon(
              Icons.category_outlined,
              color: MyColors.primary,
              size: 21,
            ),
          ),

          const SizedBox(width: 11),

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
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.statusProduk == 1
                      ? 'Digunakan oleh produk'
                      : 'Belum digunakan',
                  style: const TextStyle(
                    color: MyColors.textSecondary,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),

          // ==================================================
          // STATUS
          // ==================================================

          GestureDetector(
            onTap: onStatus,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 5,
              ),
              decoration: BoxDecoration(
                color: active ? Colors.green.shade50 : MyColors.errorBg,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                active ? 'Aktif' : 'Nonaktif',
                style: TextStyle(
                  color: active ? Colors.green.shade700 : MyColors.error,
                  fontSize: 9,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),

          const SizedBox(width: 8),

          // ==================================================
          // EDIT
          // ==================================================

          _CategoryActionButton(
            icon: Icons.edit_outlined,
            background: MyColors.primaryLight,
            foreground: MyColors.primaryDark,
            onTap: onEdit,
          ),

          const SizedBox(width: 5),

          // ==================================================
          // DELETE
          // ==================================================

          _CategoryActionButton(
            icon: Icons.delete_outline_rounded,
            background: MyColors.errorBg,
            foreground: MyColors.error,
            onTap: onDelete,
          ),
        ],
      ),
    );
  }
}

class _CategoryActionButton extends StatelessWidget {
  final IconData icon;
  final Color background;
  final Color foreground;
  final VoidCallback onTap;

  const _CategoryActionButton({
    required this.icon,
    required this.background,
    required this.foreground,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: background,
      borderRadius: BorderRadius.circular(9),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(9),
        child: SizedBox(
          width: 34,
          height: 34,
          child: Icon(
            icon,
            size: 16,
            color: foreground,
          ),
        ),
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
