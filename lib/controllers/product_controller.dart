import 'package:cashier_management/controllers/product_category_controller.dart';
import 'package:cashier_management/database/api_request.dart';
import 'package:cashier_management/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ProductController extends ProductCategoryController {
  // ==========================================================
  // PRODUCT DATA
  // ==========================================================

  final resultDataProduct = <DataProduct>[].obs;

  final isLoadingListProduct = true.obs;
  final isLoadingSaveProduct = false.obs;

  // ==========================================================
  // PRODUCT FORM
  // ==========================================================

  final productNameController = TextEditingController();
  final productDescriptionController = TextEditingController();
  final productPriceController = TextEditingController();

  final idProduct = 0.obs;

  // ==========================================================
  // PRODUCT FILTER / VIEW
  // ==========================================================

  final searchProduct = ''.obs;

  /// Category yang sedang aktif.
  ///
  /// Tidak ada category 0 / "Semua".
  final selectedProductCategoryId = 0.obs;

  final isGridView = true.obs;

  final isProductManagementInitialized = false.obs;

  Future<void> initializeProductManagement() async {
    if (isProductManagementInitialized.value) {
      return;
    }

    try {
      isProductManagementInitialized(true);

      await initializeBaseController();

      if (idKios.value <= 0) {
        debugPrint(
          '[PRODUCT] idKios belum tersedia.',
        );
        return;
      }

      debugPrint(
        '[PRODUCT] initialize dengan idKios: ${idKios.value}',
      );

      await fetchDataListProductCategory();
    } finally {
      isProductManagementInitialized(false);
    }
  }

  Future<void> fetchInitialProductData() async {
    debugPrint('[PRODUCT] Initial fetch START');

    try {
      isLoadingListProduct(true);

      await fetchDataListProductCategory();

      debugPrint('[PRODUCT] Initial fetch DONE');
    } catch (e) {
      debugPrint('[PRODUCT] Initial fetch ERROR: $e');

      resultDataProduct.clear();

      Get.snackbar(
        'Gagal',
        'Gagal memuat data produk.',
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoadingListProduct(false);

      debugPrint(
        '[PRODUCT] Loading: ${isLoadingListProduct.value}',
      );
    }
  }

  // ==========================================================
  // FILTERED PRODUCTS
  // ==========================================================

  /// Produk dari API sudah berdasarkan category.
  ///
  /// Jadi di sini kita hanya melakukan filter search.
  List<DataProduct> get filteredProducts {
    final search = searchProduct.value.trim().toLowerCase();

    if (search.isEmpty) {
      return resultDataProduct.toList();
    }

    return resultDataProduct.where((product) {
      final name = (product.name ?? '').toLowerCase();
      final description = (product.description ?? '').toLowerCase();

      return name.contains(search) || description.contains(search);
    }).toList();
  }

  // ==========================================================
  // SEARCH
  // ==========================================================

  void setProductSearch(String value) {
    searchProduct.value = value;
  }

  void clearProductSearch() {
    searchProduct.value = '';
  }

  // ==========================================================
  // CATEGORY
  // ==========================================================

  /// Memilih kategori sekaligus mengambil produknya.
  Future<void> setProductCategory(int categoryId) async {
    if (categoryId <= 0) return;

    if (selectedProductCategoryId.value == categoryId &&
        resultDataProduct.isNotEmpty) {
      return;
    }

    selectedProductCategoryId.value = categoryId;

    await fetchDataListProduct();
  }

  /// Dipanggil setelah kategori berhasil diambil.
  ///
  /// Otomatis memilih kategori pertama.
  Future<void> selectFirstProductCategory() async {
    if (resultDataProductCategory.isEmpty) {
      selectedProductCategoryId.value = 0;
      resultDataProduct.clear();
      return;
    }

    final firstCategory = resultDataProductCategory.first;
    final firstCategoryId = firstCategory.idCategories ?? 0;

    if (firstCategoryId <= 0) {
      selectedProductCategoryId.value = 0;
      resultDataProduct.clear();
      return;
    }

    selectedProductCategoryId.value = firstCategoryId;

    await fetchDataListProduct();
  }

  // ==========================================================
  // VIEW
  // ==========================================================

  void toggleProductView() {
    isGridView.toggle();
  }

  // ==========================================================
  // CLEAR FORM
  // ==========================================================

  void clearProductController() {
    idProduct.value = 0;

    productNameController.clear();
    productDescriptionController.clear();
    productPriceController.clear();

    update();
  }

  // ==========================================================
  // EDIT PRODUCT
  // ==========================================================

  void editProduct(DataProduct model) {
    final formatCurrency = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp.',
      decimalDigits: 0,
    );

    idProduct.value = model.idProduct ?? 0;

    idProductCategory.value = model.idProductCategories ?? 0;

    productNameController.text = model.name ?? '';

    productDescriptionController.text = model.description ?? '';

    productPriceController.text = formatCurrency.format(
      model.price ?? 0,
    );

    update();
  }

  // ==========================================================
  // FETCH PRODUCT CATEGORY
  // ==========================================================

  @override
  Future<void> fetchDataListProductCategory({
    Future<void> Function()? onAfterSuccess,
  }) async {
    final activeKiosId = idKios.value;

    if (activeKiosId <= 0) {
      resultDataProductCategory.clear();
      resultDataProduct.clear();
      selectedProductCategoryId.value = 0;
      return;
    }

    try {
      isLoadingList.value = true;

      final rawFormat = {
        'id_kios': activeKiosId,
      };

      debugPrint(
        '==================================================',
      );
      debugPrint(
        '[PRODUCT CATEGORY] ACTIVE ID KIOS: $activeKiosId',
      );
      debugPrint(
        '[PRODUCT CATEGORY] REQUEST: $rawFormat',
      );
      debugPrint(
        '==================================================',
      );

      final result = await RemoteDataSource.getListProductCategory(
        rawFormat,
      );

      debugPrint(
        '[PRODUCT CATEGORY] RESULT COUNT: ${result?.length ?? 0}',
      );

      if (result != null) {
        for (final category in result) {
          debugPrint(
            '[PRODUCT CATEGORY] '
            'id=${category.idCategories}, '
            'name=${category.name}, '
            'id_kios=${category.idKios}',
          );
        }
      }

      if (result != null && result.isNotEmpty) {
        resultDataProductCategory.assignAll(result);

        final firstCategory = resultDataProductCategory.first;

        final firstCategoryId = firstCategory.idCategories ?? 0;

        if (firstCategoryId > 0) {
          selectedProductCategoryId.value = firstCategoryId;

          await fetchDataListProduct();
        } else {
          selectedProductCategoryId.value = 0;
          resultDataProduct.clear();
        }
      }

      if (onAfterSuccess != null) {
        await onAfterSuccess();
      }
    } catch (e) {
      resultDataProductCategory.clear();
      resultDataProduct.clear();
      selectedProductCategoryId.value = 0;

      Get.snackbar(
        'Gagal',
        'Gagal mengambil kategori produk.',
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoadingList.value = false;
    }
  }

  // ==========================================================
  // FETCH PRODUCT
  // ==========================================================

  Future<void> fetchDataListProduct() async {
    final categoryId = selectedProductCategoryId.value;

    if (categoryId <= 0) {
      resultDataProduct.clear();
      return;
    }

    isLoadingListProduct(true);

    try {
      final rawFormat = {
        'id_product_categories': categoryId,
      };

      final result = await RemoteDataSource.getListProduct(
        rawFormat,
      );

      if (result != null) {
        resultDataProduct.assignAll(result);
      } else {
        resultDataProduct.clear();
      }
    } catch (e) {
      resultDataProduct.clear();

      Get.snackbar(
        'Gagal memuat produk',
        e.toString(),
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.shade50,
        colorText: Colors.red.shade700,
      );
    } finally {
      isLoadingListProduct(false);
    }
  }

  // ==========================================================
  // SAVE PRODUCT
  // ==========================================================

  Future<void> saveProduct() async {
    if (isLoadingSaveProduct.value) return;

    try {
      final name = productNameController.text.trim();

      final description = productDescriptionController.text.trim();

      final cleanPrice =
          productPriceController.text.replaceAll(RegExp(r'[^0-9]'), '').trim();

      if (name.isEmpty) {
        throw 'Nama produk wajib diisi.';
      }

      if (cleanPrice.isEmpty) {
        throw 'Harga produk wajib diisi.';
      }

      final price = int.tryParse(cleanPrice);

      if (price == null) {
        throw 'Harga produk tidak valid.';
      }

      if (idProductCategory.value == 0) {
        throw 'Kategori produk wajib dipilih.';
      }

      isLoadingSaveProduct(true);

      final rawFormat = {
        'id_product': idProduct.value,
        'id_product_categories': idProductCategory.value,
        'name': name,
        'description': description,
        'price': price,
      };

      final result = await RemoteDataSource.saveProduct(rawFormat);

      if (!result) {
        throw 'Gagal menyimpan produk.';
      }

      Get.snackbar(
        'Berhasil',
        idProduct.value == 0
            ? 'Produk berhasil ditambahkan.'
            : 'Produk berhasil diperbarui.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green.shade50,
        colorText: Colors.green.shade700,
        icon: const Icon(
          Icons.check_circle_outline_rounded,
          color: Colors.green,
        ),
      );

      clearProductController();

      // Refresh produk dari category yang sedang aktif.
      await fetchDataListProduct();

      Get.back();
    } catch (e) {
      Get.snackbar(
        'Tidak dapat menyimpan',
        e.toString(),
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.shade50,
        colorText: Colors.red.shade700,
        icon: const Icon(
          Icons.error_outline_rounded,
          color: Colors.red,
        ),
      );
    } finally {
      isLoadingSaveProduct(false);
    }
  }

  // ==========================================================
  // REORDER PRODUCT
  // ==========================================================

  void reorderProduct(
    int oldIndex,
    int newIndex,
  ) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }

    final moved = resultDataProduct.removeAt(oldIndex);

    resultDataProduct.insert(
      newIndex,
      moved,
    );

    for (int i = 0; i < resultDataProduct.length; i++) {
      resultDataProduct[i].sorting = i + 1;
    }

    resultDataProduct.refresh();

    updateProductSorting();
  }

  Future<void> updateProductSorting() async {
    final payload = resultDataProduct.map((item) {
      return {
        'id_product': item.idProduct,
        'sorting': item.sorting,
      };
    }).toList();

    await RemoteDataSource.updateProductSorting(
      payload,
    );
  }

  // ==========================================================
  // UPDATE STATUS
  // ==========================================================

  Future<void> updateStatusProduct(
    int id,
    bool newStatus,
  ) async {
    try {
      final rawFormat = {
        'id': id,
        'status': newStatus,
      };

      final success = await RemoteDataSource.updateStatusProduct(
        rawFormat,
      );

      if (!success) {
        throw 'Gagal mengubah status produk.';
      }

      final index = resultDataProduct.indexWhere(
        (item) => item.idProduct == id,
      );

      if (index != -1) {
        resultDataProduct[index].status = newStatus;

        resultDataProduct.refresh();
      }

      Get.snackbar(
        'Status diperbarui',
        newStatus ? 'Produk sekarang aktif.' : 'Produk sekarang nonaktif.',
        snackPosition: SnackPosition.TOP,
        backgroundColor:
            newStatus ? Colors.green.shade50 : Colors.orange.shade50,
        colorText: newStatus ? Colors.green.shade700 : Colors.orange.shade800,
      );
    } catch (e) {
      Get.snackbar(
        'Gagal',
        e.toString(),
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.shade50,
        colorText: Colors.red.shade700,
      );
    }
  }

  // ==========================================================
  // DELETE PRODUCT
  // ==========================================================

  Future<void> deleteProduct(int id) async {
    try {
      final result = await RemoteDataSource.deleteProduct(id);

      if (!result) {
        throw 'Gagal menghapus produk.';
      }

      resultDataProduct.removeWhere(
        (item) => item.idProduct == id,
      );

      Get.snackbar(
        'Produk dihapus',
        'Produk berhasil dihapus.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green.shade50,
        colorText: Colors.green.shade700,
      );
    } catch (e) {
      Get.snackbar(
        'Gagal menghapus',
        e.toString(),
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.shade50,
        colorText: Colors.red.shade700,
      );
    }
  }

  // ==========================================================
  // FAVORITE
  // ==========================================================

  Future<void> toggleFavorite(
    int id,
    bool favorite,
  ) async {
    try {
      final rawFormat = {
        'id': id,
        'favorite': favorite,
      };

      final result = await RemoteDataSource.toggleFavoriteProduct(
        rawFormat,
      );

      if (!result) {
        throw 'Gagal mengubah favorite.';
      }

      final index = resultDataProduct.indexWhere(
        (item) => item.idProduct == id,
      );

      if (index != -1) {
        resultDataProduct[index].favorite = favorite;

        resultDataProduct.refresh();
      }
    } catch (e) {
      Get.snackbar(
        'Gagal',
        e.toString(),
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.shade50,
        colorText: Colors.red.shade700,
      );
    }
  }

  // ==========================================================
  // DISPOSE
  // ==========================================================

  @override
  void onClose() {
    productNameController.dispose();
    productDescriptionController.dispose();
    productPriceController.dispose();

    super.onClose();
  }
}
