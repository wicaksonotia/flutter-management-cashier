import 'package:financial_apps/pages/history/chips_sub_category.dart';
import 'package:financial_apps/utils/sizes.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class FilterReport extends StatefulWidget {
  const FilterReport({super.key});

  @override
  State<FilterReport> createState() => _FilterReportState();
}

class _FilterReportState extends State<FilterReport> {
  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: .33,
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
                  'Transaction History Filter',
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
                const ChipsSubCategory(),
                // const Gap(10),
                // SizedBox(
                //   width: double.infinity,
                //   child: ElevatedButton(
                //     style: ElevatedButton.styleFrom(
                //       backgroundColor: MyColors.green,
                //       shape: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.circular(12),
                //       ),
                //     ),
                //     onPressed: () {
                //       _historyController.setDataByFilter();
                //       Get.back();
                //     },
                //     child: const Text(
                //       'Apply Filter',
                //       style: TextStyle(color: Colors.white),
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        );
      },
    );
  }
}
