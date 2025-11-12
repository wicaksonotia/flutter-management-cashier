import 'package:cashier_management/controllers/product_controller.dart';
import 'package:cashier_management/models/product_model.dart';
import 'package:cashier_management/pages/setting/product/list_product/choose_category_page.dart';
import 'package:cashier_management/pages/setting/product/list_product/choose_outlet_page.dart';
import 'package:cashier_management/routes.dart';
import 'package:cashier_management/utils/box_container.dart';
import 'package:cashier_management/utils/colors.dart';
import 'package:cashier_management/utils/confirm_dialog.dart';
import 'package:cashier_management/utils/currency.dart';
import 'package:cashier_management/utils/sizes.dart';
import 'package:flutter/material.dart';
import 'package:cashier_management/pages/navigation_drawer.dart'
    as custom_drawer;
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class ListProductPage extends StatefulWidget {
  const ListProductPage({super.key});

  @override
  State<ListProductPage> createState() => _ListProductPageState();
}

class _ListProductPageState extends State<ListProductPage>
    with SingleTickerProviderStateMixin {
  final ProductController _productController = Get.put(ProductController());

  @override
  void initState() {
    super.initState();
    _productController.fetchDataListKios(
      onAfterSuccess: () async =>
          _productController.fetchDataListProductCategory(
        onAfterSuccess: () async => _productController.fetchDataListProduct(),
      ),
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
              'Product',
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
              _productController.clearProductController();
              Get.toNamed(RouterClass.addproduct);
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
                      label: _productController.selectedKios.value,
                      isLoading: _productController.isLoadingKios.value,
                      onTap: () {
                        Get.to(
                          () => ChooseOutletPage(
                              controller: Get.find<ProductController>()),
                          transition: Transition.rightToLeft,
                          duration: const Duration(milliseconds: 300),
                        );
                      },
                    );
                  }),
                  const Gap(10),
                  // PRODUCT CATEGORY
                  Obx(() {
                    return DropdownTabButton(
                      label: _productController.productCategoryName.value,
                      isLoading: _productController.isLoadingList.value,
                      onTap: () {
                        Get.to(
                          () => ChooseCategoryPage(
                              controller: Get.find<ProductController>()),
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
              child: Obx(
                () {
                  if (_productController.isLoadingListProduct.value) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return Obx(() {
                      final items = _productController.resultDataProduct;
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
                                data.idProduct), // gunakan ID unik dari model
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            child: ReorderableDragStartListener(
                              index: index,
                              child: _buildAccountTile(
                                dataProduct: data,
                              ),
                            ),
                          );
                        },

                        // Fungsi dijalankan saat urutan berubah
                        onReorder: (oldIndex, newIndex) {
                          _productController.reorderProduct(oldIndex, newIndex);
                        },
                      );
                    });
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountTile({
    required DataProduct dataProduct,
  }) {
    return BoxContainer(
      shadow: true,
      child: Stack(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(left: 5, right: 5),
                width: 70,
                height: 80,
                child: Icon(
                  Icons.local_drink_outlined,
                  size: 45,
                  color: Colors.grey[350],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Text(
                            dataProduct.name!,
                            style: const TextStyle(
                              fontSize: MySizes.fontSizeMd,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Gap(10),
                          InkWell(
                            onTap: () {
                              // DIALOG CONFIRMATION ACTIVE OR INACTIVE
                              Get.bottomSheet(
                                ConfirmDialog(
                                    title: dataProduct.status == true
                                        ? 'Non-Activate Product'
                                        : 'Activate Product',
                                    message: dataProduct.status == true
                                        ? 'This product will be deactivated.\nAre you sure you want to continue?'
                                        : 'This product will be activated.\nAre you sure you want to continue?',
                                    onConfirm: () async {
                                      _productController.updateStatusProduct(
                                          dataProduct.idProduct!,
                                          !dataProduct.status!);
                                    }),
                                isScrollControlled: true,
                                backgroundColor: Colors.white,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(20)),
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: dataProduct.status!
                                    ? Colors.green[200]
                                    : Colors.red[200],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                dataProduct.status! ? 'Active' : 'Inactive',
                                style: const TextStyle(
                                    fontSize: MySizes.fontSizeXsm),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        dataProduct.description!,
                        style: const TextStyle(
                          fontSize: MySizes.fontSizeSm,
                          color: Colors.black54,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          productPrice(dataPrice: dataProduct.price!),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            bottom: -5,
            right: -5,
            child: InkWell(
              onTap: () {
                _productController.toggleFavorite(
                    dataProduct.idProduct!, !dataProduct.favorite!);
              },
              child: Container(
                alignment: Alignment.bottomRight,
                padding: const EdgeInsets.only(bottom: 10, right: 10),
                child: Icon(
                  dataProduct.favorite!
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: dataProduct.favorite! ? Colors.red : Colors.grey,
                  size: 20, // Set your desired width/height here
                ),
              ),
            ),
          ),
          Positioned(
            top: -5,
            right: -5,
            child: PopupMenuButton<String>(
              onSelected: (value) {
                if (value == "edit") {
                  _productController.editProduct(dataProduct);
                  Get.toNamed(RouterClass.addproduct);
                  return;
                }
                if (value == "delete") {
                  // can't delete product category, cause product category is in use
                  if (dataProduct.statusTransaksi == 1) {
                    Get.snackbar(
                      'Error',
                      'Cannot delete this product. This product has been used in transactions',
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
                        _productController
                            .deleteProduct(dataProduct.idProduct!);
                      },
                    ),
                    isScrollControlled: true,
                    backgroundColor: Colors.white,
                    shape: const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(20)),
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
        ],
      ),
    );
  }

  Widget productPrice({required int dataPrice}) {
    return Text.rich(
      TextSpan(
        children: [
          const TextSpan(
            text: 'Rp ',
            style: TextStyle(
              color: MyColors.primary,
              fontSize: MySizes.fontSizeMd,
            ),
          ),
          TextSpan(
            text: CurrencyFormat.convertToIdr(dataPrice, 0),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: MySizes.fontSizeLg,
              color: MyColors.primary,
            ),
          ),
        ],
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
                : Icon(
                    Icons.keyboard_arrow_down,
                    color: MyColors.grey,
                  ),
          ],
        ),
      ),
    );
  }
}
