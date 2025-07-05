import 'package:cashier_management/controllers/history_controller.dart';
import 'package:cashier_management/controllers/kios_controller.dart';
import 'package:cashier_management/controllers/monitoring_outlet_controller.dart';
import 'package:cashier_management/controllers/total_per_type_controller.dart';
import 'package:cashier_management/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChangeOutletPage extends StatefulWidget {
  const ChangeOutletPage({super.key});

  @override
  State<ChangeOutletPage> createState() => _ChangeOutletPageState();
}

class _ChangeOutletPageState extends State<ChangeOutletPage> {
  final KiosController kiosController = Get.put(KiosController());
  final TotalPerTypeController totalPerTypeController =
      Get.put(TotalPerTypeController());
  final HistoryController historyController = Get.put(HistoryController());
  final MonitoringOutletController monitoringOutletController =
      Get.put(MonitoringOutletController());

  @override
  void initState() {
    super.initState();
    kiosController.fetchDataListKios();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: .3,
      maxChildSize: 0.9,
      minChildSize: .2,
      builder: (context, scrollController) {
        return Obx(() {
          if (kiosController.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 8.0,
            ),
            child: GridView.builder(
              controller: scrollController,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount:
                    2, // You can adjust the number of columns as needed
                childAspectRatio: 1.0, // Adjust for desired tile shape
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: kiosController.listKios.length,
              itemBuilder: (context, index) {
                final outlet = kiosController.listKios[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 8,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: MyColors.notionBgPurple,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Stack(
                      children: [
                        // Positioned.fill(
                        //   child: ClipRRect(
                        //     borderRadius: BorderRadius.circular(8),
                        //     child: Image.asset(
                        //       'assets/es_jeruk.png',
                        //       fit: BoxFit.cover,
                        //     ),
                        //   ),
                        // ),
                        Positioned(
                          left: 8,
                          top: 8,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            child: Text(
                              outlet.kios!,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 8,
                          right: 8,
                          child: Obx(
                            () => Icon(
                              Icons.check_circle,
                              color:
                                  (outlet.idKios == kiosController.idKios.value)
                                      ? Colors.lightGreen
                                      : Colors.grey.shade300,
                            ),
                          ),
                        ),
                        Positioned.fill(
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                Get.back();
                                //HOME
                                kiosController.idKios.value = outlet.idKios!;
                                kiosController.namaKios.value =
                                    outlet.kios ?? '';
                                kiosController.changeBranchOutlet();
                                totalPerTypeController.getTotalBranchSaldo();
                                totalPerTypeController.getTotalPerMonth();

                                // RIWAYAT TRANSAKSI
                                historyController.changeBranchOutlet();

                                // MONITORING OUTLET
                                monitoringOutletController.changeBranchOutlet();
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        });
      },
    );
  }
}
