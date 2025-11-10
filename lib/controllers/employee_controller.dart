import 'package:cashier_management/database/api_request.dart';
import 'package:cashier_management/models/employee_model.dart';
import 'package:cashier_management/models/kios_model.dart';
import 'package:cashier_management/models/outlet_branch_model.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EmployeeController extends GetxController {
  var resultDataEmployee = <DataEmployee>[].obs;
  var resultDataKios = <KiosModel>[].obs;
  var resultDataCabang = <DataListOutletBranch>[].obs;
  RxList<Map<String, dynamic>> listKios = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> listCabang = <Map<String, dynamic>>[].obs;
  var isLoadingEmployee = true.obs;
  var isLoadingKios = true.obs;
  var isLoadingCabang = true.obs;
  var idKios = 0.obs;
  var selectedKios = 'Kios'.obs;
  var idCabang = 0.obs;
  var selectedCabang = 'Cabang'.obs;

  @override
  void onInit() {
    super.onInit();
    fetchDataListKios();
  }

  void fetchDataListEmployee() async {
    try {
      var rawFormat = {
        'id_cabang': idCabang.value,
      };
      var result = await RemoteDataSource.getListEmployee(rawFormat);
      if (result != null) {
        resultDataEmployee.assignAll(result);
      }
    } finally {
      isLoadingEmployee(false);
    }
  }

  void fetchDataListKios() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var rawFormat = {'id_owner': prefs.getInt('id_owner')!};
      var result = await RemoteDataSource.getListKios(rawFormat);
      if (result != null) {
        resultDataKios.assignAll(result);
        idKios.value = result.first.idKios!;
        selectedKios.value = result.first.kios!;
        listKios.assignAll(result.map((category) => {
              'value': category.idKios,
              'nama': category.kios!,
            }));
        fetchDataListCabang();
      }
    } finally {
      isLoadingKios(false);
    }
  }

  void fetchDataListCabang() async {
    try {
      var rawFormat = {'id_kios': idKios.value};
      var result = await RemoteDataSource.getListCabangKios(rawFormat);
      if (result != null) {
        resultDataCabang.assignAll(result);
        idCabang.value = result.first.id!;
        selectedCabang.value = result.first.cabang!;
        listCabang.assignAll(result.map((category) => {
              'value': category.id,
              'nama': category.cabang!,
            }));
        fetchDataListEmployee();
      }
    } finally {
      isLoadingCabang(false);
    }
  }
}
