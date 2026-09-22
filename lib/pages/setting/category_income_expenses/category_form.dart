import 'package:cashier_management/controllers/category_controller.dart';
import 'package:cashier_management/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoryForm extends StatefulWidget {
  const CategoryForm({
    super.key,
  });

  @override
  State<CategoryForm> createState() => _CategoryFormState();
}

class _CategoryFormState extends State<CategoryForm> {
  late final CategoryController controller;

  @override
  void initState() {
    super.initState();

    controller = Get.find<CategoryController>();

    controller.nameController.addListener(_onFormChanged);
  }

  @override
  void dispose() {
    controller.nameController.removeListener(_onFormChanged);
    super.dispose();
  }

  void _onFormChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  bool get isEdit => controller.idCategoryTransaction.value != 0;

  bool get canSave =>
      controller.nameController.text.trim().isNotEmpty &&
      !controller.isLoadingSaveCategory.value;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // =========================================================
          // HEADER
          // =========================================================

          _buildHeader(),

          const SizedBox(height: 24),

          // =========================================================
          // TYPE
          // =========================================================

          _buildSectionTitle(
            'Jenis Kategori',
            'Tentukan kategori ini untuk pemasukan atau pengeluaran.',
          ),

          const SizedBox(height: 12),

          _buildTypeSelector(),

          const SizedBox(height: 24),

          // =========================================================
          // CATEGORY NAME
          // =========================================================

          _buildSectionTitle(
            'Informasi Kategori',
            'Masukkan nama kategori transaksi.',
          ),

          const SizedBox(height: 12),

          _buildNameField(),

          const SizedBox(height: 28),

          // =========================================================
          // SAVE
          // =========================================================

          _buildSaveButton(),
        ],
      );
    });
  }

  // ===============================================================
  // HEADER
  // ===============================================================

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isEdit ? 'Edit Kategori' : 'Tambah Kategori',
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: MyColors.textPrimary,
            letterSpacing: -.4,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          isEdit
              ? 'Perbarui informasi kategori transaksi.'
              : 'Tambahkan kategori untuk membantu mengelompokkan transaksi.',
          style: const TextStyle(
            fontSize: 13,
            height: 1.45,
            color: MyColors.textSecondary,
          ),
        ),
      ],
    );
  }

  // ===============================================================
  // SECTION TITLE
  // ===============================================================

  Widget _buildSectionTitle(
    String title,
    String subtitle,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: MyColors.textPrimary,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          subtitle,
          style: const TextStyle(
            fontSize: 11.5,
            height: 1.4,
            color: MyColors.textSecondary,
          ),
        ),
      ],
    );
  }

  // ===============================================================
  // TYPE SELECTOR
  // ===============================================================

  Widget _buildTypeSelector() {
    final isIncome = controller.isPemasukan.value;

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: MyColors.surfaceSoft,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: MyColors.border,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: _TypeOption(
              label: 'Pemasukan',
              icon: Icons.south_west_rounded,
              selected: isIncome,
              color: MyColors.primary,
              onTap: () {
                controller.isPemasukan.value = true;
              },
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: _TypeOption(
              label: 'Pengeluaran',
              icon: Icons.north_east_rounded,
              selected: !isIncome,
              color: MyColors.error,
              onTap: () {
                controller.isPemasukan.value = false;
              },
            ),
          ),
        ],
      ),
    );
  }

  // ===============================================================
  // NAME FIELD
  // ===============================================================

  Widget _buildNameField() {
    return TextFormField(
      controller: controller.nameController,
      textCapitalization: TextCapitalization.characters,
      autocorrect: false,
      textInputAction: TextInputAction.done,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: MyColors.textPrimary,
      ),
      decoration: InputDecoration(
        hintText: 'Contoh: MAKANAN, GAJI, TRANSPORTASI',
        hintStyle: const TextStyle(
          fontSize: 12,
          color: MyColors.textMuted,
          fontWeight: FontWeight.w400,
        ),
        prefixIcon: const Icon(
          Icons.category_outlined,
          size: 20,
          color: MyColors.textSecondary,
        ),
        filled: true,
        fillColor: MyColors.surfaceSoft,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 15,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
          borderSide: const BorderSide(
            color: MyColors.border,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
          borderSide: const BorderSide(
            color: MyColors.border,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
          borderSide: const BorderSide(
            color: MyColors.primary,
            width: 1.4,
          ),
        ),
      ),
      onChanged: (value) {
        final upper = value.toUpperCase();

        if (value != upper) {
          controller.nameController.value = TextEditingValue(
            text: upper,
            selection: TextSelection.collapsed(
              offset: upper.length,
            ),
          );
        }

        setState(() {});
      },
      onFieldSubmitted: (_) {
        if (canSave) {
          _save();
        }
      },
    );
  }

  // ===============================================================
  // SAVE BUTTON
  // ===============================================================

  Widget _buildSaveButton() {
    final loading = controller.isLoadingSaveCategory.value;

    return SizedBox(
      width: double.infinity,
      height: 50,
      child: FilledButton(
        onPressed: canSave ? _save : null,
        style: FilledButton.styleFrom(
          backgroundColor: MyColors.primary,
          disabledBackgroundColor: MyColors.border,
          foregroundColor: Colors.white,
          disabledForegroundColor: MyColors.textMuted,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(13),
          ),
        ),
        child: loading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Text(
                isEdit ? 'Simpan Perubahan' : 'Tambah Kategori',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
      ),
    );
  }

  // ===============================================================
  // SAVE
  // ===============================================================

  Future<void> _save() async {
    FocusScope.of(context).unfocus();

    final name = controller.nameController.text.trim();

    if (name.isEmpty) {
      Get.snackbar(
        'Kategori belum lengkap',
        'Nama kategori wajib diisi.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: MyColors.errorBg,
        colorText: MyColors.error,
        icon: const Icon(
          Icons.error_outline_rounded,
          color: MyColors.error,
        ),
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );

      return;
    }

    final isEdit = controller.idCategoryTransaction.value != 0;

    final success = await controller.saveCategory();

    if (!mounted) return;

    if (success) {
      Navigator.of(context).pop();

      Get.snackbar(
        'Berhasil',
        isEdit
            ? 'Kategori berhasil diperbarui.'
            : 'Kategori berhasil ditambahkan.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: MyColors.successBg,
        colorText: MyColors.success,
        icon: const Icon(
          Icons.check_circle_outline_rounded,
          color: MyColors.success,
        ),
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    }
  }
}

// ===================================================================
// TYPE OPTION
// ===================================================================

class _TypeOption extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final Color color;
  final VoidCallback onTap;

  const _TypeOption({
    required this.label,
    required this.icon,
    required this.selected,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final backgroundColor =
        selected ? color.withValues(alpha: .10) : Colors.transparent;

    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          height: 48,
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: selected
                ? Border.all(
                    color: color.withValues(alpha: .20),
                  )
                : Border.all(
                    color: Colors.transparent,
                  ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 18,
                color: selected ? color : MyColors.textMuted,
              ),
              const SizedBox(width: 7),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  color: selected ? color : MyColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
