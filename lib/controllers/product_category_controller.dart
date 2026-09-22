import 'package:cashier_management/controllers/base_controller.dart';
import 'package:cashier_management/database/api_request.dart';
import 'package:cashier_management/models/product_category_model.dart';
import 'package:cashier_management/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductCategoryController extends BaseController {
  // ==========================================================
  // CATEGORY DATA
  // ==========================================================

  final resultDataProductCategory = <DataProductCategory>[].obs;

  final isLoadingList = false.obs;
  final isLoadingSave = false.obs;

  // ==========================================================
  // CATEGORY FORM
  // ==========================================================

  final productCategoryNameController = TextEditingController();

  /// ID kategori yang sedang diedit.
  final idProductCategory = 0.obs;

  final nameProductCategory = 'Category'.obs;

  @override
  void onInit() {
    super.onInit();

    productCategoryNameController.addListener(update);
  }

  // ==========================================================
  // BRAND
  // ==========================================================

  /// Dipanggil ketika user mengganti brand dari Change Brand.
  ///
  /// Setelah brand berubah:
  /// 1. idKios berubah
  /// 2. category di-refresh
  /// 3. product di-refresh oleh ProductController
  void setKios(int value) {
    if (value <= 0) return;

    idKios.value = value;
  }

  // ==========================================================
  // CATEGORY FORM
  // ==========================================================

  void clearProductCategoryController() {
    idProductCategory.value = 0;
    productCategoryNameController.clear();

    update();
  }

  void editProductCategory(
    DataProductCategory model,
  ) {
    // ==========================================================
    // CATEGORY
    // ==========================================================

    idProductCategory.value = model.idCategories ?? 0;

    productCategoryNameController.text = model.name ?? '';

    update();
  }

  // ==========================================================
  // FETCH CATEGORY
  // ==========================================================

  Future<void> fetchDataListProductCategory({
    Future<void> Function()? onAfterSuccess,
  }) async {
    if (idKios.value <= 0) {
      resultDataProductCategory.clear();
      return;
    }

    try {
      isLoadingList.value = true;

      final rawFormat = {
        'id_kios': idKios.value,
      };

      final result = await RemoteDataSource.getListProductCategory(
        rawFormat,
      );

      if (result != null) {
        resultDataProductCategory.assignAll(result);
      } else {
        resultDataProductCategory.clear();
      }

      // Jangan memilih kategori pertama.
      //
      // Default Product Management:
      // selectedProductCategoryId = 0
      // artinya SEMUA kategori.
      if (onAfterSuccess != null) {
        await onAfterSuccess();
      }
    } catch (e) {
      resultDataProductCategory.clear();

      Get.snackbar(
        'Gagal memuat kategori',
        e.toString(),
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoadingList.value = false;
    }
  }

  // ==========================================================
  // SAVE CATEGORY
  // ==========================================================

  Future<bool> saveProductCategory() async {
    if (isLoadingSave.value) return false;

    try {
      final name = productCategoryNameController.text.trim();

      if (name.isEmpty) {
        throw 'Nama kategori wajib diisi.';
      }

      isLoadingSave.value = true;

      final rawFormat = {
        'id_categories': idProductCategory.value,
        'id_kios': idKios.value,
        'name': name,
      };
      debugPrint('========== SAVE CATEGORY ==========');
      debugPrint(rawFormat.toString());
      final result = await RemoteDataSource.saveProductCategory(rawFormat);
      debugPrint('RESULT : $result');

      if (!result) {
        throw 'Gagal menyimpan kategori.';
      }

      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    } finally {
      isLoadingSave.value = false;
    }
  }

  bool get canSaveProductCategory {
    final nameValid = productCategoryNameController.text.trim().isNotEmpty;

    return nameValid;
  }

  // ==========================================================
  // REORDER
  // ==========================================================

  void reorderCategory(
    int oldIndex,
    int newIndex,
  ) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }

    final moved = resultDataProductCategory.removeAt(oldIndex);

    resultDataProductCategory.insert(
      newIndex,
      moved,
    );

    for (int i = 0; i < resultDataProductCategory.length; i++) {
      resultDataProductCategory[i].sorting = i + 1;
    }

    resultDataProductCategory.refresh();

    updateCategorySorting();
  }

  // ==========================================================
  // SAVE SORTING
  // ==========================================================

  Future<void> updateCategorySorting() async {
    final payload = resultDataProductCategory.map((item) {
      return {
        'id_categories': item.idCategories,
        'sorting': item.sorting,
      };
    }).toList();

    await RemoteDataSource.updateCategorySorting(
      payload,
    );
  }

  // ==========================================================
  // STATUS
  // ==========================================================

  Future<void> updateStatusProductCategory(
    int id,
    bool newStatus,
  ) async {
    try {
      final rawFormat = {
        'id': id,
        'status': newStatus,
      };

      final success = await RemoteDataSource.updateStatusProductCategory(
        rawFormat,
      );

      if (!success) {
        throw 'Gagal mengubah status kategori.';
      }

      final index = resultDataProductCategory.indexWhere(
        (item) => item.idCategories == id,
      );

      if (index != -1) {
        resultDataProductCategory[index].status = newStatus;
        resultDataProductCategory.refresh();
      }

      Get.snackbar(
        'Berhasil',
        newStatus
            ? 'Kategori berhasil diaktifkan.'
            : 'Kategori berhasil dinonaktifkan.',
        icon: const Icon(
          Icons.check_circle_outline_rounded,
          color: MyColors.success,
        ),
        snackPosition: SnackPosition.TOP,
        backgroundColor: MyColors.successBg,
        colorText: MyColors.success,
      );
    } catch (e) {
      Get.snackbar(
        'Gagal',
        e.toString(),
        icon: const Icon(
          Icons.error_outline_rounded,
          color: MyColors.error,
        ),
        snackPosition: SnackPosition.TOP,
        backgroundColor: MyColors.errorBg,
        colorText: MyColors.error,
      );
    }
  }

  // ==========================================================
  // DELETE
  // ==========================================================

  Future<void> deleteProductCategory(
    int id,
  ) async {
    try {
      final resultUpdate = await RemoteDataSource.deleteProductCategory(
        id,
      );

      if (!resultUpdate) {
        throw 'Failed to delete data';
      }

      Get.snackbar(
        'Notification',
        'Data deleted successfully',
        icon: const Icon(Icons.check),
        snackPosition: SnackPosition.TOP,
      );

      await fetchDataListProductCategory();
    } catch (e) {
      Get.snackbar(
        'Notification',
        e.toString(),
        icon: const Icon(Icons.error),
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  // ==========================================================
  // DISPOSE
  // ==========================================================

  @override
  void onClose() {
    productCategoryNameController.dispose();

    super.onClose();
  }
}
