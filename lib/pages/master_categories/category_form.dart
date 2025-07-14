import 'package:cashier_management/controllers/category_controller.dart';
import 'package:cashier_management/utils/colors.dart';
import 'package:cashier_management/utils/sizes.dart';
import 'package:flutter/material.dart';
// import 'package:cashier_management/utils/lists.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
// import 'package:toggle_switch/toggle_switch.dart';

class CategoryForm extends StatefulWidget {
  const CategoryForm({super.key});

  @override
  State<CategoryForm> createState() => _CategoryFormState();
}

class _CategoryFormState extends State<CategoryForm> {
  final CategoryController categoryController = Get.put(CategoryController());

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tambah Kategori',
              style: TextStyle(
                fontSize: MySizes.fontSizeLg,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Gap(10),
            Divider(
              color: Colors.grey.shade300,
              thickness: .5,
              height: 1,
            ),
            const Gap(15),
            // Obx(
            //   () => ToggleSwitch(
            //     minWidth: 90.0,
            //     initialLabelIndex:
            //         categoryController.tipeContoller.value == "PEMASUKAN"
            //             ? 0
            //             : 1,
            //     cornerRadius: 5.0,
            //     activeFgColor: Colors.white,
            //     inactiveBgColor: Colors.grey,
            //     inactiveFgColor: Colors.white,
            //     totalSwitches: 2,
            //     labels: const ['Pengeluaran', 'Pemasukan'],
            //     icons: const [Icons.download, Icons.upload],
            //     activeBgColors: const [
            //       [MyColors.red],
            //       [MyColors.primary],
            //     ],
            //     onToggle: (index) {
            //       if (index == 0) {
            //         categoryController.tipeContoller.value = "PENGELUARAN";
            //       } else {
            //         categoryController.tipeContoller.value = "PEMASUKAN";
            //       }
            //     },
            //   ),
            // ),
            // const Gap(15),
            TextFormField(
              controller: categoryController.nameController,
              decoration: InputDecoration(
                focusColor: MyColors.primary,
                fillColor: Colors.white,
                filled: true,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(
                    color: Colors.grey.shade300,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(
                    color: Colors.grey.shade300,
                  ),
                ),
                hintText: "Nama Kategori",
                hintStyle: TextStyle(
                  color: Colors.grey.shade300,
                ),
                border: const OutlineInputBorder(
                  borderSide: BorderSide(color: MyColors.primary),
                ),
                labelText: "Nama Kategori",
                floatingLabelStyle: const TextStyle(
                  color: MyColors.primary,
                ),
              ),
              autocorrect: false,
              onChanged: (value) {
                categoryController.nameController.text = value.toUpperCase();
                categoryController.nameController.selection =
                    TextSelection.fromPosition(
                  TextPosition(
                      offset: categoryController.nameController.text.length),
                );
              },
            ),
            const Gap(10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  categoryController.insertCategory();
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  backgroundColor: MyColors.primary,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  minimumSize:
                      const Size(double.infinity, 40), // Set width and height
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
            ),
          ],
        ),
      ),
    );
  }
}
