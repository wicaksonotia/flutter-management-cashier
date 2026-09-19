import 'package:cashier_management/controllers/product_controller.dart';
import 'package:cashier_management/pages/select_table_list_page.dart';
import 'package:cashier_management/utils/colors.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class AddProductPage extends StatelessWidget {
  const AddProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProductController>();

    return Scaffold(
      backgroundColor: MyColors.background,
      appBar: AppBar(
        backgroundColor: MyColors.background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Produk',
          style: TextStyle(
            color: MyColors.textPrimary,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(18, 8, 18, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _ProductFormHeader(),
              const SizedBox(height: 22),
              const _SectionTitle(
                icon: Icons.storefront_outlined,
                title: 'Penempatan',
              ),
              const SizedBox(height: 10),
              _SelectionField(
                label: 'Outlet',
                value: controller.selectedKios,
                icon: Icons.storefront_outlined,
                onTap: () {
                  Get.to(
                    () => SelectTableListPage(
                      title: 'Pilih Outlet',
                      isLoading: controller.isLoadingKios,
                      items: controller.resultDataKios,
                      titleBuilder: (data) => data.kios!,
                      subtitleBuilder: (data) => data.keterangan ?? '',
                      isSelected: (data) =>
                          data.idKios == controller.idKios.value,
                      onItemTap: (data) async {
                        controller.idKios.value = data.idKios!;
                        controller.selectedKios.value = data.kios!;

                        await controller.fetchDataListProductCategory();

                        Get.back();
                      },
                      onRefresh: () async {
                        await controller.fetchDataListKios();
                      },
                    ),
                    transition: Transition.rightToLeft,
                  );
                },
              ),
              const SizedBox(height: 10),
              _SelectionField(
                label: 'Kategori Produk',
                value: controller.nameProductCategory,
                icon: Icons.category_outlined,
                onTap: () {
                  Get.to(
                    () => SelectTableListPage(
                      title: 'Pilih Kategori',
                      isLoading: controller.isLoadingList,
                      items: controller.resultDataProductCategory,
                      titleBuilder: (data) => data.name!,
                      subtitleBuilder: (data) => '',
                      isSelected: (data) =>
                          data.idCategories ==
                          controller.idProductCategory.value,
                      onItemTap: (data) async {
                        controller.idProductCategory.value = data.idCategories!;
                        controller.nameProductCategory.value = data.name!;
                        Get.back();
                      },
                      onRefresh: () async {
                        await controller.fetchDataListProductCategory();
                      },
                    ),
                    transition: Transition.rightToLeft,
                  );
                },
              ),
              const SizedBox(height: 24),
              const _SectionTitle(
                icon: Icons.edit_note_rounded,
                title: 'Informasi Produk',
              ),
              const SizedBox(height: 10),
              _Input(
                controller: controller.productNameController,
                label: 'Nama produk',
                hint: 'Contoh: Kopi Susu',
                icon: Icons.local_cafe_outlined,
              ),
              const SizedBox(height: 10),
              _Input(
                controller: controller.productDescriptionController,
                label: 'Deskripsi',
                hint: 'Deskripsi singkat produk',
                icon: Icons.notes_outlined,
                maxLines: 3,
              ),
              const SizedBox(height: 10),
              _Input(
                controller: controller.productPriceController,
                label: 'Harga',
                hint: '0',
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
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton.icon(
                  onPressed: controller.saveProduct,
                  icon: const Icon(Icons.check_rounded),
                  label: const Text(
                    'Simpan Produk',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MyColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProductFormHeader extends StatelessWidget {
  const _ProductFormHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: MyColors.primary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Row(
        children: [
          Icon(
            Icons.inventory_2_rounded,
            color: Colors.white,
            size: 30,
          ),
          SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Data Produk',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Kelola informasi, kategori, dan harga produk.',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final IconData icon;
  final String title;

  const _SectionTitle({
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 17,
          color: MyColors.primary,
        ),
        const SizedBox(width: 7),
        Text(
          title,
          style: const TextStyle(
            color: MyColors.textPrimary,
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _Input extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final int maxLines;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;

  const _Input({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.maxLines = 1,
    this.keyboardType,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(
          icon,
          color: MyColors.primary,
        ),
        filled: true,
        fillColor: MyColors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: MyColors.primary,
            width: 1.3,
          ),
        ),
      ),
    );
  }
}

class _SelectionField extends StatelessWidget {
  final String label;
  final RxString value;
  final IconData icon;
  final VoidCallback onTap;

  const _SelectionField({
    required this.label,
    required this.value,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Material(
        color: MyColors.surface,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: MyColors.primary,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: const TextStyle(
                          color: MyColors.textSecondary,
                          fontSize: 10,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        value.value.isEmpty ? 'Belum dipilih' : value.value,
                        style: const TextStyle(
                          color: MyColors.textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: MyColors.textMuted,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
