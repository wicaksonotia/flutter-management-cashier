import 'package:cashier_management/database/api_request.dart';
import 'package:cashier_management/models/kios_model.dart';
import 'package:cashier_management/models/outlet_branch_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class BaseController extends GetxController {
  // ==========================================================
  // LOADING
  // ==========================================================

  final isLoadingCabang = true.obs;
  final isLoadingKios = true.obs;

  // ==========================================================
  // DATA
  // ==========================================================

  final resultDataKios = <KiosModel>[].obs;
  final resultDataCabang = <DataListOutletBranch>[].obs;

  final listKios = <Map<String, dynamic>>[].obs;

  final listCabang = <Map<String, dynamic>>[].obs;

  // ==========================================================
  // ACTIVE CONTEXT
  // ==========================================================

  final idOwner = 0.obs;

  final idKios = 0.obs;

  final selectedKios = 'Brand'.obs;

  final idCabang = 0.obs;

  final selectedCabang = 'Outlet'.obs;

  // ==========================================================
  // INITIALIZATION
  // ==========================================================

  @override
  void onInit() {
    super.onInit();

    initializeBaseController();
  }

  /// Load active brand dari SharedPreferences.
  ///
  /// Method ini sengaja dibuat terpisah dari onInit()
  /// karena SharedPreferences bersifat async.
  Future<void> initializeBaseController() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      idOwner.value = prefs.getInt('id_owner') ?? 0;

      idKios.value = prefs.getInt('id_kios') ?? 0;

      selectedKios.value = prefs.getString('kios') ?? 'Brand';

      debugPrint(
        '[BASE] initialize '
        'idOwner=${idOwner.value}, '
        'idKios=${idKios.value}, '
        'kios=${selectedKios.value}',
      );
    } catch (e, stack) {
      debugPrint(
        '[BASE] initialize error: $e\n$stack',
      );
    }
  }

  // ==========================================================
  // FETCH BRAND / KIOS
  // ==========================================================

  Future<void> fetchDataListKios({
    Future<void> Function()? onAfterSuccess,
  }) async {
    try {
      isLoadingKios(true);

      final prefs = await SharedPreferences.getInstance();

      idOwner.value = prefs.getInt('id_owner') ?? 0;

      if (idOwner.value <= 0) {
        resultDataKios.clear();
        return;
      }

      final rawFormat = {
        'id_owner': idOwner.value,
      };

      final result = await RemoteDataSource.getListKios(
        rawFormat,
      );

      if (result == null || result.isEmpty) {
        resultDataKios.clear();
        return;
      }

      // ======================================================
      // DATA BRAND
      // ======================================================

      resultDataKios.assignAll(result);

      // ======================================================
      // ACTIVE BRAND
      // ======================================================

      idKios.value = prefs.getInt('id_kios') ?? result.first.idKios!;

      selectedKios.value = prefs.getString('kios') ?? result.first.kios!;

      // ======================================================
      // DROPDOWN BRAND
      // ======================================================

      listKios.assignAll(
        result.map(
          (e) => {
            'value': e.idKios,
            'nama': e.kios ?? '-',
          },
        ),
      );

      // ======================================================
      // CALLBACK
      // ======================================================

      if (onAfterSuccess != null) {
        await onAfterSuccess();
      }
    } catch (e, stack) {
      debugPrint(
        '[BASE] fetchDataListKios error: '
        '$e\n$stack',
      );
    } finally {
      isLoadingKios(false);
    }
  }

  // ==========================================================
  // FETCH OUTLET / CABANG
  // ==========================================================

  Future<void> fetchDataListCabang({
    Future<void> Function()? onAfterSuccess,
  }) async {
    try {
      isLoadingCabang(true);

      if (idKios.value <= 0) {
        resultDataCabang.clear();
        return;
      }

      final rawFormat = {
        'id_kios': idKios.value,
      };

      final result = await RemoteDataSource.getListCabangKios(
        rawFormat,
      );

      if (result == null || result.isEmpty) {
        resultDataCabang.clear();
        return;
      }

      // ======================================================
      // DATA CABANG
      // ======================================================

      resultDataCabang.assignAll(result);

      // ======================================================
      // ACTIVE CABANG
      // ======================================================

      idCabang.value = result.first.id!;

      selectedCabang.value = result.first.cabang!;

      // ======================================================
      // DROPDOWN CABANG
      // ======================================================

      listCabang.assignAll(
        result.map(
          (category) => {
            'value': category.id,
            'nama': category.cabang ?? '-',
          },
        ),
      );

      // ======================================================
      // CALLBACK
      // ======================================================

      if (onAfterSuccess != null) {
        await onAfterSuccess();
      }
    } catch (e, stack) {
      debugPrint(
        '[BASE] fetchDataListCabang error: '
        '$e\n$stack',
      );
    } finally {
      isLoadingCabang(false);
    }
  }
}
