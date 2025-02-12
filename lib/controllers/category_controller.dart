import 'package:financial_apps/database/database_helper.dart';
import 'package:financial_apps/models/category_model.dart';
import 'package:financial_apps/utils/lists.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoryController extends GetxController {
  TextEditingController nameController = TextEditingController();
  var tipeContoller = dropDownKategori.first.obs;
  var kategoriSearch = dropDownKategoriSearch.first.obs;
  var resultData = <CategoryModel>[].obs;
  RxList<dynamic> tags = [].obs;
  RxBool isLoading = false.obs;

  closeDialog() {
    Get.back();
  }

  @override
  void onInit() {
    super.onInit();
    getData(kategoriSearch.value);
  }

  insertCategory() async {
    final model = CategoryModel(
        name: nameController.text,
        type: tipeContoller.value,
        id: resultData.length);
    DatabaseHelper().insertCategories(model);
    nameController.clear();
    getData(kategoriSearch.value);
    // closeDialog();
  }

  void deleteCategory(int id) async {
    await DatabaseHelper.instance.deleteCategories(id);
    resultData.removeWhere((element) => element.id == id);
  }

  void updateCategory(int id) async {
    // await DatabaseHelper.instance.deleteCat(id);
    // resultData.removeWhere((element) => element.id == id);
  }

  void getData(String kategori) async {
    try {
      isLoading(true);
      resultData.clear();
      DatabaseHelper.instance.fetchCategories(kategori).then((value) {
        for (var element in value) {
          resultData.add(CategoryModel(
              id: element.id, name: element.name, type: element.type));
        }
      });
    } catch (error) {
      print(error.toString());
      // Get.snackbar('Error', "Silakan cek koneksi internet anda.",
      //     icon: const Icon(Icons.error), snackPosition: SnackPosition.BOTTOM);
      isLoading(false);
    } finally {
      isLoading(false);
    }
  }
}
