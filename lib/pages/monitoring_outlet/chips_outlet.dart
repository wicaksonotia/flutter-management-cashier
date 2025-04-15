import 'package:chips_choice/chips_choice.dart';
import 'package:financial_apps/controllers/monitoring_outlet_controller.dart';
import 'package:financial_apps/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChipsOutlet extends StatefulWidget {
  const ChipsOutlet({super.key});

  @override
  _ChipsOutletState createState() => _ChipsOutletState();
}

class _ChipsOutletState extends State<ChipsOutlet> {
  final MonitoringOutletController _monitoringOutletController =
      Get.find<MonitoringOutletController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return ChipsChoice.single(
        wrapped: true,
        padding: EdgeInsets.zero,
        value: _monitoringOutletController.kios,
        onChanged: (val) => setState(() {
          _monitoringOutletController.kios.value = val as String;
          _monitoringOutletController.getDataByFilter();
        }),
        choiceItems: C2Choice.listFrom<String, Map<String, String>>(
          source: _monitoringOutletController.listOutlet,
          value: (i, v) => v['value']!,
          label: (i, v) => v['nama']!,
        ),
        choiceCheckmark: false,
        choiceStyle: C2ChipStyle.filled(
          borderRadius: BorderRadius.circular(25),
          color: Colors.grey.shade100,
          selectedStyle: const C2ChipStyle(
            backgroundColor: MyColors.green,
            borderRadius: BorderRadius.all(
              Radius.circular(25),
            ),
          ),
        ),
      );
    });
  }
}
