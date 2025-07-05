import 'package:cashier_management/controllers/kios_controller.dart';
import 'package:cashier_management/pages/change_outlet_page.dart';
import 'package:cashier_management/utils/colors.dart';
import 'package:cashier_management/utils/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    final KiosController kiosController = Get.find<KiosController>();
    return Padding(
      padding: const EdgeInsets.fromLTRB(5, 35, 15, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.menu, color: MyColors.primary),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Selamat Datang,',
                    style: TextStyle(
                      fontSize: MySizes.fontSizeSm,
                      color: Colors.black54,
                    ),
                  ),
                  Obx(() {
                    return GestureDetector(
                      onTap: () {
                        Get.back();
                        showModalBottomSheet(
                          context: context,
                          constraints: const BoxConstraints(
                            minWidth: double.infinity,
                          ),
                          builder: (context) => const ChangeOutletPage(),
                          isScrollControlled: true,
                          backgroundColor: Colors.white,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(20),
                            ),
                          ),
                        );
                      },
                      child: Row(
                        children: [
                          Text(
                            kiosController.namaKios.value,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Icon(Icons.keyboard_arrow_down_rounded,
                              color: Colors.black54),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
