import 'package:cashier_management/controllers/base_controller.dart';
import 'package:cashier_management/database/api_request.dart';
import 'package:cashier_management/models/product_category_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductCategoryController extends BaseController {
  var resultDataProductCategory = <DataProductCategory>[].obs;
  var isLoadingList = true.obs;
  var isLoadingSave = true.obs;
  TextEditingController productCategoryNameController = TextEditingController();
  var idProductCategory = 0.obs;
  var nameProductCategory = 'Category'.obs;

  void clearProductCategoryController() {
    idProductCategory.value = 0;
    productCategoryNameController.clear();
    update();
  }

  void editProductCategory(DataProductCategory productCategoryModel) {
    idProductCategory.value = productCategoryModel.idCategories!;
    idKios.value = productCategoryModel.idKios!;
    productCategoryNameController.text = productCategoryModel.name!;
    update();
  }

  Future<void> fetchDataListProductCategory({
    Future<void> Function()? onAfterSuccess,
  }) async {
    try {
      var rawFormat = {
        'id_kios': idKios.value,
      };
      var result = await RemoteDataSource.getListProductCategory(rawFormat);
      if (result == null || result.isEmpty) {
        resultDataProductCategory.clear();
        return;
      }
      resultDataProductCategory.assignAll(result);
      // ✅ Jalankan callback opsional (jika dikirim)
      if (onAfterSuccess != null) {
        await onAfterSuccess();
      }
    } finally {
      isLoadingList(false);
    }
  }

  Future<void> saveProductCategory() async {
    try {
      if (productCategoryNameController.text.isEmpty) {
        throw "* All fields are required";
      }
      var rawFormat = {
        "id_categories": idProductCategory.value,
        "id_kios": idKios.value,
        "name": productCategoryNameController.text,
      };
      bool result = await RemoteDataSource.saveProductCategory(rawFormat);
      if (result) {
        Get.snackbar(
          'Notification',
          'Saved successfully',
          icon: const Icon(Icons.check),
          snackPosition: SnackPosition.TOP,
        );
        productCategoryNameController.clear();
        fetchDataListProductCategory();
      } else {
        throw "Failed to save data";
      }
    } catch (error) {
      Get.snackbar(
        'Notification',
        error.toString(),
        icon: const Icon(Icons.error),
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoadingSave(false);
    }
  }

  /// Reorder di UI
  void reorderCategory(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) newIndex -= 1;
    final moved = resultDataProductCategory.removeAt(oldIndex);
    resultDataProductCategory.insert(newIndex, moved);

    // Update nilai sorting di lokal
    for (int i = 0; i < resultDataProductCategory.length; i++) {
      resultDataProductCategory[i].sorting = i + 1;
    }

    resultDataProductCategory.refresh();

    // Simpan ke server
    updateCategorySorting();
  }

  /// Kirim urutan baru ke server
  Future<void> updateCategorySorting() async {
    final payload = resultDataProductCategory.map((item) {
      return {
        "id_categories": item.idCategories,
        "sorting": item.sorting,
      };
    }).toList();

    await RemoteDataSource.updateCategorySorting(payload);
  }

  void updateStatusProductCategory(int id, bool status) async {
    var rawFormat = {'id': id, 'status': status};
    var resultUpdate =
        await RemoteDataSource.updateStatusProductCategory(rawFormat);
    if (resultUpdate) {
      Get.snackbar('Notification', 'Data updated successfully',
          icon: const Icon(Icons.check), snackPosition: SnackPosition.TOP);
      fetchDataListProductCategory();
    } else {
      Get.snackbar('Notification', 'Failed to update data',
          icon: const Icon(Icons.error), snackPosition: SnackPosition.TOP);
    }
  }

  void deleteProductCategory(int id) async {
    var resultUpdate = await RemoteDataSource.deleteProductCategory(id);
    if (resultUpdate) {
      Get.snackbar('Notification', 'Data deleted successfully',
          icon: const Icon(Icons.check), snackPosition: SnackPosition.TOP);
      fetchDataListProductCategory();
    } else {
      Get.snackbar('Notification', 'Failed to delete data',
          icon: const Icon(Icons.error), snackPosition: SnackPosition.TOP);
    }
  }
}
