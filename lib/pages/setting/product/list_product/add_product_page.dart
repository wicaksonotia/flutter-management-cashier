import 'package:cashier_management/controllers/product_controller.dart';
import 'package:cashier_management/pages/select_table_list_page.dart';
import 'package:cashier_management/utils/background_form.dart';
import 'package:cashier_management/utils/colors.dart';
import 'package:cashier_management/utils/sizes.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final ProductController _productController = Get.find<ProductController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.grey.shade50, // Set your desired background color here
        child: MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child: BackgroundForm(
              headerTitle: 'Product Form',
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
                  isLoading: _productController.isLoadingKios,
                  items: _productController.resultDataKios,
                  titleBuilder: (data) => data.kios!,
                  subtitleBuilder: (data) => data.keterangan ?? '',
                  isSelected: (data) =>
                      data.idKios == _productController.idKios.value,
                  onItemTap: (data) async {
                    _productController.idKios.value = data.idKios!;
                    _productController.selectedKios.value = data.kios!;
                    await _productController.fetchDataListProductCategory(
                      onAfterSuccess: () async =>
                          _productController.fetchDataListProduct(),
                    );
                    Get.back();
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
                      _productController.selectedKios.value,
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
          InkWell(
            onTap: () {
              Get.to(
                () => SelectTableListPage(
                  title: 'Product Category',
                  isLoading: _productController.isLoadingList,
                  items: _productController.resultDataProductCategory,
                  titleBuilder: (data) => data.name!,
                  subtitleBuilder: (data) => '',
                  isSelected: (data) =>
                      data.idCategories ==
                      _productController.idProductCategory.value,
                  onItemTap: (data) async {
                    _productController.idProductCategory.value =
                        data.idCategories!;
                    _productController.nameProductCategory.value = data.name!;
                    Get.back();
                  },
                ),
                transition: Transition.rightToLeft,
                duration: const Duration(milliseconds: 300),
              );
            },
            child: InputDecorator(
              decoration: InputDecoration(
                labelText: 'Set Product Category',
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
                      _productController.nameProductCategory.value,
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
            controller: _productController.productNameController,
            decoration: InputDecoration(
              labelText: 'Product Name',
              floatingLabelStyle: const TextStyle(
                color: MyColors.primary,
              ),
              hintText: 'Product Name',
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
          const Gap(16),
          TextFormField(
            controller: _productController.productDescriptionController,
            maxLines: 3,
            decoration: InputDecoration(
              labelText: 'Description',
              floatingLabelStyle: const TextStyle(
                color: MyColors.primary,
              ),
              hintText: 'Description',
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
          const Gap(16),
          TextFormField(
            controller: _productController.productPriceController,
            inputFormatters: [
              CurrencyTextInputFormatter.currency(
                locale: 'id',
                decimalDigits: 0,
                symbol: 'Rp.',
              )
            ],
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Amount',
              floatingLabelStyle: const TextStyle(
                color: MyColors.primary,
              ),
              hintText: 'Amount',
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
                _productController.saveProduct();
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
