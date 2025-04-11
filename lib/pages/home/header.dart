import 'package:financial_apps/controllers/total_per_type_controller.dart';
import 'package:financial_apps/utils/colors.dart';
import 'package:financial_apps/utils/currency.dart';
import 'package:financial_apps/utils/routes.dart';
import 'package:financial_apps/utils/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    final TotalPerTypeController _totalPerTypeController =
        Get.find<TotalPerTypeController>();

    return Container(
      decoration: const BoxDecoration(color: MyColors.green
          // image: DecorationImage(
          //     fit: BoxFit.fill, image: AssetImage('assets/background.png')),
          ),
      child: Column(children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(30, 60, 20, 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // const CircleAvatar(
              //   minRadius: 25,
              //   backgroundImage: AssetImage('assets/profileImage.webp'),
              // ),
              Column(
                children: [
                  const Text(
                    "Total Saldo",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  Obx(
                    () => Text(
                      CurrencyFormat.convertToIdr(
                          _totalPerTypeController.resultTotal.value, 0),
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                        fontSize: MySizes.fontSizeXl,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              ElevatedButton.icon(
                icon: const Icon(
                  Icons.addchart_outlined,
                  size: 20,
                ),
                onPressed: (() => {Get.toNamed(RouterClass.addtransaction)}),
                label: const Text(
                  "Add Transaction",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white, // Background color
                  foregroundColor: MyColors.green, // Text colo
                  // shape: new RoundedRectangleBorder(
                  //   borderRadius: new BorderRadius.circular(20.0),
                  // ),
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
