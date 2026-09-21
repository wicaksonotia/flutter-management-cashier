import 'package:cashier_management/controllers/product_controller.dart';
import 'package:cashier_management/pages/select_table_list_page.dart';
import 'package:cashier_management/utils/app_back_header.dart';
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
      appBar: const AppBackHeader(
        title: 'Produk',
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _PageIntro(
                      isEdit: controller.idProduct.value != 0,
                    ),
                    const SizedBox(height: 26),
                    const _SectionHeader(
                      title: 'Penempatan',
                    ),
                    const SizedBox(height: 10),
                    Obx(
                      () => _InfoField(
                        label: 'Outlet',
                        value: controller.selectedKios.value,
                        icon: Icons.storefront_outlined,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _SelectionField(
                      label: 'Kategori',
                      value: controller.nameProductCategory,
                      icon: Icons.category_outlined,
                      onTap: () => _showCategorySelector(controller),
                    ),
                    const SizedBox(height: 26),
                    const _SectionHeader(
                      title: 'Informasi Produk',
                    ),
                    const SizedBox(height: 10),
                    _InputField(
                      controller: controller.productNameController,
                      label: 'Nama produk',
                      hint: 'Contoh: Kopi Susu',
                      icon: Icons.local_cafe_outlined,
                    ),
                    const SizedBox(height: 10),
                    _InputField(
                      controller: controller.productDescriptionController,
                      label: 'Deskripsi',
                      hint: 'Deskripsi singkat produk',
                      icon: Icons.notes_outlined,
                      maxLines: 3,
                    ),
                    const SizedBox(height: 10),
                    _InputField(
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
                  ],
                ),
              ),
            ),
            _SaveButton(
              controller: controller,
            ),
          ],
        ),
      ),
    );
  }

  // ================================================================
  // CATEGORY SELECTOR
  // ================================================================

  void _showCategorySelector(ProductController controller) {
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

          controller.update();
        },
        onRefresh: () async {
          await controller.fetchDataListProductCategory();
        },
      ),
      transition: Transition.rightToLeft,
    );
  }
}

// ====================================================================
// PAGE INTRO
// ====================================================================

class _PageIntro extends StatelessWidget {
  final bool isEdit;

  const _PageIntro({
    required this.isEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: MyColors.primary.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.inventory_2_outlined,
            color: MyColors.primary,
            size: 21,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isEdit ? 'Edit Produk' : 'Tambah Produk',
                style: const TextStyle(
                  color: MyColors.textPrimary,
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                isEdit ? 'Perbarui informasi produk' : 'Tambahkan produk baru',
                style: const TextStyle(
                  color: MyColors.textSecondary,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ====================================================================
// SECTION HEADER
// ====================================================================

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        color: MyColors.textPrimary,
        fontSize: 13,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

// ====================================================================
// INFO FIELD
// ====================================================================

class _InfoField extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _InfoField({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final hasValue = value.trim().isNotEmpty;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 13,
      ),
      decoration: BoxDecoration(
        color: MyColors.surface.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(13),
        border: Border.all(
          color: Colors.black.withValues(alpha: 0.04),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.035),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              size: 19,
              color: MyColors.textSecondary,
            ),
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
                  hasValue ? value : '-',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: MyColors.textPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.lock_outline_rounded,
            color: MyColors.textMuted,
            size: 16,
          ),
        ],
      ),
    );
  }
}

// ====================================================================
// SELECTION FIELD
// ====================================================================

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
      () {
        final hasValue = value.value.trim().isNotEmpty;

        return Material(
          color: MyColors.surface,
          borderRadius: BorderRadius.circular(13),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(13),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 13,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(13),
                border: Border.all(
                  color: Colors.black.withValues(alpha: 0.05),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: MyColors.primary.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      icon,
                      size: 19,
                      color: MyColors.primary,
                    ),
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
                          hasValue ? value.value : 'Belum dipilih',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: hasValue
                                ? MyColors.textPrimary
                                : MyColors.textMuted,
                            fontSize: 13,
                            fontWeight:
                                hasValue ? FontWeight.w600 : FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: MyColors.textMuted,
                    size: 21,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// ====================================================================
// INPUT FIELD
// ====================================================================

class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final int maxLines;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;

  const _InputField({
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
      style: const TextStyle(
        color: MyColors.textPrimary,
        fontSize: 13,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle: const TextStyle(
          color: MyColors.textSecondary,
          fontSize: 12,
        ),
        hintStyle: const TextStyle(
          color: MyColors.textMuted,
          fontSize: 12,
        ),
        prefixIcon: Icon(
          icon,
          color: MyColors.primary,
          size: 20,
        ),
        filled: true,
        fillColor: MyColors.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
          borderSide: BorderSide(
            color: Colors.black.withValues(alpha: 0.05),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
          borderSide: BorderSide(
            color: Colors.black.withValues(alpha: 0.05),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
          borderSide: const BorderSide(
            color: MyColors.primary,
            width: 1.2,
          ),
        ),
      ),
    );
  }
}

// ====================================================================
// SAVE BUTTON
// ====================================================================

class _SaveButton extends StatelessWidget {
  final ProductController controller;

  const _SaveButton({
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 10, 18, 18),
      decoration: BoxDecoration(
        color: MyColors.background,
        border: Border(
          top: BorderSide(
            color: Colors.black.withValues(alpha: 0.05),
          ),
        ),
      ),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: GetBuilder<ProductController>(
          builder: (controller) {
            final canSave = controller.canSaveProduct &&
                !controller.isLoadingSaveProduct.value;

            return ElevatedButton(
              onPressed: canSave ? controller.saveProduct : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: MyColors.primary,
                disabledBackgroundColor:
                    MyColors.primary.withValues(alpha: 0.25),
                foregroundColor: Colors.white,
                disabledForegroundColor: Colors.white.withValues(alpha: 0.7),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13),
                ),
              ),
              child: controller.isLoadingSaveProduct.value
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.check_rounded,
                          size: 19,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Simpan Produk',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
            );
          },
        ),
      ),
    );
  }
}
