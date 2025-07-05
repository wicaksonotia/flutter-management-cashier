import 'package:chips_choice/chips_choice.dart';
import 'package:cashier_management/controllers/monitoring_outlet_controller.dart';
import 'package:cashier_management/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChipsOutlet extends StatefulWidget {
  final MonitoringOutletController monitoringOutletController;
  const ChipsOutlet(this.monitoringOutletController, {super.key});

  @override
  _ChipsOutletState createState() => _ChipsOutletState();
}

class _ChipsOutletState extends State<ChipsOutlet> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return ChipsChoice.single(
        wrapped: true,
        padding: EdgeInsets.zero,
        value: widget.monitoringOutletController.idCabangKios.value,
        onChanged: (val) => setState(() {
          widget.monitoringOutletController.idCabangKios.value = val;
          widget.monitoringOutletController.getDataByFilter();
        }),
        choiceItems: C2Choice.listFrom<int, Map<String, dynamic>>(
          source: widget.monitoringOutletController.listOutlet,
          value: (i, v) => v['value']!,
          label: (i, v) => v['nama']!,
        ),
        choiceCheckmark: false,
        choiceStyle: C2ChipStyle.filled(
          borderRadius: BorderRadius.circular(25),
          color: Colors.grey.shade100,
          selectedStyle: const C2ChipStyle(
            backgroundColor: MyColors.primary,
            borderRadius: BorderRadius.all(
              Radius.circular(25),
            ),
          ),
        ),
      );
    });
  }
}
