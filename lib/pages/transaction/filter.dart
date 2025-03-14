import 'package:financial_apps/controllers/history_controller.dart';
import 'package:financial_apps/utils/colors.dart';
import 'package:financial_apps/utils/sizes.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class FilterReport extends StatefulWidget {
  const FilterReport({super.key});

  @override
  State<FilterReport> createState() => _FilterReportState();
}

class _FilterReportState extends State<FilterReport> {
  final HistoryController _historyController = Get.find<HistoryController>();

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: .36,
      maxChildSize: .5,
      minChildSize: .2,
      builder: (context, scrollController) {
        return Padding(
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
              Row(
                children: [
                  Obx(() => _historyController.checkSingleDate.value
                      ? const Icon(
                          Icons.check_circle,
                          color: Colors.green,
                        )
                      : const SizedBox.shrink()),
                  const Gap(5),
                  const Text(
                    'Filter by date',
                    style: TextStyle(
                      fontSize: MySizes.fontSizeMd,
                    ),
                  ),
                ],
              ),
              const Gap(10),
              SizedBox(
                width: MediaQuery.of(context).size.width * .44,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    side: BorderSide(color: Colors.grey.shade300),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  onPressed: () {
                    _historyController.checkSingleDate.value = true;
                    _historyController.textStartDate.value = '';
                    _historyController.textEndDate.value = '';
                    _historyController.chooseDate('single');
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Obx(() => Text(
                            _historyController.textSingleDate.isNotEmpty
                                ? _historyController.textSingleDate.value
                                : 'Date',
                            style: const TextStyle(
                              fontSize: MySizes.fontSizeMd,
                              color: Colors.black54,
                            ),
                          )),
                      const Icon(Icons.calendar_today, color: Colors.black54),
                    ],
                  ),
                ),
              ),
              const Gap(10),
              Row(
                children: [
                  Obx(() => !_historyController.checkSingleDate.value
                      ? const Icon(
                          Icons.check_circle,
                          color: Colors.green,
                        )
                      : const SizedBox.shrink()),
                  const Gap(5),
                  const Text(
                    'Filter by Range Date',
                    style: TextStyle(
                      fontSize: MySizes.fontSizeMd,
                    ),
                  ),
                ],
              ),
              const Gap(10),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: SizedBox(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          side: BorderSide(color: Colors.grey.shade300),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        onPressed: () {
                          _historyController.checkSingleDate.value = false;
                          _historyController.textSingleDate.value = '';
                          _historyController.chooseDate('start');
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Obx(() => Text(
                                  _historyController.textStartDate.isNotEmpty
                                      ? _historyController.textStartDate.value
                                      : 'Start date',
                                  style: const TextStyle(
                                    fontSize: MySizes.fontSizeMd,
                                    color: Colors.black54,
                                  ),
                                )),
                            const Icon(Icons.calendar_today,
                                color: Colors.black54),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const Gap(10),
                  Expanded(
                    child: SizedBox(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          side: BorderSide(color: Colors.grey.shade300),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        onPressed: () {
                          _historyController.checkSingleDate.value = false;
                          _historyController.textSingleDate.value = '';
                          _historyController.chooseDate('end');
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Obx(() => Text(
                                  _historyController.textEndDate.isNotEmpty
                                      ? _historyController.textEndDate.value
                                      : 'End date',
                                  style: const TextStyle(
                                    fontSize: MySizes.fontSizeMd,
                                    color: Colors.black54,
                                  ),
                                )),
                            const Icon(Icons.calendar_today,
                                color: Colors.black54),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const Gap(10),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MyColors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    Get.back();
                    _historyController.getDataByDate();
                  },
                  child: const Text(
                    'Apply Filter',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
