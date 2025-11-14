import 'package:cashier_management/controllers/product_category_controller.dart';
import 'package:cashier_management/pages/select_table_list_page.dart';
import 'package:cashier_management/utils/background_form.dart';
import 'package:cashier_management/utils/colors.dart';
import 'package:cashier_management/utils/sizes.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class AddProductCategoryPage extends StatefulWidget {
  const AddProductCategoryPage({super.key});

  @override
  State<AddProductCategoryPage> createState() => _AddProductCategoryPageState();
}

class _AddProductCategoryPageState extends State<AddProductCategoryPage> {
  final ProductCategoryController _productCategoryController =
      Get.find<ProductCategoryController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.grey.shade50, // Set your desired background color here
        child: MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child: BackgroundForm(
              headerTitle: 'Product Category Form',
              container: containerPage(),
            )),
      ),
    );
  }

  Container containerPage() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 120, 20, 0),
      padding: const EdgeInsets.all(16),
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              Get.to(
                () => SelectTableListPage(
                  title: 'Outlet',
                  isLoading: _productCategoryController.isLoadingKios,
                  items: _productCategoryController.resultDataKios,
                  titleBuilder: (data) => data.kios!,
                  subtitleBuilder: (data) => data.keterangan ?? '',
                  isSelected: (data) =>
                      data.idKios == _productCategoryController.idKios.value,
                  onItemTap: (data) async {
                    _productCategoryController.idKios.value = data.idKios!;
                    _productCategoryController.selectedKios.value = data.kios!;
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
            child: InputDecorator(
              decoration: InputDecoration(
                labelText: 'Set Outlet',
                labelStyle: const TextStyle(
                  color: Colors.black54,
                ),
                border: const OutlineInputBorder(),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey.shade300,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 14,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Obx(
                    () => Text(
                      _productCategoryController.selectedKios.value,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: MyColors.primary,
                  ),
                ],
              ),
            ),
          ),
          const Gap(16),
          TextFormField(
            controller:
                _productCategoryController.productCategoryNameController,
            decoration: InputDecoration(
              labelText: 'Category Name',
              floatingLabelStyle: const TextStyle(
                color: MyColors.primary,
              ),
              hintText: 'Category Name',
              hintStyle: TextStyle(
                color: Colors.grey.shade300,
              ),
              border: const OutlineInputBorder(),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: BorderSide(
                  color: Colors.grey.shade300,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: const BorderSide(
                  color: MyColors.primary,
                ),
              ),
            ),
          ),
          const Gap(50),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                _productCategoryController.saveProductCategory();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: MyColors.primary,
                padding: const EdgeInsets.symmetric(
                  vertical: 15,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              child: const Text(
                'Simpan',
                style: TextStyle(
                  fontSize: MySizes.fontSizeMd,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
