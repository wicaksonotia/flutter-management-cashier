import 'package:cashier_management/controllers/product_controller.dart';
import 'package:cashier_management/pages/select_table_list_page.dart';
import 'package:cashier_management/utils/background_form.dart';
import 'package:cashier_management/utils/colors.dart';
import 'package:cashier_management/utils/input_field.dart';
import 'package:cashier_management/utils/management_header_form.dart';
import 'package:cashier_management/utils/management_save_button.dart';
import 'package:cashier_management/utils/management_selector_field.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class AddProductPage extends StatelessWidget {
  AddProductPage({super.key});

  final ProductController controller = Get.find<ProductController>();

  @override
  Widget build(BuildContext context) {
    final isEdit = controller.idProduct.value != 0;

    return Scaffold(
      backgroundColor: MyColors.background,
      body: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: BackgroundForm(
          headerTitle: isEdit ? "Edit Produk" : "Tambah Produk",
          container: _Body(
            controller: controller,
            isEdit: isEdit,
          ),
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  final ProductController controller;
  final bool isEdit;

  const _Body({
    required this.controller,
    required this.isEdit,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 110, 20, 30),
      child: Column(
        children: [
          ManagementHeaderForm(
            title: isEdit ? 'Edit Produk' : 'Produk Baru',
            subtitle: isEdit
                ? 'Perbarui informasi produk'
                : 'Tambahkan produk baru ke outlet',
            icon: Icons.inventory_2_outlined,
          ),
          const Gap(18),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: MyColors.surface,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: MyColors.textPrimary.withValues(alpha: .04),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Penempatan",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: MyColors.textPrimary,
                  ),
                ),
                const Text(
                  "Tentukan outlet dan kategori produk",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: MyColors.textSecondary,
                  ),
                ),
                const Gap(20),
                Obx(
                  () => SelectorField(
                    title: "Brand",
                    icon: Icons.storefront_outlined,
                    value: controller.selectedKios.value,
                    enabled: false,
                    onTap: () {},
                  ),
                ),
                const Gap(16),
                Obx(
                  () => SelectorField(
                    title: "Kategori",
                    icon: Icons.category_outlined,
                    value: controller.nameProductCategory.value,
                    onTap: () => _selectCategory(controller),
                  ),
                ),
                const Gap(28),
                const Text(
                  "Informasi Produk",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: MyColors.textPrimary,
                  ),
                ),
                const Text(
                  "Lengkapi informasi produk",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: MyColors.textSecondary,
                  ),
                ),
                const Gap(20),
                InputField(
                  controller: controller.productNameController,
                  label: "Nama Produk",
                  icon: Icons.local_cafe_outlined,
                ),
                const Gap(16),
                InputField(
                  controller: controller.productDescriptionController,
                  label: "Deskripsi",
                  icon: Icons.notes_outlined,
                ),
                const Gap(16),
                InputField(
                  controller: controller.productPriceController,
                  label: "Harga",
                  icon: Icons.payments_outlined,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    CurrencyTextInputFormatter.currency(
                      locale: 'id',
                      decimalDigits: 0,
                      symbol: 'Rp ',
                    ),
                  ],
                ),
                const Gap(30),
                _SaveButton(
                  controller: controller,
                  isEdit: isEdit,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _selectCategory(ProductController controller) {
    Get.to(
      () => SelectTableListPage(
        enableSearch: false,
        title: 'Pilih Kategori',
        isLoading: controller.isLoadingList,
        items: controller.resultDataProductCategory,
        titleBuilder: (data) => data.name ?? '-',
        subtitleBuilder: (data) => '',
        isSelected: (data) =>
            data.idCategories == controller.idProductCategory.value,
        onItemTap: (data) async {
          controller.idProductCategory.value = data.idCategories ?? 0;
          controller.nameProductCategory.value = data.name ?? '';
        },
        onRefresh: () async {
          await controller.fetchDataListProductCategory();
        },
      ),
      transition: Transition.rightToLeft,
    );
  }
}

class _SaveButton extends StatelessWidget {
  final ProductController controller;
  final bool isEdit;

  const _SaveButton({
    required this.controller,
    required this.isEdit,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: GetBuilder<ProductController>(
        builder: (_) {
          final canSave = controller.canSaveProduct &&
              !controller.isLoadingSaveProduct.value;

          return ManagementSaveButton(
            label: isEdit ? "Update Produk" : "Simpan Produk",
            isLoading: controller.isLoadingSaveProduct.value,
            onPressed: canSave
                ? () async {
                    final success = await controller.saveProduct();

                    if (!success || !context.mounted) {
                      return;
                    }

                    Navigator.of(context).pop(true);
                  }
                : null,
          );
        },
      ),
    );
  }
}
