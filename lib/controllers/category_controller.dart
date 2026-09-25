import 'package:cashier_management/controllers/base_controller.dart';
import 'package:cashier_management/database/api_request.dart';
import 'package:cashier_management/models/category_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoryController extends BaseController {
  // ===========================================================================
  // DATA
  // ===========================================================================

  final RxList<DataCategory> resultDataCategory = <DataCategory>[].obs;

  final RxList<DataCategory> resultDataCategoryWithoutPagination =
      <DataCategory>[].obs;

  // ===========================================================================
  // STATE
  // ===========================================================================

  final RxBool isPemasukan = false.obs;

  final RxBool isLoadingWithoutPagination = false.obs;
  final RxBool isLoadingCategory = false.obs;
  final RxBool isLoadingSaveCategory = false.obs;
  final RxBool isLoadingMore = false.obs;

  final RxBool dataStatus = true.obs;
  final RxBool isEmptyValueSearchBar = true.obs;

  // ===========================================================================
  // FORM
  // ===========================================================================

  final TextEditingController nameController = TextEditingController();

  final TextEditingController searchBarController = TextEditingController();

  final RxInt idCategoryTransaction = 0.obs;

  final RxString selectedCategoryTransaction = 'Category'.obs;

  final RxString sortOrder = 'ASC'.obs;

  // ===========================================================================
  // PAGINATION
  // ===========================================================================

  int page = 1;

  static const int limit = 10;

  bool hasMore = true;

  // ===========================================================================
  // FILTER
  // ===========================================================================

  final RxList<String> tags = <String>[
    'PENGELUARAN',
    'PEMASUKAN',
  ].obs;

  // ===========================================================================
  // CATEGORY MANAGEMENT
  // ===========================================================================

  void clearCategoryController() {
    idCategoryTransaction.value = 0;
    selectedCategoryTransaction.value = 'Category';

    nameController.clear();

    isPemasukan.value = false;

    update();
  }

  // ===========================================================================
  // LIST CATEGORY
  // ===========================================================================

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
        'textSearch': searchBarController.text.trim(),
        'page': page,
        'limit': limit,
        'sort': sortOrder.value,
      };

      final result = await RemoteDataSource.listCategories(rawFormat);

      if (result != null) {
        final data = result.data ?? [];

        resultDataCategory.assignAll(data);

        hasMore = data.length == limit;

        if (data.isNotEmpty) {
          page++;
        }
      }
    } catch (e) {
      debugPrint(
        'CategoryController.getData error: $e',
      );
    } finally {
      isLoadingCategory.value = false;
    }
  }

  // ===========================================================================
  // LOAD MORE
  // ===========================================================================

  Future<void> loadMore() async {
    if (!hasMore || isLoadingMore.value) {
      return;
    }

    try {
      isLoadingMore.value = true;

      final rawFormat = {
        'status': 'all',
        'id_kios': idKios.value,
        'kategori': tags.toList(),
        'textSearch': searchBarController.text.trim(),
        'page': page,
        'limit': limit,
        'sort': sortOrder.value,
      };

      final result = await RemoteDataSource.listCategories(rawFormat);

      if (result == null) {
        return;
      }

      final newData = result.data ?? [];

      if (newData.isEmpty) {
        hasMore = false;
        return;
      }

      resultDataCategory.addAll(newData);

      hasMore = newData.length == limit;

      page++;
    } catch (e) {
      debugPrint(
        'CategoryController.loadMore error: $e',
      );
    } finally {
      isLoadingMore.value = false;
    }
  }

  // ===========================================================================
  // REFRESH
  // ===========================================================================

  Future<void> refreshData() async {
    await getData();
  }

  // ===========================================================================
  // SORT
  // ===========================================================================

  void toggleSort() {
    sortOrder.value = sortOrder.value == 'ASC' ? 'DESC' : 'ASC';

    getData();
  }

  // ===========================================================================
  // FETCH ALL CATEGORY
  //
  // Dipakai oleh AddTransactionSheet.
  //
  // PENTING:
  // Tidak lagi otomatis memilih kategori pertama.
  // User harus memilih kategori sendiri.
  // ===========================================================================

  Future<void> fetchAllCategory(
    Object kategori,
  ) async {
    try {
      await initializeBaseController();

      isLoadingWithoutPagination.value = true;

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

        resultDataCategoryWithoutPagination.assignAll(data);

        // Jangan auto-select.
        //
        // Sebelumnya:
        //
        // idCategoryTransaction.value = data.first.id;
        // selectedCategoryTransaction.value = ...
        //
        // Sekarang user wajib memilih sendiri.
      } else {
        resultDataCategoryWithoutPagination.clear();
      }
    } catch (e) {
      debugPrint(
        'CategoryController.fetchAllCategory error: $e',
      );

      resultDataCategoryWithoutPagination.clear();
    } finally {
      isLoadingWithoutPagination.value = false;
    }
  }

  // ===========================================================================
  // SELECT CATEGORY
  // ===========================================================================

  void selectTransactionCategory(
    DataCategory category,
  ) {
    idCategoryTransaction.value = category.id ?? 0;

    selectedCategoryTransaction.value = category.categoryName ?? 'Category';

    update();
  }

  // ===========================================================================
  // CLEAR TRANSACTION CATEGORY
  // ===========================================================================

  void clearSelectedTransactionCategory() {
    idCategoryTransaction.value = 0;

    selectedCategoryTransaction.value = 'Category';

    update();
  }

  // ===========================================================================
  // SAVE CATEGORY
  // ===========================================================================

  Future<bool> saveCategory() async {
    try {
      isLoadingSaveCategory.value = true;

      final rawFormat = {
        'id_kios': idKios.value,
        'id_category': idCategoryTransaction.value,
        'category_name': nameController.text.trim(),
        'is_pemasukan': isPemasukan.value,
      };

      debugPrint(
        'saveCategory: $rawFormat',
      );

      final result = await RemoteDataSource.saveCategory(
        rawFormat,
      );

      if (result == null ||
          result['status'] != 'ok' ||
          result['data'] == null) {
        return false;
      }

      final newItem = DataCategory.fromJson(
        result['data'],
      );

      if (idCategoryTransaction.value == 0) {
        resultDataCategory.insert(
          0,
          newItem,
        );
      } else {
        final index = resultDataCategory.indexWhere(
          (item) => item.id == newItem.id,
        );

        if (index != -1) {
          resultDataCategory[index] = newItem;
        }
      }

      resultDataCategory.refresh();

      return true;
    } catch (e) {
      debugPrint(
        'CategoryController.saveCategory error: $e',
      );

      return false;
    } finally {
      isLoadingSaveCategory.value = false;
    }
  }

  // ===========================================================================
  // EDIT CATEGORY
  // ===========================================================================

  void editCategory(
    DataCategory model,
  ) {
    idCategoryTransaction.value = model.id ?? 0;

    nameController.text = model.categoryName ?? '';

    isPemasukan.value = model.categoryType == 'PEMASUKAN';

    update();
  }

  // ===========================================================================
  // UPDATE STATUS
  // ===========================================================================

  Future<bool> updateStatusCategory(
    int id,
    bool newStatus,
  ) async {
    try {
      final rawFormat = {
        'id': id,
        'status': newStatus,
      };

      final success = await RemoteDataSource.updateStatusCategory(
        rawFormat,
      );

      if (!success) {
        return false;
      }

      final index = resultDataCategory.indexWhere(
        (item) => item.id == id,
      );

      if (index != -1) {
        resultDataCategory[index].status = newStatus;

        resultDataCategory.refresh();
      }

      return true;
    } catch (e) {
      debugPrint(
        'CategoryController.updateStatusCategory error: $e',
      );

      return false;
    }
  }

  // ===========================================================================
  // DELETE CATEGORY
  // ===========================================================================

  Future<bool> deleteCategory(
    int id,
  ) async {
    try {
      isLoadingSaveCategory.value = true;

      final deletedId = await RemoteDataSource.deleteCategory(id);

      if (deletedId == null) {
        return false;
      }

      resultDataCategory.removeWhere(
        (item) => item.id == deletedId,
      );

      return true;
    } catch (e) {
      debugPrint(
        'CategoryController.deleteCategory error: $e',
      );

      return false;
    } finally {
      isLoadingSaveCategory.value = false;
    }
  }

  // ===========================================================================
  // DISPOSE
  // ===========================================================================

  @override
  void onClose() {
    nameController.dispose();
    searchBarController.dispose();

    super.onClose();
  }
}
