import 'package:cashier_management/controllers/product_category_controller.dart';
import 'package:cashier_management/database/api_request.dart';
import 'package:cashier_management/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ProductController extends ProductCategoryController {
  var resultDataProduct = <DataProduct>[].obs;
  var isLoadingListProduct = true.obs;
  var isLoadingSaveProduct = true.obs;
  TextEditingController productNameController = TextEditingController();
  TextEditingController productDescriptionController = TextEditingController();
  TextEditingController productPriceController = TextEditingController();
  var idProduct = 0.obs;
  var productCategoryId = 0.obs;
  var productCategoryName = 'Category'.obs;

  void clearProductController() {
    idProduct.value = 0;
    productNameController.clear();
    productDescriptionController.clear();
    productPriceController.clear();
    update();
  }

  void editProduct(DataProduct model) {
    final formatCurrency =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp.', decimalDigits: 0);
    idProduct.value = model.idProduct!;
    productCategoryId.value = model.idProductCategories!;
    productNameController.text = model.name!;
    productDescriptionController.text = model.description!;
    productPriceController.text = formatCurrency.format(model.price);
    update();
  }

  void fetchDataListProduct() async {
    try {
      var rawFormat = {
        'id_product_categories': productCategoryId.value,
      };
      var result = await RemoteDataSource.getListProduct(rawFormat);
      if (result != null) {
        resultDataProduct.assignAll(result);
      }
    } finally {
      isLoadingListProduct(false);
    }
  }

  Future<void> saveProduct() async {
    try {
      if (productNameController.text.isEmpty) {
        throw "* All fields are required";
      }
      var rawFormat = {
        "id_product": idProduct.value,
        "id_product_categories": productCategoryId.value,
        "name": productNameController.text,
        "description": productDescriptionController.text,
        "price": int.parse(
            productPriceController.text.replaceAll(RegExp('[^0-9]'), '')),
      };
      bool result = await RemoteDataSource.saveProduct(rawFormat);
      if (result) {
        Get.snackbar(
          'Notification',
          'Saved successfully',
          icon: const Icon(Icons.check),
          snackPosition: SnackPosition.TOP,
        );
        productNameController.clear();
        productDescriptionController.clear();
        productPriceController.clear();
        fetchDataListProduct();
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
      isLoadingSaveProduct(false);
    }
  }

  /// Reorder di UI
  void reorderProduct(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) newIndex -= 1;
    final moved = resultDataProduct.removeAt(oldIndex);
    resultDataProduct.insert(newIndex, moved);

    // Update nilai sorting di lokal
    for (int i = 0; i < resultDataProduct.length; i++) {
      resultDataProduct[i].sorting = i + 1;
    }

    resultDataProduct.refresh();

    // Simpan ke server
    updateProductSorting();
  }

  /// Kirim urutan baru ke server
  Future<void> updateProductSorting() async {
    final payload = resultDataProduct.map((item) {
      return {
        "id_product": item.idProduct,
        "sorting": item.sorting,
      };
    }).toList();

    await RemoteDataSource.updateProductSorting(payload);
  }

  void updateStatusProduct(int id, bool status) async {
    var rawFormat = {'id': id, 'status': status};
    var resultUpdate = await RemoteDataSource.updateStatusProduct(rawFormat);
    if (resultUpdate) {
      Get.snackbar('Notification', 'Data updated successfully',
          icon: const Icon(Icons.check), snackPosition: SnackPosition.TOP);
      fetchDataListProduct();
    } else {
      Get.snackbar('Notification', 'Failed to update data',
          icon: const Icon(Icons.error), snackPosition: SnackPosition.TOP);
    }
  }

  void deleteProduct(int id) async {
    var resultUpdate = await RemoteDataSource.deleteProduct(id);
    if (resultUpdate) {
      Get.snackbar('Notification', 'Data deleted successfully',
          icon: const Icon(Icons.check), snackPosition: SnackPosition.TOP);
      fetchDataListProduct();
    } else {
      Get.snackbar('Notification', 'Failed to delete data',
          icon: const Icon(Icons.error), snackPosition: SnackPosition.TOP);
    }
  }

  void toggleFavorite(int id, bool favorite) async {
    var rawFormat = {'id': id, 'favorite': favorite};
    var resultUpdate = await RemoteDataSource.toggleFavoriteProduct(rawFormat);
    if (resultUpdate) {
      fetchDataListProduct();
    } else {
      Get.snackbar('Notification', 'Failed to update data',
          icon: const Icon(Icons.error), snackPosition: SnackPosition.TOP);
    }
  }
}
