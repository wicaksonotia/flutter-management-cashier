import 'dart:convert';

import 'package:cashier_management/controllers/base_controller.dart';
import 'package:cashier_management/database/api_request.dart';
import 'package:cashier_management/models/category_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoryController extends BaseController {
  var resultDataCategory = <DataCategory>[].obs;
  var resultDataCategoryWithoutPagination = <DataCategory>[].obs;
  var isPemasukan = false.obs;

  var isLoadingWithoutPagination = false.obs;
  var isLoadingCategory = false.obs;
  var isLoadingSaveCategory = false.obs;
  var isLoadingMore = false.obs;
  var dataStatus = true.obs;
  var isEmptyValueSearchBar = true.obs;
  TextEditingController nameController = TextEditingController();
  var idCategoryTransaction = 0.obs;
  var selectedCategoryTransaction = 'Category'.obs;
  var sortOrder = "ASC".obs;

  // PAGINATION
  int page = 1;
  final int limit = 10;
  bool hasMore = true;

  // FILTER
  var tags = ["PENGELUARAN", "PEMASUKAN"].obs;
  TextEditingController searchBarController = TextEditingController();

  void clearCategoryController() {
    idCategoryTransaction.value = 0;
    nameController.clear();
    isPemasukan.value = false;
    update();
  }

  // LOAD PAGE 1
  Future<void> getData() async {
    try {
      page = 1;
      hasMore = true;
      isLoadingCategory.value = true;
      resultDataCategory.clear();

      var rawFormat = {
        'kategori': tags.toList(),
        'textSearch': searchBarController.text,
        'page': page,
        'limit': limit,
        'sort': sortOrder.value
      };

      final result = await RemoteDataSource.listCategories(rawFormat);
      if (result != null) {
        resultDataCategory.assignAll(result.data ?? []);
        // jika jumlah data yg diterima < limit → berarti tidak ada page berikutnya
        hasMore = (result.data?.length ?? 0) == limit;

        page++; // next page
      }
    } catch (e) {
      print("getData error: $e");
    } finally {
      isLoadingCategory.value = false;
    }
  }

  // LOAD MORE
  Future<void> loadMore() async {
    if (!hasMore || isLoadingMore.value) return;

    try {
      isLoadingMore.value = true;
      var rawFormat = {
        'kategori': tags.toList(),
        'textSearch': searchBarController.text,
        'page': page,
        'limit': limit,
        'sort': sortOrder.value
      };
      final result = await RemoteDataSource.listCategories(rawFormat);

      if (result != null) {
        final newData = result.data ?? [];

        if (newData.isEmpty) {
          hasMore = false; // <---- FIX DI SINI
          return;
        }

        resultDataCategory.addAll(newData);
        // jika jumlah data yg diterima < limit → berarti tidak ada page berikutnya
        hasMore = (newData.length == limit);

        page++;
      }
    } catch (e) {
      print("loadMore error: $e");
    } finally {
      isLoadingMore.value = false;
    }
  }

  // PULL TO REFRESH
  Future<void> refreshData() async {
    return getData();
  }

  void toggleSort() {
    sortOrder.value = sortOrder.value == "ASC" ? "DESC" : "ASC";
    getData(); // reload page 1 dengan urutan baru
  }

  Future<void> fetchAllCategory(Object kategori) async {
    try {
      isLoadingWithoutPagination(true);
      var rawFormat = {
        'kategori': kategori,
        'textSearch': '',
        'page': 1,
        'limit': 999999,
        'sort': sortOrder.value
      };
      final result = await RemoteDataSource.listCategories(rawFormat);

      if (result != null) {
        idCategoryTransaction.value = result.data?.first.id ?? 0;
        selectedCategoryTransaction.value =
            result.data?.first.categoryName ?? '';
        resultDataCategoryWithoutPagination.assignAll(result.data ?? []);
      }
    } finally {
      isLoadingWithoutPagination(false);
    }
  }

  void saveCategory() async {
    try {
      isLoadingSaveCategory(true);

      var rawFormat = {
        'id_category': idCategoryTransaction.value,
        'category_name': nameController.text,
        'is_pemasukan': isPemasukan.value,
      };
      print(jsonEncode(rawFormat));
      final result = await RemoteDataSource.saveCategory(rawFormat);

      if (result!["status"] == "ok" && result["data"] != null) {
        final newItem = DataCategory.fromJson(result["data"]);

        if (idCategoryTransaction.value == 0) {
          // INSERT
          resultDataCategory.insert(0, newItem);
        } else {
          // UPDATE
          final index =
              resultDataCategory.indexWhere((e) => e.id == newItem.id);
          if (index != -1) resultDataCategory[index] = newItem;
        }

        resultDataCategory.refresh();
        Get.back();
        Get.snackbar("Notification", "Success", icon: Icon(Icons.check));
      }
    } catch (e) {
      Get.snackbar("Notification", "Failed: $e", icon: Icon(Icons.error));
    } finally {
      isLoadingSaveCategory(false);
    }
  }

  void editCategory(DataCategory model) {
    idCategoryTransaction.value = model.id!;
    nameController.text = model.categoryName!;
    isPemasukan.value = model.categoryType == 'PEMASUKAN' ? true : false;
    update();
  }

  void updateStatusCategory(int id, bool newStatus) async {
    try {
      final rawFormat = {'id': id, 'status': newStatus};
      final success = await RemoteDataSource.updateStatusCategory(rawFormat);

      if (success) {
        // Update data lokal
        final index = resultDataCategory.indexWhere((item) => item.id == id);
        if (index != -1) {
          resultDataCategory[index].status = newStatus;
          resultDataCategory
              .refresh(); // <--- update UI tanpa reload seluruh data
        }

        Get.snackbar(
          'Notification',
          'Status updated successfully',
          icon: const Icon(Icons.check),
          snackPosition: SnackPosition.TOP,
        );
      } else {
        Get.snackbar(
          'Notification',
          'Failed to update data',
          icon: const Icon(Icons.error),
          snackPosition: SnackPosition.TOP,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        icon: const Icon(Icons.error),
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  void deleteCategory(int id) async {
    try {
      isLoadingSaveCategory(true);

      final deletedId = await RemoteDataSource.deleteCategory(id);

      if (deletedId != null) {
        // Hapus langsung dari list tanpa getData();
        resultDataCategory.removeWhere((item) => item.id == deletedId);

        Get.snackbar(
          'Notification',
          'Category deleted successfully',
          icon: const Icon(Icons.check),
          snackPosition: SnackPosition.TOP,
        );
      } else {
        Get.snackbar(
          'Notification',
          'Failed to delete category',
          icon: const Icon(Icons.error),
          snackPosition: SnackPosition.TOP,
        );
      }
    } finally {
      isLoadingSaveCategory(false);
    }
  }
}
