import 'package:cashier_management/controllers/employee_controller.dart';
import 'package:cashier_management/pages/select_table_list_page.dart';
import 'package:cashier_management/utils/background_form.dart';
import 'package:cashier_management/utils/colors.dart';
import 'package:cashier_management/utils/input_field.dart';
import 'package:cashier_management/utils/management_header_form.dart';
import 'package:cashier_management/utils/management_save_button.dart';
import 'package:cashier_management/utils/management_selector_field.dart';
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
      padding: const EdgeInsets.fromLTRB(
        20,
        110,
        20,
        30,
      ),
      child: Column(
        children: [
          ManagementHeaderForm(
            title: isEdit ? 'Edit Karyawan' : 'Karyawan Baru',
            subtitle: isEdit
                ? 'Perbarui informasi dan penempatan karyawan'
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
            subtitle: 'Tentukan outlet kerja karyawan',
          ),
          const Gap(20),
          _brandField(controller: controller),
          Obx(
            () => SelectorField(
              title: 'Outlet',
              icon: Icons.location_on_outlined,
              value: controller.selectedCabang.value,
              onTap: () => _selectOutlet(),
            ),
          ),
          const Gap(28),
          const _SectionTitle(
            title: 'Informasi Karyawan',
            subtitle: 'Lengkapi informasi akun dan data karyawan',
          ),
          const Gap(20),
          InputField(
            label: 'Username',
            icon: Icons.alternate_email_rounded,
            controller: controller.usernameController,
            hint: 'Username untuk login',
            helperText:
                'Contoh: himalaya.tia \nAwalan dapat diubah, untuk menghindari username sama',
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

  Widget _brandField({
    required EmployeeController controller,
  }) {
    return Column(
      children: [
        Obx(
          () => SelectorField(
            title: 'Brand',
            icon: Icons.storefront_outlined,
            value: controller.selectedKios.value,
            enabled: false,
            onTap: () {},
          ),
        ),
        const Gap(16),
      ],
    );
  }

  void _selectOutlet() {
    Get.to(
      () => SelectTableListPage(
        title: 'Outlet',
        isLoading: controller.isLoadingCabang,
        items: controller.resultDataCabang,
        titleBuilder: (e) => e.cabang!,
        subtitleBuilder: (e) => e.alamat ?? '',
        isSelected: (e) => e.id == controller.idCabang.value,
        onItemTap: (e) async {
          controller.idCabang.value = e.id!;
          controller.selectedCabang.value = e.cabang!;
          controller.update();
        },
        onRefresh: () => controller.fetchDataListCabang(),
      ),
      transition: Transition.rightToLeft,
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

    if (!context.mounted) {
      return;
    }

    switch (result['status']) {
      case 'ok':
        Navigator.of(context).pop(true);
        break;

      case 'username_exists':
        _showUsernameExistsDialog(
          context,
          result['message'] ?? 'Username sudah digunakan oleh karyawan lain.',
        );
        break;

      default:
        _showErrorDialog(
          context,
          result['message'] ?? 'Gagal menyimpan data.',
        );
        break;
    }
  }

  void _showUsernameExistsDialog(
    BuildContext context,
    String message,
  ) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          titlePadding: const EdgeInsets.fromLTRB(
            24,
            24,
            24,
            8,
          ),
          contentPadding: const EdgeInsets.fromLTRB(
            24,
            8,
            24,
            20,
          ),
          actionsPadding: const EdgeInsets.fromLTRB(
            20,
            0,
            20,
            18,
          ),
          title: const Row(
            children: [
              Icon(
                Icons.info_outline_rounded,
                color: MyColors.warning,
                size: 24,
              ),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Username Sudah Digunakan',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: MyColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          content: Text(
            message,
            style: const TextStyle(
              fontSize: 13,
              height: 1.4,
              color: MyColors.textSecondary,
            ),
          ),
          actions: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                },
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: MyColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    vertical: 13,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Ubah Username',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(
    BuildContext context,
    String message,
  ) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          titlePadding: const EdgeInsets.fromLTRB(
            24,
            24,
            24,
            8,
          ),
          contentPadding: const EdgeInsets.fromLTRB(
            24,
            8,
            24,
            20,
          ),
          actionsPadding: const EdgeInsets.fromLTRB(
            20,
            0,
            20,
            18,
          ),
          title: const Row(
            children: [
              Icon(
                Icons.error_outline_rounded,
                color: MyColors.error,
                size: 24,
              ),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Gagal Menyimpan',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: MyColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          content: Text(
            message,
            style: const TextStyle(
              fontSize: 13,
              height: 1.4,
              color: MyColors.textSecondary,
            ),
          ),
          actions: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                },
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: MyColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    vertical: 13,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Tutup',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
