import 'package:cashier_management/controllers/product_controller.dart';
import 'package:cashier_management/models/product_model.dart';
import 'package:cashier_management/pages/setting/product_management/widget/product_management_card.dart';
import 'package:cashier_management/routes.dart';
import 'package:cashier_management/utils/colors.dart';
import 'package:cashier_management/utils/confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductListManagement extends StatefulWidget {
  const ProductListManagement({super.key});

  @override
  State<ProductListManagement> createState() => _ProductListManagementState();
}

class _ProductListManagementState extends State<ProductListManagement> {
  late final ProductController controller;

  final searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    controller = Get.find<ProductController>();

    searchController.text = controller.searchProduct.value;
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> _refresh() async {
    await controller.fetchDataListProduct();
  }

  void _search(String value) {
    controller.setProductSearch(value);
  }

  void _edit(DataProduct item) {
    controller.editProduct(item);

    Get.toNamed(
      RouterClass.addProduct,
    );
  }

  void _status(DataProduct item) {
    final newStatus = !(item.status ?? false);

    Get.bottomSheet(
      ConfirmDialog(
        title: newStatus ? 'Aktifkan Produk' : 'Nonaktifkan Produk',
        message: newStatus
            ? 'Produk "${item.name}" akan diaktifkan.'
            : 'Produk "${item.name}" akan dinonaktifkan.',
        onConfirm: () async {
          await controller.updateStatusProduct(
            item.idProduct!,
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

  void _delete(DataProduct item) {
    if ((item.statusTransaksi ?? 0) == 1) {
      Get.snackbar(
        'Tidak dapat dihapus',
        'Produk ini sudah pernah digunakan dalam transaksi.',
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
        title: 'Hapus Produk',
        message: 'Produk "${item.name}" akan dihapus.',
        onConfirm: () async {
          await controller.deleteProduct(
            item.idProduct!,
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

  void _favorite(DataProduct item) {
    controller.toggleFavorite(
      item.idProduct!,
      !(item.favorite ?? false),
    );
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: MyColors.primary,
      onRefresh: _refresh,
      child: Obx(() {
        final products = controller.filteredProducts;

        if (controller.isLoadingListProduct.value &&
            controller.resultDataProduct.isEmpty) {
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
              child: _ProductToolbar(
                controller: controller,
                searchController: searchController,
                onSearch: _search,
              ),
            ),
            SliverToBoxAdapter(
              child: _ProductResultHeader(
                total: products.length,
                allTotal: controller.resultDataProduct.length,
              ),
            ),
            if (products.isEmpty)
              const SliverFillRemaining(
                hasScrollBody: false,
                child: _EmptyProductState(),
              )
            else if (controller.isGridView.value)
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(
                  16,
                  0,
                  16,
                  28,
                ),
                sliver: SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final item = products[index];

                      return ProductManagementCard(
                        item: item,
                        isGrid: true,
                        onEdit: () => _edit(item),
                        onStatus: () => _status(item),
                        onDelete: () => _delete(item),
                        onFavorite: () => _favorite(item),
                      );
                    },
                    childCount: products.length,
                  ),
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 330,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    mainAxisExtent: 282,
                  ),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(
                  16,
                  0,
                  16,
                  28,
                ),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final item = products[index];

                      return ProductManagementCard(
                        item: item,
                        isGrid: false,
                        onEdit: () => _edit(item),
                        onStatus: () => _status(item),
                        onDelete: () => _delete(item),
                        onFavorite: () => _favorite(item),
                      );
                    },
                    childCount: products.length,
                  ),
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

class _ProductToolbar extends StatelessWidget {
  final ProductController controller;
  final TextEditingController searchController;
  final ValueChanged<String> onSearch;

  const _ProductToolbar({
    required this.controller,
    required this.searchController,
    required this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        16,
        4,
        16,
        10,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 44,
                  decoration: BoxDecoration(
                    color: MyColors.surface,
                    borderRadius: BorderRadius.circular(13),
                    border: Border.all(
                      color: MyColors.border,
                    ),
                  ),
                  child: TextField(
                    controller: searchController,
                    onChanged: onSearch,
                    textInputAction: TextInputAction.search,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: const Icon(
                        Icons.search_rounded,
                        size: 20,
                        color: MyColors.textMuted,
                      ),
                      suffixIcon: searchController.text.isNotEmpty
                          ? IconButton(
                              onPressed: () {
                                searchController.clear();
                                onSearch('');
                              },
                              icon: const Icon(
                                Icons.close_rounded,
                                size: 18,
                              ),
                            )
                          : null,
                      hintText: 'Cari produk...',
                      hintStyle: const TextStyle(
                        color: MyColors.textMuted,
                        fontSize: 12,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 12,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Obx(
                () => _ViewToggle(
                  isGrid: controller.isGridView.value,
                  onToggle: controller.toggleProductView,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _CategoryChips(
            controller: controller,
          ),
        ],
      ),
    );
  }
}

// ==========================================================
// CATEGORY CHIPS
// ==========================================================

class _CategoryChips extends StatelessWidget {
  final ProductController controller;

  const _CategoryChips({
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38,
      child: Obx(() {
        final categories = controller.resultDataProductCategory;

        if (categories.isEmpty) {
          return const SizedBox.shrink();
        }

        return ListView.separated(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(right: 4),
          itemCount: categories.length,
          separatorBuilder: (_, __) => const SizedBox(width: 7),
          itemBuilder: (context, index) {
            final category = categories[index];

            final categoryId = category.idCategories ?? 0;

            return _CategoryChip(
              label: category.name ?? '-',
              selected:
                  controller.selectedProductCategoryId.value == categoryId,
              onTap: () {
                controller.setProductCategory(
                  categoryId,
                );
              },
            );
          },
        );
      }),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? MyColors.primary : MyColors.surface,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
          ),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: selected ? MyColors.primary : MyColors.border,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: selected ? Colors.white : MyColors.textSecondary,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}

// ==========================================================
// VIEW TOGGLE
// ==========================================================

class _ViewToggle extends StatelessWidget {
  final bool isGrid;
  final VoidCallback onToggle;

  const _ViewToggle({
    required this.isGrid,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: MyColors.surfaceSoft,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(
          color: MyColors.border,
        ),
      ),
      child: Row(
        children: [
          _ToggleButton(
            selected: isGrid,
            icon: Icons.grid_view_rounded,
            onTap: isGrid ? null : onToggle,
          ),
          _ToggleButton(
            selected: !isGrid,
            icon: Icons.view_list_rounded,
            onTap: isGrid ? onToggle : null,
          ),
        ],
      ),
    );
  }
}

class _ToggleButton extends StatelessWidget {
  final bool selected;
  final IconData icon;
  final VoidCallback? onTap;

  const _ToggleButton({
    required this.selected,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? MyColors.surface : Colors.transparent,
      borderRadius: BorderRadius.circular(9),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(9),
        child: SizedBox(
          width: 35,
          height: 35,
          child: Icon(
            icon,
            size: 18,
            color: selected ? MyColors.primary : MyColors.textMuted,
          ),
        ),
      ),
    );
  }
}

// ==========================================================
// RESULT HEADER
// ==========================================================

class _ProductResultHeader extends StatelessWidget {
  final int total;
  final int allTotal;

  const _ProductResultHeader({
    required this.total,
    required this.allTotal,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        18,
        0,
        18,
        10,
      ),
      child: Row(
        children: [
          Text(
            '$total produk',
            style: const TextStyle(
              color: MyColors.textPrimary,
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
          ),
          if (total != allTotal) ...[
            const SizedBox(width: 6),
            Text(
              'dari $allTotal',
              style: const TextStyle(
                color: MyColors.textMuted,
                fontSize: 11,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ==========================================================
// EMPTY
// ==========================================================

class _EmptyProductState extends StatelessWidget {
  const _EmptyProductState();

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
                Icons.inventory_2_outlined,
                size: 34,
                color: MyColors.textMuted,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Produk tidak ditemukan',
              style: TextStyle(
                color: MyColors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Coba ubah kata pencarian atau pilih kategori lain.',
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
