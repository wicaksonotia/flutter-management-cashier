import 'package:cashier_management/controllers/product_controller.dart';
import 'package:cashier_management/utils/app_back_header.dart';
import 'package:cashier_management/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class AddProductCategoryPage extends StatelessWidget {
  const AddProductCategoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProductController>();

    return Scaffold(
      backgroundColor: MyColors.background,
      appBar: const AppBackHeader(
        title: 'Kategori',
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
                      isEdit: controller.idProductCategory.value != 0,
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
                    const SizedBox(height: 26),
                    const _SectionHeader(
                      title: 'Informasi Kategori',
                    ),
                    const SizedBox(height: 10),
                    _InputField(
                      controller: controller.productCategoryNameController,
                      label: 'Nama kategori',
                      hint: 'Contoh: Minuman, Makanan, Snack',
                      icon: Icons.category_outlined,
                      textInputAction: TextInputAction.done,
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
            Icons.category_outlined,
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
                isEdit ? 'Edit Kategori' : 'Tambah Kategori',
                style: const TextStyle(
                  color: MyColors.textPrimary,
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                isEdit
                    ? 'Perbarui informasi kategori'
                    : 'Tambahkan kategori produk baru',
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
// INPUT FIELD
// ====================================================================

class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final TextInputAction? textInputAction;

  const _InputField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.textInputAction,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      textInputAction: textInputAction,
      textCapitalization: TextCapitalization.characters,
      inputFormatters: [
        UpperCaseTextFormatter(),
      ],
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

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return newValue.copyWith(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
      composing: TextRange.empty,
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
            final canSave = controller.canSaveProductCategory &&
                !controller.isLoadingSave.value;

            return ElevatedButton(
              onPressed: canSave
                  ? () async {
                      final success = await controller.saveProductCategory();

                      if (!context.mounted) return;

                      if (!success) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Gagal menyimpan kategori'),
                          ),
                        );
                        return;
                      }

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            controller.idProductCategory.value == 0
                                ? 'Kategori berhasil ditambahkan'
                                : 'Kategori berhasil diperbarui',
                          ),
                          backgroundColor: Colors.green,
                        ),
                      );

                      Navigator.pop(context, true);
                    }
                  : null,
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
              child: controller.isLoadingSave.value
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
                          'Simpan Kategori',
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
