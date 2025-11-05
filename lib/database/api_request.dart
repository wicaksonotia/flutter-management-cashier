import 'dart:async';
import 'dart:convert';
import 'package:cashier_management/models/chart_model.dart';
import 'package:cashier_management/models/outlet_branch_model.dart';
import 'package:dio/dio.dart';
import 'package:cashier_management/database/api_endpoints.dart';
import 'package:cashier_management/models/category_model.dart';
import 'package:cashier_management/models/history_model.dart';
import 'package:cashier_management/models/kios_model.dart';
import 'package:cashier_management/models/monitoring_outlet_model.dart';
import 'package:cashier_management/models/total_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RemoteDataSource {
  static Future<bool> login(FormData data) async {
    try {
      var url = ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.login;
      Response response = await Dio().post(
        url,
        data: data,
        options: Options(contentType: Headers.jsonContentType),
      );
      if (response.statusCode == 200) {
        if (response.data['status'] == 'ok') {
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setBool('statusLogin', true);
          await prefs.setInt('id_owner', response.data['id_owner']);
          await prefs.setInt('id_kios', response.data['id_kios']);
          await prefs.setString('kios', response.data['kios']);
          await prefs.setString('phone', response.data['phone'] ?? '');
          await prefs.setString('alamat', response.data['alamat']);
          return true;
        }
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  // ===================== HOME =====================
  static Future<TotalModel?> homeTotalSaldo() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var rawFormat = jsonEncode({'id_kios': prefs.getInt('id_kios')});
      var url =
          ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.homeTotalSaldo;
      Response response = await Dio().post(
        url,
        data: rawFormat,
        options: Options(contentType: Headers.jsonContentType),
      );
      if (response.statusCode == 200) {
        final TotalModel res = TotalModel.fromJson(response.data);
        return res;
      }
      return null;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  static Future<OutletBranchModel?> homeTotalBranchSaldo() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var rawFormat = jsonEncode({'id_kios': prefs.getInt('id_kios')});
      var url = ApiEndPoints.baseUrl +
          ApiEndPoints.authEndpoints.homeTotalBranchSaldo;
      Response response = await Dio().post(
        url,
        data: rawFormat,
        options: Options(contentType: Headers.jsonContentType),
      );
      if (response.statusCode == 200) {
        final OutletBranchModel res = OutletBranchModel.fromJson(response.data);
        return res;
      }
      return null;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  static Future<FinancialHistoryModel?> histories(
      Map<String, dynamic> rawFormat) async {
    try {
      var url = ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.histories;
      Response response = await Dio().post(url,
          data: rawFormat,
          options: Options(
            contentType: Headers.jsonContentType,
          ));
      if (response.statusCode == 200) {
        final FinancialHistoryModel res =
            FinancialHistoryModel.fromJson(response.data);
        return res;
      }
      return null;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  static Future<ChartModel?> homeTotalPerMonth() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var rawFormat = jsonEncode({'id_kios': prefs.getInt('id_kios')});
      var url =
          ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.homeTotalPerMonth;
      Response response = await Dio().post(
        url,
        data: rawFormat,
        options: Options(contentType: Headers.jsonContentType),
      );
      if (response.statusCode == 200) {
        final ChartModel res = ChartModel.fromJson(response.data);
        return res;
      }
      return null;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // ===================== HISTORY =====================
  static Future<bool> deleteHistory(int id) async {
    try {
      var rawFormat = jsonEncode({'id': id});
      var url = ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.deleteHistory;
      Response response = await Dio().post(url,
          data: rawFormat,
          options: Options(
            contentType: Headers.jsonContentType,
          ));
      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } catch (error) {
      return false;
    }
  }

// ===================== KIOS =====================

  static Future<bool> saveKios(FormData data) async {
    try {
      var url = ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.saveKios;
      Response response = await Dio().post(url,
          data: data,
          options: Options(
            contentType: Headers.jsonContentType,
          ));
      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } catch (error) {
      return false;
    }
  }

  static Future<bool> deleteKios(int id) async {
    try {
      var rawFormat = jsonEncode({'id': id});
      var url = ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.deleteKios;
      Response response = await Dio().post(url,
          data: rawFormat,
          options: Options(
            contentType: Headers.jsonContentType,
          ));
      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } catch (error) {
      return false;
    }
  }

  static Future<List<KiosModel>?> getListKiosAndDetail(
    Map<String, dynamic> rawFormat,
  ) async {
    try {
      var url =
          ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.listKiosAndDetail;
      Response response = await Dio().post(
        url,
        data: rawFormat,
        options: Options(contentType: Headers.jsonContentType),
      );
      if (response.statusCode == 200) {
        List<dynamic> jsonData = response.data;
        return jsonData.map((e) => KiosModel.fromJson(e)).toList();
      }
      return null;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  static Future<List<KiosModel>?> getListKios(
    Map<String, dynamic> rawFormat,
  ) async {
    try {
      var url = ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.listKios;
      Response response = await Dio().post(
        url,
        data: rawFormat,
        options: Options(contentType: Headers.jsonContentType),
      );
      if (response.statusCode == 200) {
        List<dynamic> jsonData = response.data;
        return jsonData.map((e) => KiosModel.fromJson(e)).toList();
      }
      return null;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  static Future<List<DataListOutletBranch>?> getListCabangKios(
    Map<String, dynamic> rawFormat,
  ) async {
    try {
      var url =
          ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.listCabangKios;
      Response response = await Dio().post(
        url,
        data: rawFormat,
        options: Options(contentType: Headers.jsonContentType),
      );
      if (response.statusCode == 200) {
        List<dynamic> jsonData = response.data;
        return jsonData.map((e) => DataListOutletBranch.fromJson(e)).toList();
      }
      return null;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // ===================== CATEGORY =====================
  // SAVE CATEGORY
  static Future<bool> saveCategory(Map<String, dynamic> rawFormat) async {
    try {
      // print(jsonEncode(rawFormat));
      var url = ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.saveCategory;
      Response response = await Dio().post(url,
          data: rawFormat,
          options: Options(
            contentType: Headers.jsonContentType,
          ));
      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } catch (error) {
      return false;
    }
  }

  // UPDATE CATEGORY STATUS
  static Future<bool> updateCategory(int id, dynamic data) async {
    try {
      data['id'] = id;
      var url =
          ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.updateCategory;
      Response response = await Dio().post(url,
          data: jsonEncode(data),
          options: Options(
            contentType: Headers.jsonContentType,
          ));
      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } catch (error) {
      return false;
    }
  }

  static Future<bool> updateStatusCategory(int id, bool status) async {
    try {
      var rawFormat = jsonEncode({'id': id, 'status': !status});
      var url = ApiEndPoints.baseUrl +
          ApiEndPoints.authEndpoints.updateCategoryStatus;
      Response response = await Dio().post(url,
          data: rawFormat,
          options: Options(
            contentType: Headers.jsonContentType,
          ));
      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } catch (error) {
      return false;
    }
  }

  //DELETE CATEGORY
  static Future<bool> deleteCategory(int id) async {
    try {
      var rawFormat = jsonEncode({'id': id});
      var url =
          ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.deleteCategory;
      Response response = await Dio().post(url,
          data: rawFormat,
          options: Options(
            contentType: Headers.jsonContentType,
          ));
      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } catch (error) {
      return false;
    }
  }

  // LIST CATEGORIES
  static Future<List<CategoryModel>?> listCategories(
      Object kategori, String textSearch) async {
    try {
      var rawFormat = jsonEncode({
        'kategori': kategori,
        'textSearch': textSearch,
      });
      var url =
          ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.listCategories;
      Response response = await Dio().post(url,
          data: rawFormat,
          options: Options(
            contentType: Headers.jsonContentType,
          ));
      if (response.statusCode == 200) {
        List<dynamic> jsonData = response.data;
        return jsonData.map((e) => CategoryModel.fromJson(e)).toList();
      }
      return null;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // CATEGORY DETAIL
  static Future<CategoryModel?> detailCategory(int id) async {
    try {
      var url =
          ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.detailCategory;
      final response = await Dio().get('$url?id=$id');
      if (response.statusCode == 200) {
        dynamic jsonData = response.data;
        return CategoryModel.fromJson(jsonData);
      }
      return null;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // ===================== TRANSACTION =====================
  static Future<bool> saveTransactionExpense(
      Map<String, dynamic> rawFormat) async {
    try {
      var url = ApiEndPoints.baseUrl +
          ApiEndPoints.authEndpoints.saveTransactionExpense;
      Response response = await Dio().post(url,
          data: rawFormat,
          options: Options(
            contentType: Headers.jsonContentType,
          ));
      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } catch (error) {
      return false;
    }
  }

  static Future<bool> saveTransactionIncome(
      Map<String, dynamic> rawFormat) async {
    try {
      var url = ApiEndPoints.baseUrl +
          ApiEndPoints.authEndpoints.saveTransactionIncome;
      Response response = await Dio().post(url,
          data: rawFormat,
          options: Options(
            contentType: Headers.jsonContentType,
          ));
      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } catch (error) {
      return false;
    }
  }

  static Future<MonitoringOutletModel?> monitoringByDateRange(
      Map<String, dynamic> rawFormat) async {
    try {
      var url = ApiEndPoints.baseUrl +
          ApiEndPoints.authEndpoints.monitoringByDateRange;
      Response response = await Dio().post(url,
          data: rawFormat,
          options: Options(
            contentType: Headers.jsonContentType,
          ));
      if (response.statusCode == 200) {
        final MonitoringOutletModel res =
            MonitoringOutletModel.fromJson(response.data);
        return res;
      }
      return null;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  static Future<MonitoringOutletModel?> monitoringByMonth(
      Map<String, dynamic> rawFormat) async {
    try {
      var url =
          ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.monitoringByMonth;
      Response response = await Dio().post(url,
          data: rawFormat,
          options: Options(
            contentType: Headers.jsonContentType,
          ));
      if (response.statusCode == 200) {
        final MonitoringOutletModel res =
            MonitoringOutletModel.fromJson(response.data);
        return res;
      }
      return null;
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
