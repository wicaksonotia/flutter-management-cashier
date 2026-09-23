import 'package:cashier_management/controllers/employee_controller.dart';
import 'package:cashier_management/utils/background_form.dart';
import 'package:cashier_management/utils/colors.dart';
import 'package:cashier_management/utils/confirm_dialog.dart';
import 'package:cashier_management/utils/input_field.dart';
import 'package:cashier_management/utils/management_header_form.dart';
import 'package:cashier_management/utils/management_save_button.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class EmployeeForm extends StatelessWidget {
  EmployeeForm({super.key});

  final EmployeeController controller = Get.find<EmployeeController>();

  @override
  Widget build(BuildContext context) {
    final isEdit = controller.idKasir.value != 0;

    return Scaffold(
      backgroundColor: MyColors.background,
      body: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: BackgroundForm(
          headerTitle: isEdit ? 'Edit Karyawan' : 'Tambah Karyawan',
          container: _EmployeeFormBody(
            controller: controller,
            isEdit: isEdit,
          ),
        ),
      ),
    );
  }
}

class _EmployeeFormBody extends StatelessWidget {
  final EmployeeController controller;
  final bool isEdit;

  const _EmployeeFormBody({
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
            title: isEdit ? 'Edit Karyawan' : 'Karyawan Baru',
            subtitle: isEdit
                ? 'Perbarui informasi dan akses outlet'
                : 'Buat akun dan tentukan outlet kerja',
            icon: isEdit
                ? Icons.manage_accounts_rounded
                : Icons.person_add_alt_1_rounded,
          ),
          const Gap(18),
          _EmployeeFormCard(
            controller: controller,
            isEdit: isEdit,
          ),
        ],
      ),
    );
  }
}

class _EmployeeFormCard extends StatelessWidget {
  final EmployeeController controller;
  final bool isEdit;

  const _EmployeeFormCard({
    required this.controller,
    required this.isEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
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
          const _SectionTitle(
            title: 'Penempatan',
            subtitle: 'Pilih outlet yang dapat diakses karyawan',
          ),
          const Gap(18),

          // ==========================================================
          // BRAND
          // ==========================================================

          Obx(
            () => _BrandCard(
              brand: controller.selectedKios.value,
            ),
          ),

          const Gap(18),

          // ==========================================================
          // OUTLET LIST
          // ==========================================================

          Obx(() {
            if (controller.isLoadingCabang.value) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: CircularProgressIndicator(),
                ),
              );
            }

            return Column(
              children: controller.resultDataCabang.map((outlet) {
                final id = outlet.id ?? 0;

                final selected = controller.selectedOutletIds.contains(id);

                final isDefault =
                    controller.defaultOutletId.value == id && selected;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _OutletTile(
                    title: outlet.cabang ?? '-',
                    address: outlet.alamat ?? '',
                    selected: selected,
                    isDefault: isDefault,
                    onChanged: () => controller.toggleOutlet(id),
                    onSetDefault: () => controller.setDefaultOutlet(id),
                  ),
                );
              }).toList(),
            );
          }),

          const Gap(28),

          // ==========================================================
          // EMPLOYEE INFO
          // ==========================================================

          const _SectionTitle(
            title: 'Informasi Karyawan',
            subtitle: 'Lengkapi informasi akun dan data karyawan',
          ),

          const Gap(20),

          InputField(
            label: 'Username',
            icon: Icons.alternate_email_rounded,
            controller: controller.usernameController,
            hint: 'Masukkan username',
            helperText:
                'Contoh: himalaya.tia\nAwalan dapat diubah agar username tetap unik.',
          ),

          const Gap(16),

          InputField(
            label: 'Nama Lengkap',
            icon: Icons.person_outline_rounded,
            controller: controller.namaController,
            hint: 'Masukkan nama lengkap',
          ),

          const Gap(16),

          InputField(
            label: 'Nomor Telepon',
            icon: Icons.phone_outlined,
            controller: controller.noTelponController,
            keyboardType: TextInputType.phone,
            hint: 'Masukkan nomor telepon',
          ),

          const Gap(30),

          _SaveButton(
            controller: controller,
            isEdit: isEdit,
          ),
        ],
      ),
    );
  }
}

class _BrandCard extends StatelessWidget {
  final String brand;

  const _BrandCard({
    required this.brand,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: MyColors.background,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: MyColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: MyColors.primaryLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.storefront_outlined,
              color: MyColors.primary,
            ),
          ),
          const Gap(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Brand',
                  style: TextStyle(
                    fontSize: 11,
                    color: MyColors.textSecondary,
                  ),
                ),
                const Gap(2),
                Text(
                  brand,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: MyColors.textPrimary,
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

class _OutletTile extends StatelessWidget {
  final String title;
  final String address;
  final bool selected;
  final bool isDefault;
  final VoidCallback onChanged;
  final VoidCallback onSetDefault;

  const _OutletTile({
    required this.title,
    required this.address,
    required this.selected,
    required this.isDefault,
    required this.onChanged,
    required this.onSetDefault,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      decoration: BoxDecoration(
        color: selected ? MyColors.primaryLight : MyColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDefault
              ? MyColors.success
              : selected
                  ? MyColors.selectedBorder
                  : MyColors.border,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onChanged,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              GestureDetector(
                onTap: onChanged,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    color: selected ? MyColors.primary : Colors.transparent,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color:
                          selected ? MyColors.primary : MyColors.disabledText,
                    ),
                  ),
                  child: selected
                      ? const Icon(
                          Icons.check,
                          size: 15,
                          color: Colors.white,
                        )
                      : null,
                ),
              ),
              const Gap(14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: selected
                            ? MyColors.primaryDark
                            : MyColors.textPrimary,
                      ),
                    ),
                    // if (address.isNotEmpty) ...[
                    //   const Gap(3),
                    //   Text(
                    //     address,
                    //     style: const TextStyle(
                    //       fontSize: 11,
                    //       color: MyColors.textSecondary,
                    //     ),
                    //   ),
                    // ],
                  ],
                ),
              ),
              if (selected)
                isDefault
                    ? Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: MyColors.success,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.star_rounded,
                              size: 14,
                              color: Colors.white,
                            ),
                            SizedBox(width: 4),
                            Text(
                              'Default',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      )
                    : TextButton(
                        onPressed: onSetDefault,
                        style: TextButton.styleFrom(
                          foregroundColor: MyColors.primary,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                          ),
                        ),
                        child: const Text(
                          'Jadikan Default',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
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

class _SectionTitle extends StatelessWidget {
  final String title;
  final String subtitle;

  const _SectionTitle({
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: MyColors.textPrimary,
          ),
        ),
        const Gap(3),
        Text(
          subtitle,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: MyColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

class _SaveButton extends StatelessWidget {
  final EmployeeController controller;
  final bool isEdit;

  const _SaveButton({
    required this.controller,
    required this.isEdit,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EmployeeController>(
      builder: (_) {
        final isLoading = controller.isLoadingSaveEmployee.value;
        final canSave = controller.canSaveEmployee && !isLoading;

        return ManagementSaveButton(
          label: isEdit ? 'Update Karyawan' : 'Simpan Karyawan',
          isLoading: isLoading,
          onPressed: canSave ? () => _save(context) : null,
        );
      },
    );
  }

  Future<void> _save(BuildContext context) async {
    final result = await controller.saveEmployee();

    if (!context.mounted) return;

    switch (result['status']) {
      case 'ok':
        Navigator.of(context).pop(true);
        break;

      case 'username_exists':
        await AppConfirmDialog.show(
          context,
          title: 'Username Sudah Digunakan',
          message: result['message'],
          confirmText: 'Ubah Username',
          cancelText: 'Tutup',
          icon: Icons.info_outline_rounded,
          type: AppConfirmType.warning,
        );
        break;

      default:
        await AppConfirmDialog.show(
          context,
          title: 'Gagal Menyimpan',
          message: result['message'],
          confirmText: 'Tutup',
          cancelText: 'Batal',
          icon: Icons.error_outline_rounded,
          type: AppConfirmType.danger,
        );
    }
  }
}
