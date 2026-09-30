import 'package:cashier_management/database/api_request.dart';
import 'package:cashier_management/models/monitoring_outlet_model.dart';
import 'package:cashier_management/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MonitoringOutletController extends GetxController {
  // ============================================================
  // DATA
  // ============================================================

  final RxList<DataTransaction> resultData = <DataTransaction>[].obs;

  // ============================================================
  // LOADING
  // ============================================================

  final RxBool isLoading = false.obs;
  final RxBool isLoadingOutlet = false.obs;

  // ============================================================
  // TOTAL
  // ============================================================

  final RxInt totalIncome = 0.obs;
  final RxInt totalExpense = 0.obs;
  final RxInt totalBalance = 0.obs;

  // ============================================================
  // OUTLET
  // ============================================================

  final RxList<Map<String, dynamic>> listOutlet = <Map<String, dynamic>>[].obs;

  final RxString namaKios = ''.obs;

  final RxInt idKios = 0.obs;
  final RxInt idCabangKios = 0.obs;

  // ============================================================
  // FILTER
  // ============================================================

  final Rx<DateTime> monthDate = DateTime.now().obs;

  final RxString monthYear =
      '${DateTime.now().month}-${DateTime.now().year}'.obs;

  final Rx<DateTime> startDate = DateTime.now().obs;
  final Rx<DateTime> endDate = DateTime.now().obs;

  final RxString filterBy = 'bulan'.obs;

  // ============================================================
  // INIT
  // ============================================================

  @override
  void onInit() {
    super.onInit();
    setKiosForTransaksiPerOutlet();
  }

  // ============================================================
  // SET KIOS
  // ============================================================

  Future<void> setKiosForTransaksiPerOutlet() async {
    final prefs = await SharedPreferences.getInstance();

    idKios.value = prefs.getInt('id_kios') ?? 0;
    namaKios.value = prefs.getString('kios') ?? '';

    filterBy.value = 'bulan';

    monthDate.value = DateTime.now();

    monthYear.value = '${monthDate.value.month}-${monthDate.value.year}';

    await getDataListOutlet();

    if (listOutlet.isNotEmpty) {
      idCabangKios.value = listOutlet.first['value'] as int? ?? 0;
    }

    await getDataByFilter();
  }

  // ============================================================
  // SET DETAIL
  // ============================================================

  Future<void> setKiosForDetailTransaksi(
    int kiosId,
    int cabangKiosId,
    String transactionDate,
  ) async {
    filterBy.value = 'tanggal';

    idKios.value = kiosId;
    idCabangKios.value = cabangKiosId;

    final date = DateTime.parse(transactionDate);

    startDate.value = date;
    endDate.value = date;

    await getDataListOutlet();
    await getDataByFilter();
  }

  // ============================================================
  // CHANGE OUTLET
  // ============================================================

  Future<void> changeOutlet() async {
    final prefs = await SharedPreferences.getInstance();

    idKios.value = prefs.getInt('id_kios') ?? 0;
    namaKios.value = prefs.getString('kios') ?? '';

    await getDataListOutlet();

    if (listOutlet.isNotEmpty &&
        !listOutlet.any(
          (element) => element['value'] == idCabangKios.value,
        )) {
      idCabangKios.value = listOutlet.first['value'] as int? ?? 0;
    }

    await getDataByFilter();
  }

  // ============================================================
  // LIST OUTLET
  // ============================================================

  Future<void> getDataListOutlet() async {
    try {
      isLoadingOutlet.value = true;

      final rawFormat = {
        'id_kios': idKios.value,
      };

      final result = await RemoteDataSource.getListCabangKios(rawFormat);

      if (result != null) {
        listOutlet.assignAll(
          result.map(
            (category) => {
              'value': category.id,
              'nama': category.cabang ?? '-',
            },
          ),
        );
      }
    } catch (error) {
      _showError(error);
    } finally {
      isLoadingOutlet.value = false;
    }
  }

  // ============================================================
  // GET DATA
  // ============================================================

  Future<void> getDataByFilter() async {
    try {
      isLoading.value = true;

      MonitoringOutletModel? result;

      if (filterBy.value == 'bulan') {
        final rawFormat = {
          'monthYear': monthYear.value,
          'id_kios': idKios.value,
          'id_cabang': idCabangKios.value,
        };

        result = await RemoteDataSource.monitoringByMonth(rawFormat);
      } else {
        final rawFormat = {
          'startDate': _formatDate(startDate.value),
          'endDate': _formatDate(endDate.value),
          'id_kios': idKios.value,
          'id_cabang': idCabangKios.value,
        };

        result = await RemoteDataSource.monitoringByDateRange(rawFormat);
      }

      if (result != null) {
        totalIncome.value = result.income ?? 0;
        totalExpense.value = result.expense ?? 0;

        totalBalance.value = totalIncome.value - totalExpense.value;

        resultData.assignAll(result.data ?? []);
      } else {
        _clearResult();
      }
    } catch (error) {
      _showError(error);
    } finally {
      isLoading.value = false;
    }
  }

  // ============================================================
  // MONTH
  // ============================================================

  Future<void> goToNextMonth() async {
    monthDate.value = DateTime(
      monthDate.value.year,
      monthDate.value.month + 1,
    );

    monthYear.value = '${monthDate.value.month}-${monthDate.value.year}';

    await getDataByFilter();
  }

  Future<void> goToPreviousMonth() async {
    monthDate.value = DateTime(
      monthDate.value.year,
      monthDate.value.month - 1,
    );

    monthYear.value = '${monthDate.value.month}-${monthDate.value.year}';

    await getDataByFilter();
  }

  // ============================================================
  // DATE RANGE
  // ============================================================

  Future<void> showDialogDateRangePicker() async {
    final pickedDate = await showDateRangePicker(
      context: Get.context!,
      initialDateRange: DateTimeRange(
        start: startDate.value,
        end: endDate.value,
      ),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: MyColors.primary,
              onPrimary: Colors.white,
              outlineVariant: Colors.grey.shade200,
              outline: Colors.grey.shade300,
              secondaryContainer: MyColors.primaryLight,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      startDate.value = pickedDate.start;
      endDate.value = pickedDate.end;

      await getDataByFilter();
    }
  }

  // ============================================================
  // CHANGE FILTER
  // ============================================================

  Future<void> setFilter(String value) async {
    if (filterBy.value == value) return;

    filterBy.value = value;

    if (value == 'bulan') {
      monthDate.value = DateTime.now();

      monthYear.value = '${monthDate.value.month}-${monthDate.value.year}';
    } else {
      final now = DateTime.now();

      startDate.value = now;
      endDate.value = now;
    }

    await getDataByFilter();
  }

  // ============================================================
  // CHANGE OUTLET
  // ============================================================

  Future<void> selectOutlet(int outletId) async {
    if (idCabangKios.value == outletId) return;

    idCabangKios.value = outletId;

    await getDataByFilter();
  }

  // ============================================================
  // HELPERS
  // ============================================================

  String _formatDate(DateTime date) {
    return '${date.year}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';
  }

  void _clearResult() {
    resultData.clear();
    totalIncome.value = 0;
    totalExpense.value = 0;
    totalBalance.value = 0;
  }

  void _showError(Object error) {
    Get.snackbar(
      'Terjadi Kesalahan',
      error.toString(),
      icon: const Icon(
        Icons.error_outline_rounded,
        color: Colors.white,
      ),
      colorText: Colors.white,
      backgroundColor: MyColors.error,
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.all(12),
      borderRadius: 12,
    );
  }
}
