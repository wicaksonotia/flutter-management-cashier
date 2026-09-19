import 'package:cashier_management/controllers/base_controller.dart';
import 'package:cashier_management/database/api_request.dart';
import 'package:cashier_management/models/product_category_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductCategoryController extends BaseController {
  // ==========================================================
  // BRAND / KIOS AKTIF
  // ==========================================================

  /// Brand yang sedang aktif.
  ///
  /// Semua category dan product management mengikuti idKios ini.
  final idKios = 0.obs;

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
    DataProductCategory productCategoryModel,
  ) {
    idProductCategory.value = productCategoryModel.idCategories ?? 0;

    idKios.value = productCategoryModel.idKios ?? idKios.value;

    productCategoryNameController.text = productCategoryModel.name ?? '';

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

  Future<void> saveProductCategory() async {
    if (isLoadingSave.value) return;

    try {
      final name = productCategoryNameController.text.trim();

      if (name.isEmpty) {
        throw '* All fields are required';
      }

      if (idKios.value <= 0) {
        throw 'Brand belum dipilih.';
      }

      isLoadingSave.value = true;

      final rawFormat = {
        'id_categories': idProductCategory.value,
        'id_kios': idKios.value,
        'name': name,
      };

      final result = await RemoteDataSource.saveProductCategory(
        rawFormat,
      );

      if (!result) {
        throw 'Failed to save data';
      }

      Get.snackbar(
        'Notification',
        'Saved successfully',
        icon: const Icon(Icons.check),
        snackPosition: SnackPosition.TOP,
      );

      clearProductCategoryController();

      // Refresh category.
      //
      // Karena resultDataProductCategory adalah RxList,
      // Category Chips otomatis ikut berubah.
      await fetchDataListProductCategory();
    } catch (error) {
      Get.snackbar(
        'Notification',
        error.toString(),
        icon: const Icon(Icons.error),
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoadingSave.value = false;
    }
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
        throw 'Failed to update data';
      }

      final index = resultDataProductCategory.indexWhere(
        (item) => item.idCategories == id,
      );

      if (index != -1) {
        resultDataProductCategory[index].status = newStatus;

        resultDataProductCategory.refresh();
      }

      Get.snackbar(
        'Notification',
        'Status updated successfully',
        icon: const Icon(Icons.check),
        snackPosition: SnackPosition.TOP,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        icon: const Icon(Icons.error),
        snackPosition: SnackPosition.TOP,
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
