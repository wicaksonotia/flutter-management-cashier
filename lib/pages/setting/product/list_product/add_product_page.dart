import 'package:cashier_management/controllers/product_controller.dart';
import 'package:cashier_management/pages/setting/product/list_product/choose_category_page.dart';
import 'package:cashier_management/pages/setting/product/list_product/choose_outlet_page.dart';
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
              showModalBottomSheet(
                context: context,
                constraints: const BoxConstraints(
                  minWidth: double.infinity,
                ),
                builder: (_) =>
                    ChooseOutletPage(controller: Get.find<ProductController>()),
                isScrollControlled: true,
                backgroundColor: Colors.white,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                ),
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
              showModalBottomSheet(
                context: context,
                constraints: const BoxConstraints(
                  minWidth: double.infinity,
                ),
                builder: (_) => ChooseCategoryPage(
                    controller: Get.find<ProductController>()),
                isScrollControlled: true,
                backgroundColor: Colors.white,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                ),
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
                      _productController.productCategoryName.value,
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
