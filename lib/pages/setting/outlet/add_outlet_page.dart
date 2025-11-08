import 'dart:io';

import 'package:cashier_management/controllers/kios_controller.dart';
import 'package:cashier_management/database/api_endpoints.dart';
import 'package:cashier_management/utils/colors.dart';
import 'package:cashier_management/utils/sizes.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class AddOutletPage extends StatefulWidget {
  const AddOutletPage({super.key});

  @override
  State<AddOutletPage> createState() => _AddOutletPageState();
}

class _AddOutletPageState extends State<AddOutletPage> {
  final KiosController _kiosController = Get.put(KiosController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Get.back();
          },
        ),
        title: const Text(
          'Add Outlet',
          style: TextStyle(
              fontSize: MySizes.fontSizeHeader, fontWeight: FontWeight.bold),
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
              controller: _kiosController.kios,
              decoration: InputDecoration(
                labelText: 'Kios',
                floatingLabelStyle: const TextStyle(
                  color: MyColors.primary,
                ),
                hintText: 'Kios',
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
              controller: _kiosController.phone,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: 'Phone',
                floatingLabelStyle: const TextStyle(
                  color: MyColors.primary,
                ),
                hintText: 'Phone',
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
              controller: _kiosController.description,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Description',
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
                hintText: 'Description',
                hintStyle: TextStyle(
                  color: Colors.grey.shade300,
                ),
              ),
            ),
            const Gap(10),
            Obx(() {
              final file = _kiosController.pickedFile1.value;
              final logo = _kiosController.logo.value.trim();
              final hasLocalImage =
                  file.path.isNotEmpty && File(file.path).existsSync();

              Widget buildUploadSection() => Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        '2 MB Max. File size allowed',
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                      const SizedBox(height: 10),
                      OutlinedButton.icon(
                        onPressed: () =>
                            _kiosController.selectImage1(ImageSource.gallery),
                        icon: const Icon(Icons.upload_outlined),
                        label: const Text('Upload image'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.blue,
                          side: const BorderSide(color: Colors.blueAccent),
                        ),
                      ),
                    ],
                  );

              Widget buildImageInfo({
                required String name,
                required Widget preview,
                String? size,
              }) =>
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 14),
                            ),
                            if (size != null)
                              Text(
                                size,
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.grey),
                              ),
                            const SizedBox(height: 6),
                            OutlinedButton.icon(
                              onPressed: () => _kiosController
                                  .selectImage1(ImageSource.gallery),
                              icon: const Icon(Icons.refresh_outlined),
                              label: const Text('Change image'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.blue,
                                side:
                                    const BorderSide(color: Colors.blueAccent),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Gap(10),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: preview,
                      ),
                    ],
                  );

              Widget content;
              if (hasLocalImage) {
                // ✅ Gambar dari file lokal
                final fileSizeMB =
                    (File(file.path).lengthSync() / (1024 * 1024))
                        .toStringAsFixed(2);
                content = buildImageInfo(
                  name: file.name,
                  size: '$fileSizeMB MB',
                  preview: Image.file(
                    File(file.path),
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                );
              } else if (logo.isNotEmpty) {
                // ✅ Gambar dari server
                content = buildImageInfo(
                  name: logo,
                  preview: Image.network(
                    '${ApiEndPoints.ipPublic}images/logo/$logo',
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 100,
                      height: 100,
                      color: Colors.grey.shade200,
                      child: const Icon(Icons.broken_image, color: Colors.grey),
                    ),
                  ),
                );
              } else {
                // ✅ Belum ada gambar sama sekali
                content = buildUploadSection();
              }

              return DottedBorder(
                options: const RectDottedBorderOptions(
                  dashPattern: [4, 5],
                  padding: EdgeInsets.all(0),
                  color: Colors.grey,
                ),
                child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    child: content),
              );
            }),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  _kiosController.saveOutlet();
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
