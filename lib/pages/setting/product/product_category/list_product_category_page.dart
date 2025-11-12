import 'dart:ui';

import 'package:cashier_management/controllers/product_category_controller.dart';
import 'package:cashier_management/models/product_category_model.dart';
import 'package:cashier_management/routes.dart';
import 'package:cashier_management/utils/colors.dart';
import 'package:cashier_management/utils/confirm_dialog.dart';
import 'package:cashier_management/utils/sizes.dart';
import 'package:chips_choice/chips_choice.dart';
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
  bool isDropdownKiosOpen = false;
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<Offset> _slideAnimation;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 350),
      vsync: this,
    );
    _opacityAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -0.05),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    ));
    _productCategoryController.fetchDataListKios(
      onAfterSuccess: () async =>
          _productCategoryController.fetchDataListProductCategory(),
    );
  }

  void toggleDropdownKios() {
    setState(() {
      isDropdownKiosOpen = !isDropdownKiosOpen;
      if (isDropdownKiosOpen) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
        child: Stack(
          children: [
            Obx(
              () {
                if (_productCategoryController.isLoadingList.value) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return Padding(
                    padding: const EdgeInsets.only(top: 60),
                    child: Obx(() {
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
                            key: ValueKey(data
                                .idCategories), // gunakan ID unik dari model
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
                    }),
                  );
                }
              },
            ),

            /// --- BACKDROP BLUR (HANYA MENUTUP LIST) ---
            if (isDropdownKiosOpen)
              Positioned.fill(
                top: 60, // mulai blur setelah tombol lokasi
                child: GestureDetector(
                  onTap: toggleDropdownKios,
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                    child: Container(
                      color: Colors.black.withOpacity(0.2),
                    ),
                  ),
                ),
              ),

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
                      isOpen: isDropdownKiosOpen,
                      isLoading: _productCategoryController.isLoadingKios.value,
                      onTap: toggleDropdownKios,
                    );
                  }),
                ],
              ),
            ),

            /// --- DROPDOWN MENU ---
            _buildDropdownMenu(
              isOpen: isDropdownKiosOpen,
              opacityAnimation: _opacityAnimation,
              slideAnimation: _slideAnimation,
              source: _productCategoryController.listKios,
              selectedValue: _productCategoryController.idKios.value,
              onChanged: (val) {
                _productCategoryController.idKios.value = val;
                final selectedItem =
                    _productCategoryController.listKios.firstWhere(
                  (item) => item['value'] == val,
                  orElse: () => {},
                );
                if (selectedItem.isNotEmpty) {
                  _productCategoryController.selectedKios.value =
                      selectedItem['nama'];
                }
                _productCategoryController.fetchDataListProductCategory();
              },
              onClose: toggleDropdownKios,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountTile({
    required DataProductCategory dataProductCategory,
  }) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Stack(
        children: [
          Row(
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
                          _productCategoryController
                              .updateStatusProductCategory(
                                  dataProductCategory.idCategories!,
                                  !dataProductCategory.status!);
                        }),
                    isScrollControlled: true,
                    backgroundColor: Colors.white,
                    shape: const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                  );
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
          Positioned(
            top: -10,
            right: -10,
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

  Widget _buildDropdownMenu({
    required bool isOpen,
    required Animation<double> opacityAnimation,
    required Animation<Offset> slideAnimation,
    required List<Map<String, dynamic>> source,
    required int selectedValue,
    required ValueChanged<int> onChanged,
    required VoidCallback onClose,
  }) {
    return Positioned(
      top: 58,
      left: 0,
      right: 0,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        switchInCurve: Curves.easeOutBack,
        switchOutCurve: Curves.easeIn,
        child: isOpen
            ? FadeTransition(
                opacity: opacityAnimation,
                child: SlideTransition(
                  position: slideAnimation,
                  child: Container(
                    width: double.infinity,
                    key: const ValueKey("dropdown"),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 16,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    constraints: const BoxConstraints(maxHeight: 200),
                    padding: const EdgeInsets.fromLTRB(12, 20, 12, 20),
                    child: ChipsChoice.single(
                      wrapped: true,
                      padding: EdgeInsets.zero,
                      value: selectedValue,
                      onChanged: (val) {
                        onChanged(val);
                        onClose();
                      },
                      choiceItems: C2Choice.listFrom<int, Map<String, dynamic>>(
                        source: source,
                        value: (i, v) => v['value']!,
                        label: (i, v) => v['nama']!,
                      ),
                      choiceCheckmark: false,
                      choiceStyle: C2ChipStyle.filled(
                        borderRadius: BorderRadius.circular(25),
                        color: Colors.grey.shade100,
                        selectedStyle: const C2ChipStyle(
                          backgroundColor: MyColors.primary,
                          borderRadius: BorderRadius.all(Radius.circular(25)),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            : const SizedBox.shrink(),
      ),
    );
  }
}

class DropdownTabButton extends StatelessWidget {
  final String label;
  final bool isOpen;
  final bool isLoading;
  final VoidCallback onTap;

  const DropdownTabButton({
    super.key,
    required this.label,
    required this.isOpen,
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
        height: isOpen ? 50 : 40,
        decoration: BoxDecoration(
          color: isOpen ? Colors.white : Colors.grey.shade300,
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
                    isOpen
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: MyColors.grey,
                  ),
          ],
        ),
      ),
    );
  }
}
