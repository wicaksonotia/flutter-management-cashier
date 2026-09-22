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

  // ============================================================
  // PAGINATION
  // ============================================================

  int page = 1;
  final int limit = 10;
  bool hasMore = true;

  // ============================================================
  // FILTER
  // ============================================================

  var tags = ["PENGELUARAN", "PEMASUKAN"].obs;

  TextEditingController searchBarController = TextEditingController();

  // ============================================================
  // CLEAR FORM
  // ============================================================

  void clearCategoryController() {
    idCategoryTransaction.value = 0;
    nameController.clear();
    isPemasukan.value = false;

    update();
  }

  // ============================================================
  // LOAD PAGE 1
  // ============================================================

  Future<void> getData() async {
    try {
      await initializeBaseController();

      page = 1;
      hasMore = true;

      isLoadingCategory.value = true;
      resultDataCategory.clear();

      final rawFormat = {
        'status': 'all',
        'id_kios': idKios.value,
        'kategori': tags.toList(),
        'textSearch': searchBarController.text,
        'page': page,
        'limit': limit,
        'sort': sortOrder.value,
      };

      final result = await RemoteDataSource.listCategories(rawFormat);

      if (result != null) {
        final data = result.data ?? [];

        resultDataCategory.assignAll(data);

        // Jika data yang diterima kurang dari limit,
        // berarti sudah tidak ada halaman berikutnya.
        hasMore = data.length == limit;

        page++;
      }
    } catch (e) {
      print("getData error: $e");
    } finally {
      isLoadingCategory.value = false;
    }
  }

  // ============================================================
  // LOAD MORE
  // ============================================================

  Future<void> loadMore() async {
    if (!hasMore || isLoadingMore.value) return;

    try {
      isLoadingMore.value = true;

      final rawFormat = {
        'status': 'all',
        'id_kios': idKios.value,
        'kategori': tags.toList(),
        'textSearch': searchBarController.text,
        'page': page,
        'limit': limit,
        'sort': sortOrder.value,
      };

      final result = await RemoteDataSource.listCategories(rawFormat);

      if (result != null) {
        final newData = result.data ?? [];

        if (newData.isEmpty) {
          hasMore = false;
          return;
        }

        resultDataCategory.addAll(newData);

        // Jika data kurang dari limit,
        // berarti tidak ada page berikutnya.
        hasMore = newData.length == limit;

        page++;
      }
    } catch (e) {
      print("loadMore error: $e");
    } finally {
      isLoadingMore.value = false;
    }
  }

  // ============================================================
  // PULL TO REFRESH
  // ============================================================

  Future<void> refreshData() async {
    return getData();
  }

  // ============================================================
  // SORT
  // ============================================================

  void toggleSort() {
    sortOrder.value = sortOrder.value == "ASC" ? "DESC" : "ASC";

    getData();
  }

  // ============================================================
  // FETCH ALL CATEGORY
  // ============================================================

  Future<void> fetchAllCategory(Object kategori) async {
    try {
      await initializeBaseController();

      isLoadingWithoutPagination(true);

      final rawFormat = {
        'status': 'all',
        'id_kios': idKios.value,
        'kategori': kategori,
        'textSearch': '',
        'page': 1,
        'limit': 999999,
        'sort': sortOrder.value,
      };

      final result = await RemoteDataSource.listCategories(rawFormat);

      if (result != null) {
        final data = result.data ?? [];

        if (data.isNotEmpty) {
          idCategoryTransaction.value = data.first.id ?? 0;
          selectedCategoryTransaction.value = data.first.categoryName ?? '';
        }

        resultDataCategoryWithoutPagination.assignAll(data);
      }
    } catch (e) {
      print("fetchAllCategory error: $e");
    } finally {
      isLoadingWithoutPagination(false);
    }
  }

  // ============================================================
  // SAVE CATEGORY
  // ============================================================
  //
  // IMPORTANT:
  // Controller tidak melakukan Get.back().
  // Modal ditutup oleh CategoryForm menggunakan Navigator.pop(context).
  //
  // Return:
  // true  = berhasil
  // false = gagal
  //
  // ============================================================

  Future<bool> saveCategory() async {
    try {
      isLoadingSaveCategory(true);

      final rawFormat = {
        'id_kios': idKios.value,
        'id_category': idCategoryTransaction.value,
        'category_name': nameController.text.trim(),
        'is_pemasukan': isPemasukan.value,
      };

      print(jsonEncode(rawFormat));

      final result = await RemoteDataSource.saveCategory(rawFormat);

      if (result != null &&
          result["status"] == "ok" &&
          result["data"] != null) {
        final newItem = DataCategory.fromJson(
          result["data"],
        );

        if (idCategoryTransaction.value == 0) {
          // ======================================================
          // INSERT
          // ======================================================

          resultDataCategory.insert(
            0,
            newItem,
          );
        } else {
          // ======================================================
          // UPDATE
          // ======================================================

          final index = resultDataCategory.indexWhere(
            (e) => e.id == newItem.id,
          );

          if (index != -1) {
            resultDataCategory[index] = newItem;
          }
        }

        resultDataCategory.refresh();

        return true;
      }

      return false;
    } catch (e) {
      Get.snackbar(
        "Notification",
        "Failed: $e",
        icon: const Icon(
          Icons.error,
        ),
      );

      return false;
    } finally {
      isLoadingSaveCategory(false);
    }
  }

  // ============================================================
  // EDIT CATEGORY
  // ============================================================

  void editCategory(DataCategory model) {
    idCategoryTransaction.value = model.id ?? 0;

    nameController.text = model.categoryName ?? '';

    isPemasukan.value = model.categoryType == 'PEMASUKAN';

    update();
  }

  // ============================================================
  // UPDATE STATUS
  // ============================================================

  Future<void> updateStatusCategory(
    int id,
    bool newStatus,
  ) async {
    try {
      final rawFormat = {
        'id': id,
        'status': newStatus,
      };

      final success = await RemoteDataSource.updateStatusCategory(rawFormat);

      if (success) {
        // ========================================================
        // UPDATE DATA LOKAL
        // ========================================================

        final index = resultDataCategory.indexWhere(
          (item) => item.id == id,
        );

        if (index != -1) {
          resultDataCategory[index].status = newStatus;

          resultDataCategory.refresh();
        }

        Get.snackbar(
          'Notification',
          'Status updated successfully',
          icon: const Icon(
            Icons.check,
          ),
          snackPosition: SnackPosition.TOP,
        );
      } else {
        Get.snackbar(
          'Notification',
          'Failed to update data',
          icon: const Icon(
            Icons.error,
          ),
          snackPosition: SnackPosition.TOP,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        icon: const Icon(
          Icons.error,
        ),
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  // ============================================================
  // DELETE CATEGORY
  // ============================================================

  Future<void> deleteCategory(int id) async {
    try {
      isLoadingSaveCategory(true);

      final deletedId = await RemoteDataSource.deleteCategory(id);

      if (deletedId != null) {
        // ========================================================
        // REMOVE DARI LIST LOKAL
        // ========================================================

        resultDataCategory.removeWhere(
          (item) => item.id == deletedId,
        );

        Get.snackbar(
          'Notification',
          'Category deleted successfully',
          icon: const Icon(
            Icons.check,
          ),
          snackPosition: SnackPosition.TOP,
        );
      } else {
        Get.snackbar(
          'Notification',
          'Failed to delete category',
          icon: const Icon(
            Icons.error,
          ),
          snackPosition: SnackPosition.TOP,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        icon: const Icon(
          Icons.error,
        ),
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoadingSaveCategory(false);
    }
  }
}
