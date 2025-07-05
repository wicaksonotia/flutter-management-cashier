import 'package:cashier_management/controllers/monitoring_outlet_controller.dart';
import 'package:cashier_management/pages/monitoring_outlet/chips_outlet.dart';
import 'package:cashier_management/utils/sizes.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class FilterReport extends StatefulWidget {
  final MonitoringOutletController monitoringOutletController;
  const FilterReport(this.monitoringOutletController, {super.key});

  @override
  State<FilterReport> createState() => _FilterReportState();
}

class _FilterReportState extends State<FilterReport> {
  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: .2,
      maxChildSize: 1,
      minChildSize: .2,
      builder: (BuildContext context, ScrollController scrollController) {
        return SingleChildScrollView(
          controller: scrollController,
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Filter By Outlet',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: MySizes.fontSizeLg,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Divider(
                  color: Colors.grey.shade300,
                ),
                const Gap(10),
                ChipsOutlet(widget.monitoringOutletController),
              ],
            ),
          ),
        );
      },
    );
  }
}
