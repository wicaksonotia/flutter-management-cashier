import 'package:cashier_management/database/api_request.dart';
import 'package:cashier_management/models/monitoring_outlet_model.dart';
import 'package:cashier_management/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MonitoringOutletController extends GetxController {
  var resultData = <DataTransaction>[].obs;
  RxBool isLoading = false.obs;
  RxBool isLoadingOutlet = false.obs;
  RxInt totalIncome = 0.obs;
  RxInt totalExpense = 0.obs;
  RxInt totalBalance = 0.obs;
  RxList<Map<String, dynamic>> listOutlet = <Map<String, dynamic>>[].obs;
  var monthDate = DateTime.now().obs;
  var monthYear = '${DateTime.now().month}-${DateTime.now().year}'.obs;
  var startDate = DateTime.now().obs;
  var endDate = DateTime.now().obs;
  var filterBy = 'bulan'.obs;
  var namaKios = ''.obs;
  var idKios = 0.obs;
  var idCabangKios = 0.obs;

  void setKiosForTransaksiPerOutlet() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    idKios.value = prefs.getInt('id_kios')!;
    filterBy.value = 'bulan';
    monthYear.value = '${DateTime.now().month}-${DateTime.now().year}';
    await getDataListOutlet();
    idCabangKios.value =
        listOutlet.isNotEmpty ? listOutlet.first['value'] as int : 0;
    getDataByFilter();
  }

  void setKiosForDetailTransaksi(
      int kiosId, int cabangKiosId, String transactionDate) async {
    filterBy.value = 'tanggal';
    idKios.value = kiosId;
    idCabangKios.value = cabangKiosId;
    startDate.value = DateTime.parse(transactionDate);
    endDate.value = DateTime.parse(transactionDate);
    await getDataListOutlet();
    getDataByFilter();
  }

  void changeBranchOutlet() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    idKios.value = prefs.getInt('id_kios')!;
    namaKios.value = prefs.getString('kios')!;
    await getDataListOutlet();
    getDataByFilter();
  }

  Future<void> getDataListOutlet() async {
    try {
      isLoadingOutlet(true);
      var rawFormat = {'id_kios': idKios.value};
      final result = await RemoteDataSource.getListCabangKios(rawFormat);
      if (result != null) {
        listOutlet.assignAll(result.map((category) => {
              'value': category.id,
              'nama': category.cabang!,
            }));
      }
    } catch (error) {
      Get.snackbar('Error', error.toString(),
          icon: const Icon(Icons.error), snackPosition: SnackPosition.TOP);
      isLoadingOutlet(false);
    } finally {
      isLoadingOutlet(false);
    }
  }

  void getDataByFilter() async {
    try {
      isLoading(true);
      MonitoringOutletModel? result;
      if (filterBy.value == 'bulan') {
        var rawFormat = {
          'monthYear': monthYear.value,
          'id_kios': idKios.value,
          'id_cabang': idCabangKios.value
        };
        result = await RemoteDataSource.monitoringByMonth(rawFormat);
      } else {
        var rawFormat = {
          'startDate': startDate.value.toString(),
          'endDate': endDate.value.toString(),
          'id_kios': idKios.value,
          'id_cabang': idCabangKios.value
        };
        result = await RemoteDataSource.monitoringByDateRange(rawFormat);
      }
      if (result != null && result.data != null) {
        totalIncome.value = result.income ?? 0;
        totalExpense.value = result.expense ?? 0;
        totalBalance.value = totalIncome.value - totalExpense.value;
        resultData.assignAll(result.data ?? []);
      }
    } catch (error) {
      Get.snackbar('Error', error.toString(),
          icon: const Icon(Icons.error), snackPosition: SnackPosition.TOP);
      isLoading(false);
    } finally {
      isLoading(false);
    }
  }

  /// ===================================
  /// FILTER DATE, MONTH
  /// ===================================
  void goToNextMonth() {
    monthDate.value = DateTime(monthDate.value.year, monthDate.value.month + 1);
    monthYear.value =
        "${monthDate.value.month.toString()}-${monthDate.value.year.toString()}";
    getDataByFilter();
  }

  void goToPreviousMonth() {
    monthDate.value = DateTime(monthDate.value.year, monthDate.value.month - 1);
    monthYear.value =
        "${monthDate.value.month.toString()}-${monthDate.value.year.toString()}";
    getDataByFilter();
  }

  void showDialogDateRangePicker() async {
    var pickedDate = await showDateRangePicker(
      context: Get.context!,
      initialDateRange: DateTimeRange(
        start: startDate.value,
        end: endDate.value,
      ),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: MyColors.primary,
              onPrimary: Colors.white,
              outlineVariant: Colors.grey.shade200,
              // onSurfaceVariant: MyColors.primary,
              outline: Colors.grey.shade300,
              secondaryContainer: Colors.green.shade50,
            ),
          ),
          child: child!,
        );
      },
    );
    if (pickedDate != null) {
      startDate.value = pickedDate.start;
      endDate.value = pickedDate.end;
      getDataByFilter();
    }
  }
}
