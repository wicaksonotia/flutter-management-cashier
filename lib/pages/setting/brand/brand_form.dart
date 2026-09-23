import 'dart:io';

import 'package:cashier_management/controllers/kios_controller.dart';
import 'package:cashier_management/database/api_endpoints.dart';
import 'package:cashier_management/utils/background_form.dart';
import 'package:cashier_management/utils/colors.dart';
import 'package:cashier_management/utils/input_field.dart';
import 'package:cashier_management/utils/management_header_form.dart';
import 'package:cashier_management/utils/management_save_button.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class BrandForm extends StatefulWidget {
  const BrandForm({super.key});

  @override
  State<BrandForm> createState() => _BrandFormState();
}

class _BrandFormState extends State<BrandForm> {
  late final KiosController _kiosController;

  @override
  void initState() {
    super.initState();

    _kiosController = Get.isRegistered<KiosController>()
        ? Get.find<KiosController>()
        : Get.put(KiosController());

    _kiosController.kios.addListener(
      _onFormChanged,
    );

    _kiosController.phone.addListener(
      _onFormChanged,
    );

    _kiosController.description.addListener(
      _onFormChanged,
    );
  }

  @override
  void dispose() {
    _kiosController.kios.removeListener(
      _onFormChanged,
    );

    _kiosController.phone.removeListener(
      _onFormChanged,
    );

    _kiosController.description.removeListener(
      _onFormChanged,
    );

    super.dispose();
  }

  // ============================================================
  // FORM
  // ============================================================

  void _onFormChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  bool get _isFormValid {
    return _kiosController.kios.text.trim().isNotEmpty &&
        _kiosController.phone.text.trim().isNotEmpty &&
        _kiosController.description.text.trim().isNotEmpty;
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.background,
      body: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: BackgroundForm(
          headerTitle: 'Brand',
          container: _buildPageContent(),
        ),
      ),
    );
  }

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
          const ManagementHeaderForm(
            title: 'Informasi Brand',
            subtitle: 'Kelola informasi dan logo brand outlet',
            icon: Icons.storefront_outlined,
          ),
          const SizedBox(height: 14),
          _buildFormCard(),
        ],
      ),
    );
  }

  // ============================================================
  // FORM CARD
  // ============================================================

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
            color: MyColors.textPrimary.withValues(alpha: .035),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(
            icon: Icons.info_outline_rounded,
            title: 'Informasi Brand',
            subtitle: 'Lengkapi informasi utama brand',
          ),
          const SizedBox(height: 16),
          _buildBrandNameField(),
          const SizedBox(height: 13),
          _buildPhoneField(),
          const SizedBox(height: 13),
          _buildDescriptionField(),
          const SizedBox(height: 22),
          _buildSectionTitle(
            icon: Icons.image_outlined,
            title: 'Logo Brand',
            subtitle: 'Logo bersifat opsional',
          ),
          const SizedBox(height: 14),
          _buildLogoSection(),
          const SizedBox(height: 24),
          Obx(
            () => ManagementSaveButton(
              label: 'Simpan Brand',
              onPressed:
                  _isFormValid && !_kiosController.isLoadingSaveKios.value
                      ? _saveBrand
                      : null,
              isLoading: _kiosController.isLoadingSaveKios.value,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // INPUT
  // ============================================================

  Widget _buildBrandNameField() {
    return InputField(
      controller: _kiosController.kios,
      label: 'Nama Brand',
      hint: 'Masukkan nama brand',
      icon: Icons.storefront_outlined,
    );
  }

  Widget _buildPhoneField() {
    return InputField(
      controller: _kiosController.phone,
      label: 'Nomor Telepon',
      hint: 'Masukkan nomor telepon',
      icon: Icons.phone_outlined,
      keyboardType: TextInputType.phone,
    );
  }

  Widget _buildDescriptionField() {
    return InputField(
      controller: _kiosController.description,
      label: 'Deskripsi',
      hint: 'Masukkan deskripsi brand',
      icon: Icons.description_outlined,
      maxLines: 4,
    );
  }

  // ============================================================
  // SECTION TITLE
  // ============================================================

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

  // ============================================================
  // LOGO SECTION
  // ============================================================

  Widget _buildLogoSection() {
    return Obx(() {
      final file = _kiosController.pickedFile1.value;

      final logo = _kiosController.logo.value.trim();

      final hasLocalImage =
          file.path.isNotEmpty && File(file.path).existsSync();

      if (hasLocalImage) {
        return _buildLocalImage(file);
      }

      if (logo.isNotEmpty && !_kiosController.removeLogo.value) {
        return _buildServerImage(logo);
      }

      return _buildEmptyUpload();
    });
  }

  // ============================================================
  // EMPTY UPLOAD
  // ============================================================

  Widget _buildEmptyUpload() {
    return DottedBorder(
      options: const RectDottedBorderOptions(
        dashPattern: [5, 5],
        padding: EdgeInsets.zero,
        color: MyColors.selectedBorder,
        strokeWidth: 1.1,
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 16,
        ),
        decoration: BoxDecoration(
          color: MyColors.primaryLight.withValues(alpha: .35),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: MyColors.primaryLight,
                borderRadius: BorderRadius.circular(13),
              ),
              child: const Icon(
                Icons.cloud_upload_outlined,
                color: MyColors.primary,
                size: 23,
              ),
            ),
            const SizedBox(height: 9),
            const Text(
              'Upload Logo Brand',
              style: TextStyle(
                color: MyColors.textPrimary,
                fontSize: 12.5,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 3),
            const Text(
              'Opsional • Maksimal 2 MB',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: MyColors.textSecondary,
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 10),
            _buildUploadButton(
              label: 'Pilih Gambar',
              icon: Icons.image_outlined,
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // LOCAL IMAGE
  // ============================================================

  Widget _buildLocalImage(
    XFile file,
  ) {
    final imageFile = File(file.path);

    final fileSizeMB =
        (imageFile.lengthSync() / (1024 * 1024)).toStringAsFixed(2);

    return _buildImagePreviewCard(
      name: file.name,
      size: '$fileSizeMB MB',
      preview: Image.file(
        imageFile,
        width: 86,
        height: 86,
        fit: BoxFit.cover,
      ),
      showDelete: true,
      onDelete: _removeSelectedImage,
    );
  }

  // ============================================================
  // SERVER IMAGE
  // ============================================================

  Widget _buildServerImage(
    String logo,
  ) {
    return _buildImagePreviewCard(
      name: logo,
      preview: Image.network(
        '${ApiEndPoints.ipPublic}images/logo/$logo',
        width: 86,
        height: 86,
        fit: BoxFit.contain,
        errorBuilder: (
          context,
          error,
          stackTrace,
        ) {
          return Container(
            width: 86,
            height: 86,
            color: MyColors.surfaceSoft,
            child: const Icon(
              Icons.broken_image_outlined,
              color: MyColors.textMuted,
              size: 28,
            ),
          );
        },
      ),
      showDelete: true,
      onDelete: _removeServerLogo,
    );
  }

  // ============================================================
  // IMAGE PREVIEW CARD
  // ============================================================

  Widget _buildImagePreviewCard({
    required String name,
    required Widget preview,
    String? size,
    required bool showDelete,
    required VoidCallback onDelete,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: MyColors.surfaceSoft,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: MyColors.border,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 88,
            height: 88,
            padding: const EdgeInsets.all(1),
            decoration: BoxDecoration(
              color: MyColors.surface,
              borderRadius: BorderRadius.circular(13),
              border: Border.all(
                color: MyColors.border,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: preview,
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  size != null ? 'Logo baru' : 'Logo saat ini',
                  style: const TextStyle(
                    color: MyColors.textMuted,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: MyColors.textPrimary,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (size != null) ...[
                  const SizedBox(height: 3),
                  Text(
                    size,
                    style: const TextStyle(
                      color: MyColors.textSecondary,
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
                const SizedBox(height: 10),
                Wrap(
                  spacing: 7,
                  runSpacing: 7,
                  children: [
                    _buildUploadButton(
                      label: 'Ganti Logo',
                      icon: Icons.refresh_rounded,
                    ),
                    if (showDelete)
                      _buildDeleteButton(
                        onPressed: onDelete,
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // UPLOAD BUTTON
  // ============================================================

  Widget _buildUploadButton({
    required String label,
    required IconData icon,
  }) {
    return SizedBox(
      height: 36,
      child: OutlinedButton.icon(
        onPressed: _pickLogo,
        icon: Icon(
          icon,
          size: 17,
        ),
        label: Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
          ),
        ),
        style: OutlinedButton.styleFrom(
          foregroundColor: MyColors.primary,
          side: const BorderSide(
            color: MyColors.selectedBorder,
          ),
          backgroundColor: MyColors.surface,
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // DELETE BUTTON
  // ============================================================

  Widget _buildDeleteButton({
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      height: 36,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: const Icon(
          Icons.delete_outline_rounded,
          size: 17,
        ),
        label: const Text(
          'Hapus Logo',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
          ),
        ),
        style: OutlinedButton.styleFrom(
          foregroundColor: MyColors.error,
          side: BorderSide(
            color: MyColors.error.withValues(alpha: .35),
          ),
          backgroundColor: MyColors.errorBg,
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // PICK LOGO
  // ============================================================

  Future<void> _pickLogo() async {
    final success = await _kiosController.selectImage1(
      ImageSource.gallery,
    );

    if (!mounted) return;

    if (!success) {
      _showMessage(
        'Notifikasi',
        'Gambar tidak valid atau ukuran logo lebih dari 2 MB.',
        isError: true,
      );
    }
  }

  // ============================================================
  // REMOVE SELECTED IMAGE
  // ============================================================

  void _removeSelectedImage() {
    _kiosController.resetPickedLogo();

    if (mounted) {
      setState(() {});
    }
  }

  // ============================================================
  // REMOVE SERVER LOGO
  // ============================================================

  Future<void> _removeServerLogo() async {
    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'Hapus Logo?',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: MyColors.textPrimary,
            ),
          ),
          content: const Text(
            'Logo brand akan dihapus setelah perubahan disimpan.',
            style: TextStyle(
              fontSize: 13,
              height: 1.5,
              color: MyColors.textSecondary,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  false,
                );
              },
              child: const Text(
                'Batal',
                style: TextStyle(
                  color: MyColors.textSecondary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  true,
                );
              },
              style: FilledButton.styleFrom(
                backgroundColor: MyColors.error,
                foregroundColor: Colors.white,
              ),
              child: const Text(
                'Hapus',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;

    _kiosController.removeLogoImage();

    if (!mounted) return;

    setState(() {});
  }

  // ============================================================
  // SAVE
  // ============================================================

  Future<void> _saveBrand() async {
    if (!_isFormValid) {
      _showMessage(
        'Notifikasi',
        'Lengkapi nama brand, nomor telepon, dan deskripsi.',
        isError: true,
      );
      return;
    }

    final success = await _kiosController.saveOutlet();

    if (!mounted) return;

    if (!success) {
      _showMessage(
        'Gagal',
        'Brand gagal disimpan. Silakan coba lagi.',
        isError: true,
      );
      return;
    }

    Navigator.pop(context);
  }

  // ============================================================
  // LOCAL MESSAGE
  // ============================================================

  void _showMessage(
    String title,
    String message, {
    bool isError = false,
  }) {
    if (!mounted) return;

    final messenger = ScaffoldMessenger.of(context);

    messenger.hideCurrentSnackBar();

    messenger.showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.fromLTRB(
          16,
          0,
          16,
          16,
        ),
        elevation: 0,
        backgroundColor: isError ? MyColors.error : MyColors.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        content: Row(
          children: [
            Icon(
              isError
                  ? Icons.error_outline_rounded
                  : Icons.check_circle_outline_rounded,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
