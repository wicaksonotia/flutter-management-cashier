import 'package:cashier_management/controllers/product_category_controller.dart';
import 'package:cashier_management/models/product_category_model.dart';
import 'package:cashier_management/pages/select_table_list_page.dart';
import 'package:cashier_management/routes.dart';
import 'package:cashier_management/utils/colors.dart';
import 'package:cashier_management/utils/confirm_dialog.dart';
import 'package:cashier_management/utils/sizes.dart';
import 'package:flutter/material.dart';
import 'package:cashier_management/pages/navigation_drawer.dart'
    as custom_drawer;
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class ListProductCategoryPage extends StatefulWidget {
  const ListProductCategoryPage({super.key});

  @override
  State<ListProductCategoryPage> createState() =>
      _ListProductCategoryPageState();
}

class _ListProductCategoryPageState extends State<ListProductCategoryPage>
    with SingleTickerProviderStateMixin {
  final ProductCategoryController _productCategoryController =
      Get.put(ProductCategoryController());

  @override
  void initState() {
    super.initState();
    _productCategoryController.fetchDataListKios(
      onAfterSuccess: () async =>
          _productCategoryController.fetchDataListProductCategory(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const custom_drawer.NavigationDrawer(),
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        surfaceTintColor: Colors.transparent,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Product Category',
              style: TextStyle(
                  fontSize: MySizes.fontSizeHeader,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_box_outlined),
            onPressed: () {
              _productCategoryController.clearProductCategoryController();
              Get.toNamed(RouterClass.addproductcategory);
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            /// --- MENU ---
            Container(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
              color: Colors.grey[200],
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // KIOS
                  Obx(() {
                    return DropdownTabButton(
                      label: _productCategoryController.selectedKios.value,
                      isLoading: _productCategoryController.isLoadingKios.value,
                      onTap: () {
                        Get.to(
                          () => SelectTableListPage(
                            title: 'Brand',
                            isLoading: _productCategoryController.isLoadingKios,
                            items: _productCategoryController.resultDataKios,
                            titleBuilder: (data) => data.kios!,
                            subtitleBuilder: (data) => data.keterangan ?? '',
                            isSelected: (data) =>
                                data.idKios ==
                                _productCategoryController.idKios.value,
                            onItemTap: (data) async {
                              _productCategoryController.idKios.value =
                                  data.idKios!;
                              _productCategoryController.selectedKios.value =
                                  data.kios!;
                              await _productCategoryController
                                  .fetchDataListProductCategory();
                              Get.back();
                            },
                            onRefresh: () async {
                              await _productCategoryController
                                  .fetchDataListKios(); // API fetch
                            },
                          ),
                          transition: Transition.rightToLeft,
                          duration: const Duration(milliseconds: 300),
                        );
                      },
                    );
                  }),
                ],
              ),
            ),
            Expanded(
              child: Obx(() {
                if (_productCategoryController.isLoadingList.value) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  final items =
                      _productCategoryController.resultDataProductCategory;
                  if (items.isEmpty) {
                    return const Center(child: Text("No data found"));
                  }
                  return ReorderableListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: items.length,
                    // penting: key unik untuk setiap item
                    itemBuilder: (context, index) {
                      final data = items[index];
                      return Padding(
                        key: ValueKey(
                            data.idCategories), // gunakan ID unik dari model
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        child: ReorderableDragStartListener(
                          index: index,
                          child: Card(
                            color: Colors.white,
                            child: _buildAccountTile(
                              dataProductCategory: data,
                            ),
                          ),
                        ),
                      );
                    },

                    // Fungsi dijalankan saat urutan berubah
                    onReorder: (oldIndex, newIndex) {
                      _productCategoryController.reorderCategory(
                          oldIndex, newIndex);
                    },
                  );
                }
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountTile({
    required DataProductCategory dataProductCategory,
  }) {
    return ListTile(
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            dataProductCategory.name!,
            style: const TextStyle(
              fontWeight: FontWeight.normal,
            ),
          ),
          const Gap(10),
          InkWell(
            onTap: () {
              // DIALOG CONFIRMATION ACTIVE OR INACTIVE
              Get.bottomSheet(
                ConfirmDialog(
                    title: dataProductCategory.status!
                        ? 'Non-Activate Outlet'
                        : 'Activate Outlet',
                    message: dataProductCategory.status!
                        ? 'This outlet will be deactivated.\nAre you sure you want to continue?'
                        : 'This outlet will be activated.\nAre you sure you want to continue?',
                    onConfirm: () async {
                      _productCategoryController.updateStatusProductCategory(
                          dataProductCategory.idCategories!,
                          !dataProductCategory.status!);
                    }),
                isScrollControlled: true,
                backgroundColor: Colors.white,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: dataProductCategory.status!
                    ? Colors.green[200]
                    : Colors.red[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                dataProductCategory.status! ? 'Active' : 'Inactive',
                style: const TextStyle(fontSize: MySizes.fontSizeXsm),
              ),
            ),
          ),
        ],
      ),
      trailing: Positioned(
        child: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == "edit") {
              _productCategoryController
                  .editProductCategory(dataProductCategory);
              Get.toNamed(RouterClass.addproductcategory);
              return;
            }
            if (value == "delete") {
              // can't delete product category, cause product category is in use
              if (dataProductCategory.statusProduk == 1) {
                Get.snackbar(
                  'Error',
                  'Cannot delete this product category. This product category is in use',
                  snackPosition: SnackPosition.TOP,
                  backgroundColor: Colors.red[100],
                  colorText: Colors.red[800],
                );
                return;
              }
              // Show confirmation dialog
              Get.bottomSheet(
                ConfirmDialog(
                  title: 'Delete Product Category',
                  message:
                      'Are you sure, you want to delete this product category?',
                  onConfirm: () async {
                    _productCategoryController.deleteProductCategory(
                        dataProductCategory.idCategories!);
                  },
                ),
                isScrollControlled: true,
                backgroundColor: Colors.white,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
              );
              return;
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: "edit",
              child: Row(
                children: [
                  Icon(Icons.edit),
                  Gap(8),
                  Text("Edit"),
                ],
              ),
            ),
            const PopupMenuItem(
              value: "delete",
              child: Row(
                children: [
                  Icon(Icons.delete),
                  Gap(8),
                  Text("Delete"),
                ],
              ),
            ),
          ],
          color: Colors.white,
          icon: const Icon(Icons.more_vert),
        ),
      ),
    );
  }
}

class DropdownTabButton extends StatelessWidget {
  final String label;
  final bool isLoading;
  final VoidCallback onTap;

  const DropdownTabButton({
    super.key,
    required this.label,
    required this.isLoading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        height: 40,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
            const SizedBox(width: 4),
            isLoading
                ? const SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(
                    Icons.keyboard_arrow_down,
                    color: MyColors.grey,
                  ),
          ],
        ),
      ),
    );
  }
}
