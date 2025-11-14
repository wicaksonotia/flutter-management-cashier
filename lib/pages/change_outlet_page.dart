import 'package:cashier_management/controllers/history_controller.dart';
import 'package:cashier_management/controllers/kios_controller.dart';
import 'package:cashier_management/controllers/monitoring_outlet_controller.dart';
import 'package:cashier_management/controllers/total_per_type_controller.dart';
import 'package:cashier_management/database/api_endpoints.dart';
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
          if (kiosController.isLoadingKios.value) {
            return const Center(child: CircularProgressIndicator());
          }
          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 8.0,
            ),
            child: ListView.builder(
              controller: scrollController,
              itemCount: kiosController.resultDataKios.length,
              itemBuilder: (context, index) {
                final kios = kiosController.resultDataKios[index];
                return Card(
                  color: Colors.white,
                  child: ListTile(
                    title: Text(
                      kios.kios!,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      kios.keterangan!,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: kios.logo != null
                          ? Image.network(
                              '${ApiEndPoints.ipPublic}images/logo/${kios.logo}',
                              width: 80,
                              height: 80,
                              fit: BoxFit.contain,
                            )
                          : Image.asset('assets/no_image.jpg',
                              width: 80, height: 80, fit: BoxFit.contain),
                    ),
                    trailing: Obx(
                      () {
                        if (kiosController.idKios.value == kios.idKios) {
                          return const Icon(
                            Icons.check,
                            color: MyColors.primary,
                          );
                        } else {
                          return const Icon(
                            Icons.check,
                            color: Colors.transparent,
                          );
                        }
                      },
                    ),
                    onTap: () {
                      //HOME
                      kiosController.idKios.value = kios.idKios!;
                      kiosController.selectedKios.value = kios.kios ?? '';
                      kiosController.changeOutlet();
                      totalPerTypeController.getTotalBranchSaldo();
                      totalPerTypeController.getTotalPerMonth();

                      // RIWAYAT TRANSAKSI
                      historyController.changeOutlet();

                      // MONITORING OUTLET
                      monitoringOutletController.changeOutlet();
                      Get.back();
                    },
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
