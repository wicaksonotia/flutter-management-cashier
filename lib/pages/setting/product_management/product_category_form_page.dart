import 'package:cashier_management/controllers/product_category_controller.dart';
import 'package:cashier_management/pages/select_table_list_page.dart';
import 'package:cashier_management/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddProductCategoryPage extends StatelessWidget {
  const AddProductCategoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProductCategoryController>();

    return Scaffold(
      backgroundColor: MyColors.background,
      appBar: AppBar(
        backgroundColor: MyColors.background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: Obx(
          () => Text(
            controller.idProductCategory.value == 0
                ? 'Tambah Kategori'
                : 'Edit Kategori',
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              color: MyColors.textPrimary,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(18, 8, 18, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _FormIntro(),
              const SizedBox(height: 22),
              const _SectionLabel(
                icon: Icons.storefront_outlined,
                title: 'Outlet',
              ),
              const SizedBox(height: 9),
              _SelectionField(
                value: controller.selectedKios,
                label: 'Pilih outlet',
                icon: Icons.storefront_outlined,
                onTap: () {
                  Get.to(
                    () => SelectTableListPage(
                      enableSearch: false,
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
              const SizedBox(height: 24),
              const _SectionLabel(
                icon: Icons.category_outlined,
                title: 'Informasi Kategori',
              ),
              const SizedBox(height: 9),
              TextField(
                controller: controller.productCategoryNameController,
                textInputAction: TextInputAction.done,
                decoration: _inputDecoration(
                  label: 'Nama kategori',
                  hint: 'Contoh: Minuman, Makanan, Snack',
                  icon: Icons.category_outlined,
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton.icon(
                  onPressed: controller.saveProductCategory,
                  icon: const Icon(Icons.check_rounded),
                  label: const Text(
                    'Simpan Kategori',
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

  InputDecoration _inputDecoration({
    required String label,
    required String hint,
    required IconData icon,
  }) {
    return InputDecoration(
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
    );
  }
}

class _FormIntro extends StatelessWidget {
  const _FormIntro();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: MyColors.primary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Row(
        children: [
          Icon(
            Icons.category_rounded,
            color: Colors.white,
            size: 30,
          ),
          SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Kategori Produk',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Kelompokkan produk agar katalog lebih rapi.',
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

class _SectionLabel extends StatelessWidget {
  final IconData icon;
  final String title;

  const _SectionLabel({
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

class _SelectionField extends StatelessWidget {
  final RxString value;
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _SelectionField({
    required this.value,
    required this.label,
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
