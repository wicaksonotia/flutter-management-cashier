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
          categoryName: nameController.text, categoryType: tipeContoller.value);
      var resultSave = await RemoteDataSource.saveCategory(model.toJson());
      if (resultSave) {
        // NOTIF SAVE SUCCESS
        Get.back();
        Get.snackbar('Notification', 'Data saved successfully',
            icon: const Icon(Icons.check), snackPosition: SnackPosition.TOP);
        nameController.clear();
        getData(tags);
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
    Get.bottomSheet(
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(5)),
      ),
      Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Confirmation",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Gap(10),
            const Text("Are you sure you want to delete this category?"),
            const Gap(20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Get.back();
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: const BorderSide(color: MyColors.green),
                    ),
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    textStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  child: const Text(
                    'No',
                    style: TextStyle(color: MyColors.green),
                  ),
                ),
                const Gap(10),
                ElevatedButton(
                  onPressed: () async {
                    var resultUpdate =
                        await RemoteDataSource.deleteCategory(id);
                    if (resultUpdate) {
                      Get.back();
                      Get.snackbar('Notification', 'Data deleted successfully',
                          icon: const Icon(Icons.check),
                          snackPosition: SnackPosition.TOP);
                      getData(tags);
                    } else {
                      Get.snackbar('Notification', 'Failed to delete data',
                          icon: const Icon(Icons.error),
                          snackPosition: SnackPosition.TOP);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: MyColors.green,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    textStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  child: const Text(
                    'Yes',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
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
        getData(tags);
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
    Get.bottomSheet(
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(5)),
      ),
      Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
                labelText: 'Category Name',
              ),
            ),
            const Gap(20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Get.back();
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: const BorderSide(color: MyColors.green),
                    ),
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    minimumSize: const Size(100, 40), // Set width and height
                    textStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  child: const Text(
                    'CANCEL',
                    style: TextStyle(color: MyColors.green),
                  ),
                ),
                const Gap(10),
                ElevatedButton(
                  onPressed: () async {
                    updateCategory(id);
                    Get.back();
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: MyColors.green,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    minimumSize: const Size(100, 40), // Set width and height
                    textStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  child: const Text(
                    'SAVE',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void updateCategoryStatus(int id, bool status) async {
    Get.bottomSheet(
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(5)),
      ),
      Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Confirmation",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Gap(10),
            RichText(
              text: TextSpan(
                text: 'Are you sure you want to ',
                style: const TextStyle(color: Colors.black, fontSize: 12),
                children: <TextSpan>[
                  TextSpan(
                    text: status ? 'inactivate' : 'activate',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.red),
                  ),
                  const TextSpan(text: ' this category status?'),
                ],
              ),
            ),
            const Gap(20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Get.back();
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: const BorderSide(color: MyColors.green),
                    ),
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    minimumSize: const Size(100, 40), // Set width and height
                    textStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  child: const Text(
                    'NO',
                    style: TextStyle(color: MyColors.green),
                  ),
                ),
                const Gap(10),
                ElevatedButton(
                  onPressed: () async {
                    var resultUpdate =
                        await RemoteDataSource.updateStatusCategory(id, status);
                    if (resultUpdate) {
                      // NOTIF UPDATE SUCCESS
                      Get.back();
                      Get.snackbar('Notification', 'Data updated successfully',
                          icon: const Icon(Icons.check),
                          snackPosition: SnackPosition.TOP);
                      getData(tags);
                    } else {
                      // NOTIF UPDATE FAILED
                      Get.snackbar('Notification', 'Failed to update data',
                          icon: const Icon(Icons.error),
                          snackPosition: SnackPosition.TOP);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: MyColors.green,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    minimumSize: const Size(100, 40), // Set width and height
                    textStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  child: const Text(
                    'YES',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
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
