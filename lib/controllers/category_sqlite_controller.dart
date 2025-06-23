import 'package:cashier_management/database/database_helper.dart';
import 'package:cashier_management/models/category_model.dart';
import 'package:cashier_management/utils/colors.dart';
import 'package:cashier_management/utils/lists.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class CategorySqliteController extends GetxController {
  TextEditingController nameController = TextEditingController();
  var tipeContoller = dropDownKategori.first.obs;
  var kategoriSearch = dropDownKategoriSearch.first.obs;
  var resultData = <CategoryModel>[].obs;
  RxList<dynamic> tags = [].obs;
  RxBool isLoading = false.obs;
  var dataCategoryName = ''.obs;
  var datatransactionType = ''.obs;
  var dataStatus = true.obs;

  closeDialog() {
    Get.back();
  }

  @override
  void onInit() {
    super.onInit();
    getData(kategoriSearch.value);
  }

  void insertCategory() async {
    final model = CategoryModel(
        categoryName: nameController.text,
        transactionType: tipeContoller.value,
        id: resultData.length);
    DatabaseHelper().insertCategories(model);
    nameController.clear();
    getData(kategoriSearch.value);
    // closeDialog();
  }

  void deleteCategory(int id) async {
    Get.defaultDialog(
      title: "Confirmation",
      middleText: "Are you sure you want to delete this category?",
      textCancel: "No",
      textConfirm: "Yes",
      onConfirm: () async {
        // await DatabaseHelper.instance.deleteCategories(id);
        // resultData.removeWhere((element) => element.id == id);
        await DatabaseHelper.instance.deleteCategories(id);
        getData(kategoriSearch.value);
        Get.back();
      },
      onCancel: () {
        Get.back();
      },
    );
  }

  void detailCategory(int id) async {
    final data = await DatabaseHelper.instance.detailCategories(id);
    nameController.text = data?.categoryName ?? '';
    datatransactionType.value = data?.transactionType ?? '';
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
                      value: datatransactionType.value,
                      items: dropDownKategori.map(
                        (String value) {
                          return DropdownMenuItem(
                            value: value,
                            child: Text(value),
                          );
                        },
                      ).toList(),
                      onChanged: (value) {
                        datatransactionType.value = value!;
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

  void updateCategory(int id) async {
    final model = CategoryModel(
        categoryName: nameController.text,
        transactionType: datatransactionType.value,
        id: id);
    DatabaseHelper().updateCategories(id, model);
    getData(kategoriSearch.value);
  }

  void syncLocalToServerCategories() async {
    await DatabaseHelper.instance.syncLocalToServerCategories();
  }

  void syncServerToLocalCategories() async {
    await DatabaseHelper.instance.syncServerToLocalCategories();
    getData(kategoriSearch.value);
  }

  void getData(String kategori) async {
    try {
      isLoading(true);
      resultData.clear();
      DatabaseHelper.instance.fetchCategories(kategori).then((value) {
        for (var element in value) {
          resultData.add(
            CategoryModel(
                id: element.id,
                categoryName: element.categoryName,
                transactionType: element.transactionType,
                status: element.status),
          );
        }
      });
    } catch (error) {
      Get.snackbar('Error', error.toString(),
          icon: const Icon(Icons.error), snackPosition: SnackPosition.TOP);
      isLoading(false);
    } finally {
      isLoading(false);
    }
  }
}
