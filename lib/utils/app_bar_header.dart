import 'package:financial_apps/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class AppbarHeader extends StatelessWidget {
  AppbarHeader({super.key, required this.header});
  String header;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        header,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: MyColors.primary,
      elevation: 0.0,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back,
          color: Colors.white,
        ),
        onPressed: () {
          Get.back();
        },
      ),
    );
  }
}
