import 'package:cashier_management/controllers/cabang_controller.dart';
import 'package:cashier_management/controllers/kios_controller.dart';
import 'package:cashier_management/routes.dart';
import 'package:cashier_management/utils/colors.dart';
import 'package:cashier_management/utils/sizes.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class AddBranchPage extends StatefulWidget {
  const AddBranchPage({super.key});

  @override
  State<AddBranchPage> createState() => _AddBranchPageState();
}

class _AddBranchPageState extends State<AddBranchPage> {
  final CabangController _cabangController = Get.put(CabangController());
  final KiosController _kiosController = Get.put(KiosController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Get.toNamed(RouterClass.branch);
          },
        ),
        title: RichText(
          text: TextSpan(
            text: 'Add ',
            style: const TextStyle(
              fontSize: MySizes.fontSizeHeader,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            children: <TextSpan>[
              TextSpan(
                text: '${_cabangController.headerNamaKios}',
                style: const TextStyle(
                  fontSize: MySizes.fontSizeHeader,
                  fontWeight: FontWeight.bold,
                  color: MyColors.primary,
                ),
              ),
              const TextSpan(
                text: ' Outlet',
                style: TextStyle(
                  fontSize: MySizes.fontSizeHeader,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: Container(
        color: Colors.grey.shade50,
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        child: Column(
          children: [
            TextFormField(
              controller: _cabangController.kodeCabang,
              decoration: InputDecoration(
                labelText: 'Outlet Code *',
                floatingLabelStyle: const TextStyle(
                  color: MyColors.primary,
                ),
                hintText: 'Outlet Code *',
                hintStyle: TextStyle(
                  color: Colors.grey.shade300,
                ),
                border: const OutlineInputBorder(),
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
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const Gap(10),
            TextFormField(
              controller: _cabangController.namaCabang,
              decoration: InputDecoration(
                labelText: 'Outlet Name *',
                floatingLabelStyle: const TextStyle(
                  color: MyColors.primary,
                ),
                hintText: 'Outlet Name *',
                hintStyle: TextStyle(
                  color: Colors.grey.shade300,
                ),
                border: const OutlineInputBorder(),
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
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const Gap(10),
            TextFormField(
              controller: _cabangController.alamatCabang,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Address',
                floatingLabelStyle: const TextStyle(
                  color: MyColors.primary,
                ),
                border: const OutlineInputBorder(),
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
                filled: true,
                fillColor: Colors.white,
                hintText: 'Address',
                hintStyle: TextStyle(
                  color: Colors.grey.shade300,
                ),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  _cabangController.saveBranch();
                  _kiosController.fetchDataListKiosFinancial();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: MyColors.primary, // Button color
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                child: const Text(
                  'Save',
                  style: TextStyle(
                    fontSize: MySizes.fontSizeMd,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
