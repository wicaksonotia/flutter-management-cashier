import 'package:financial_apps/database/api_request.dart';
import 'package:financial_apps/models/category_model.dart';
import 'package:financial_apps/utils/colors.dart';
import 'package:financial_apps/utils/lists.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class CategoryController extends GetxController {
  TextEditingController nameController = TextEditingController();
  var tipeContoller = dropDownKategori.first.obs;
  var kategoriSearch = dropDownKategoriSearch.first.obs;
  var resultData = <CategoryModel>[].obs;
  RxList<dynamic> tags = [].obs;
  RxBool isLoading = false.obs;
  var dataCategoryName = ''.obs;
  var dataCategoryType = ''.obs;
  var dataStatus = true.obs;

  @override
  void onInit() {
    super.onInit();
    getData([]);
  }

  void insertCategory() async {
    try {
      isLoading(true);
      final model = CategoryModel(
          categoryName: nameController.text,
          categoryType: tipeContoller.value,
          id: resultData.length);
      var resultSave = await RemoteDataSource.saveCategory(model.toJson());
      if (resultSave) {
        // NOTIF SAVE SUCCESS
        Get.snackbar('Notification', 'Data saved successfully',
            icon: const Icon(Icons.check), snackPosition: SnackPosition.TOP);
        nameController.clear();
        // getData(kategoriSearch.value);
      } else {
        // NOTIF SAVE FAILED
        Get.snackbar('Notification', 'Failed to save data',
            icon: const Icon(Icons.error), snackPosition: SnackPosition.TOP);
      }
    } catch (e) {
      Get.snackbar(
          'Notification', 'Failed to save transaction: ${e.toString()}',
          icon: const Icon(Icons.error), snackPosition: SnackPosition.TOP);
    } finally {
      isLoading(false);
    }
  }

  void deleteCategory(int id) async {
    Get.defaultDialog(
      title: "Confirmation",
      middleText: "Are you sure you want to delete this category?",
      textCancel: "No",
      textConfirm: "Yes",
      onConfirm: () async {
        var resultUpdate = await RemoteDataSource.deleteCategory(id);
        // print(resultUpdate);
        if (resultUpdate) {
          // NOTIF UPDATE SUCCESS
          Get.back();
          Get.snackbar('Notification', 'Data updated successfully',
              icon: const Icon(Icons.check), snackPosition: SnackPosition.TOP);
          getData(tags);
        } else {
          // NOTIF UPDATE FAILED
          Get.snackbar('Notification', 'Failed to update data',
              icon: const Icon(Icons.error), snackPosition: SnackPosition.TOP);
        }
      },
      onCancel: () {
        Get.back();
      },
    );
  }

  void updateCategory(int id) async {
    try {
      isLoading(true);
      final model = CategoryModel(
          categoryName: nameController.text,
          categoryType: dataCategoryType.value,
          status: dataStatus.value);
      var resultUpdate =
          await RemoteDataSource.updateCategory(id, model.toJson());
      if (resultUpdate) {
        // NOTIF UPDATE SUCCESS
        Get.snackbar('Notification', 'Data updated successfully',
            icon: const Icon(Icons.check), snackPosition: SnackPosition.TOP);
        // getData(kategoriSearch.value);
      } else {
        // NOTIF UPDATE FAILED
        Get.snackbar('Notification', 'Failed to update data',
            icon: const Icon(Icons.error), snackPosition: SnackPosition.TOP);
      }
    } catch (e) {
      Get.snackbar(
          'Notification', 'Failed to update transaction: ${e.toString()}',
          icon: const Icon(Icons.error), snackPosition: SnackPosition.TOP);
    } finally {
      isLoading(false);
    }
  }

  void detailCategory(int id) async {
    final data = await RemoteDataSource.detailCategory(id);
    nameController.text = data?.categoryName ?? '';
    dataCategoryType.value = data?.categoryType ?? '';
    dataStatus.value = data?.status ?? true;
    Get.defaultDialog(
        title: "Detail Category",
        content: Column(
          children: [
            Obx(() => InputDecorator(
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Category",
                      contentPadding: EdgeInsets.fromLTRB(10, 3, 3, 3)),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton(
                      value: dataCategoryType.value,
                      items: dropDownKategori.map(
                        (String value) {
                          return DropdownMenuItem(
                            value: value,
                            child: Text(value),
                          );
                        },
                      ).toList(),
                      onChanged: (value) {
                        dataCategoryType.value = value!;
                      },
                      isExpanded: true,
                      style: const TextStyle(
                          fontSize: 17, color: MyColors.darkTextColor),
                    ),
                  ),
                )),
            const Gap(10),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Category Name', //labelText: 'Category Name',
              ),
            ),
          ],
        ),
        confirm: TextButton(
          child: const Text(
            "Save",
            style: TextStyle(color: MyColors.primary),
          ),
          onPressed: () {
            updateCategory(id);
            Get.back();
          },
        ),
        textCancel: "Close",
        onCancel: () {
          Get.back();
        });
  }

  // LIST DATA CATEGORIES
  void getData(Object kategori) async {
    try {
      isLoading(true);
      final result = await RemoteDataSource.listCategories(kategori);
      if (result != null) {
        resultData.assignAll(result);
      }
    } catch (error) {
      Get.snackbar('Error', error.toString(),
          icon: const Icon(Icons.error), snackPosition: SnackPosition.TOP);
      isLoading(false);
    } finally {
      isLoading(false);
    }
  }
}
