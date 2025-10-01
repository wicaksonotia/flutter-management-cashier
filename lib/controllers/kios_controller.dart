import 'package:cashier_management/database/api_request.dart';
import 'package:cashier_management/models/kios_model.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class KiosController extends GetxController {
  var listKios = <KiosModel>[].obs;
  var listKiosFinancial = <KiosModel>[].obs;
  var isLoading = true.obs;
  var isLoadingFinancialKios = true.obs;
  var idOwner = 0.obs;
  var idKios = 0.obs;
  var namaKios = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchDataListKios();
  }

  void fetchDataListKios() async {
    try {
      isLoading(false);
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      idOwner.value = prefs.getInt('id_owner')!;
      idKios.value = prefs.getInt('id_kios')!;
      namaKios.value = prefs.getString('kios') ?? '';
      var rawFormat = {'id_owner': idOwner.value};
      var result = await RemoteDataSource.getListKios(rawFormat);
      if (result != null) {
        listKios.assignAll(result);
        // final activeKios =
        //     result.where((kios) => kios.isActive == true).toList();
        // listKios.assignAll(activeKios);
      }
    } finally {
      isLoading(false);
    }
  }

  void fetchDataListKiosFinancial() async {
    try {
      isLoadingFinancialKios(false);
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var rawFormat = {'id_owner': prefs.getInt('id_owner')!};
      var result = await RemoteDataSource.getListKiosAndDetail(rawFormat);
      if (result != null) {
        listKiosFinancial.assignAll(result);
      }
    } finally {
      isLoadingFinancialKios(false);
    }
  }

  void changeBranchOutlet() {
    // final SharedPreferences prefs = await SharedPreferences.getInstance();
    // await prefs.setInt('id_kios', idKios.value);
    // await prefs.setString('kios', namaKios.value);
    SharedPreferences.getInstance().then((prefs) {
      prefs.setInt('id_kios', idKios.value);
      prefs.setString('kios', namaKios.value);
    });
  }
}
