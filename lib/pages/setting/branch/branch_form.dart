import 'package:cashier_management/controllers/cabang_controller.dart';
import 'package:cashier_management/controllers/kios_controller.dart';
import 'package:cashier_management/utils/background_form.dart';
import 'package:cashier_management/utils/colors.dart';
import 'package:cashier_management/utils/input_field.dart';
import 'package:cashier_management/utils/management_header_form.dart';
import 'package:cashier_management/utils/management_save_button.dart';
import 'package:cashier_management/utils/uppercase_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class BranchForm extends StatefulWidget {
  const BranchForm({super.key});

  @override
  State<BranchForm> createState() => _BranchFormState();
}

class _BranchFormState extends State<BranchForm> {
  late final CabangController _cabangController;
  late final KiosController _kiosController;

  bool _isFormValid = false;

  @override
  void initState() {
    super.initState();

    _cabangController = Get.isRegistered<CabangController>()
        ? Get.find<CabangController>()
        : Get.put(CabangController());

    _kiosController = Get.isRegistered<KiosController>()
        ? Get.find<KiosController>()
        : Get.put(KiosController());

    _cabangController.kodeCabang.addListener(_validateForm);
    _cabangController.namaCabang.addListener(_validateForm);
    _cabangController.alamatCabang.addListener(_validateForm);

    _validateForm();
  }

  @override
  void dispose() {
    _cabangController.kodeCabang.removeListener(_validateForm);
    _cabangController.namaCabang.removeListener(_validateForm);
    _cabangController.alamatCabang.removeListener(_validateForm);

    super.dispose();
  }

  // ================================================================
  // FORM VALIDATION
  // ================================================================

  void _validateForm() {
    final isValid = _cabangController.kodeCabang.text.trim().isNotEmpty &&
        _cabangController.namaCabang.text.trim().isNotEmpty &&
        _cabangController.alamatCabang.text.trim().isNotEmpty;

    if (_isFormValid != isValid) {
      setState(() {
        _isFormValid = isValid;
      });
    }
  }

  // ================================================================
  // BUILD
  // ================================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.background,
      body: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: BackgroundForm(
          headerTitle: 'Tambah Outlet',
          container: _buildPageContent(),
        ),
      ),
    );
  }

  // ================================================================
  // PAGE CONTENT
  // ================================================================

  Widget _buildPageContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        16,
        110,
        16,
        24,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ManagementHeaderForm(
            title: 'Informasi Outlet',
            subtitle: 'Tambahkan outlet baru untuk brand '
                '${_cabangController.headerNamaKios.value}',
            icon: Icons.storefront_outlined,
          ),
          const SizedBox(height: 14),
          _buildFormCard(),
        ],
      ),
    );
  }

  // ================================================================
  // FORM CARD
  // ================================================================

  Widget _buildFormCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: MyColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: MyColors.border,
        ),
        boxShadow: [
          BoxShadow(
            color: MyColors.textPrimary.withValues(
              alpha: .035,
            ),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(
            icon: Icons.store_outlined,
            title: 'Detail Outlet',
            subtitle: 'Lengkapi informasi outlet baru',
          ),
          const SizedBox(height: 16),
          _buildKodeCabangField(),
          const SizedBox(height: 13),
          _buildNamaCabangField(),
          const SizedBox(height: 13),
          _buildAlamatCabangField(),
          const SizedBox(height: 24),
          _buildSaveButton(),
        ],
      ),
    );
  }

  // ================================================================
  // KODE OUTLET
  // ================================================================

  Widget _buildKodeCabangField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InputField(
          controller: _cabangController.kodeCabang,
          label: 'Kode Outlet',
          hint: 'Contoh: STG',
          icon: Icons.tag_outlined,
          textCapitalization: TextCapitalization.characters,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9]')),
            LengthLimitingTextInputFormatter(5),
            UpperCaseTextFormatter(),
          ],
        ),
        const SizedBox(height: 6),
        const Padding(
          padding: EdgeInsets.only(left: 4),
          child: Text(
            'Digunakan sebagai identitas outlet pada nota '
            'dan laporan penjualan.',
            style: TextStyle(
              color: MyColors.textSecondary,
              fontSize: 10.5,
              fontWeight: FontWeight.w500,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }

  // ================================================================
  // NAMA OUTLET
  // ================================================================

  Widget _buildNamaCabangField() {
    return InputField(
      controller: _cabangController.namaCabang,
      label: 'Nama Outlet',
      hint: 'Masukkan nama outlet',
      icon: Icons.storefront_outlined,
    );
  }

  // ================================================================
  // ALAMAT OUTLET
  // ================================================================

  Widget _buildAlamatCabangField() {
    return InputField(
      controller: _cabangController.alamatCabang,
      label: 'Alamat',
      hint: 'Masukkan alamat outlet',
      icon: Icons.location_on_outlined,
      maxLines: 4,
    );
  }

  // ================================================================
  // SECTION TITLE
  // ================================================================

  Widget _buildSectionTitle({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: MyColors.primaryLight,
            borderRadius: BorderRadius.circular(11),
          ),
          child: Icon(
            icon,
            size: 20,
            color: MyColors.primary,
          ),
        ),
        const SizedBox(width: 11),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: MyColors.textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(
                  color: MyColors.textSecondary,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ================================================================
  // SAVE BUTTON
  // ================================================================

  Widget _buildSaveButton() {
    return Obx(
      () {
        final isSaving = _cabangController.isLoadingSave.value;

        return ManagementSaveButton(
          label: isSaving ? 'Menyimpan...' : 'Simpan Outlet',
          onPressed: !_isFormValid || isSaving ? null : _saveBranch,
        );
      },
    );
  }

  // ================================================================
  // SAVE
  // ================================================================

  Future<void> _saveBranch() async {
    final success = await _cabangController.saveBranch();

    if (!success) return;

    await _kiosController.fetchDataListKiosFinancial();

    Get.snackbar(
      'Berhasil',
      'Outlet berhasil disimpan.',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      icon: const Icon(
        Icons.check_circle_outline_rounded,
        color: Colors.white,
      ),
      duration: const Duration(seconds: 2),
    );

    if (mounted) {
      Navigator.pop(context);
    }
  }
}
