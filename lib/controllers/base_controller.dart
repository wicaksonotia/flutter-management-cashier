import 'package:cashier_management/database/api_request.dart';
import 'package:cashier_management/models/kios_model.dart';
import 'package:cashier_management/models/outlet_branch_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class BaseController extends GetxController {
  var isLoadingCabang = true.obs;
  var isLoadingKios = true.obs;
  var resultDataKios = <KiosModel>[].obs;
  var resultDataCabang = <DataListOutletBranch>[].obs;
  RxList<Map<String, dynamic>> listKios = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> listCabang = <Map<String, dynamic>>[].obs;
  var idOwner = 0.obs;
  var idKios = 0.obs;
  var selectedKios = 'Brand'.obs;
  var idCabang = 0.obs;
  var selectedCabang = 'Outlet'.obs;

  @override
  void onInit() async {
    super.onInit();
    final prefs = await SharedPreferences.getInstance();
    idKios.value = prefs.getInt('id_kios')!;
    selectedKios.value = prefs.getString('kios')!;
  }

  Future<void> fetchDataListKios({
    Future<void> Function()? onAfterSuccess,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      idOwner.value = prefs.getInt('id_owner')!;

      final rawFormat = {'id_owner': idOwner.value};
      final result = await RemoteDataSource.getListKios(rawFormat);

      if (result == null || result.isEmpty) {
        resultDataKios.clear();
        return;
      }

      // ✅ Assign data utama
      resultDataKios.assignAll(result);
      idKios.value = prefs.getInt('id_kios') ?? result.first.idKios!;
      selectedKios.value = prefs.getString('kios') ?? result.first.kios!;
      // idKios.value = result.first.idKios!;
      // selectedKios.value = result.first.kios!;

      // ✅ Bentuk list dropdown
      listKios.assignAll(result.map((e) => {
            'value': e.idKios,
            'nama': e.kios!,
          }));

      // ✅ Jalankan callback opsional (jika dikirim)
      if (onAfterSuccess != null) {
        await onAfterSuccess();
      }
    } catch (e, stack) {
      debugPrint("Error fetchDataListKios: $e\n$stack");
    } finally {
      isLoadingKios(false);
    }
  }

  Future<void> fetchDataListCabang({
    Future<void> Function()? onAfterSuccess,
  }) async {
    try {
      var rawFormat = {'id_kios': idKios.value};
      var result = await RemoteDataSource.getListCabangKios(rawFormat);
      if (result == null || result.isEmpty) {
        resultDataCabang.clear();
        return;
      }
      // ✅ Assign data utama
      resultDataCabang.assignAll(result);
      idCabang.value = result.first.id!;
      selectedCabang.value = result.first.cabang!;
      // ✅ Bentuk list dropdown
      listCabang.assignAll(result.map((category) => {
            'value': category.id,
            'nama': category.cabang!,
          }));
      // ✅ Jalankan callback opsional (jika dikirim)
      if (onAfterSuccess != null) {
        await onAfterSuccess();
      }
    } catch (e, stack) {
      debugPrint("Error fetchDataListCabang: $e\n$stack");
    } finally {
      isLoadingCabang(false);
    }
  }
}
