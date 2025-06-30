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
          await prefs.setInt('id', response.data['id']);
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
      var rawFormat = jsonEncode({'id_kios': prefs.getInt('id')});
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
      var rawFormat = jsonEncode({'id_kios': prefs.getInt('id')});
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
      DateTime startdate,
      DateTime enddate,
      String monthYear,
      String filterBy,
      Object kategori) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var rawFormat = (jsonEncode({
        'startDate': startdate.toString(),
        'endDate': enddate.toString(),
        'monthYear': monthYear,
        'filter_by_date_or_month': filterBy,
        'id_kios': prefs.getInt('id'),
        'kategori': kategori
      }));
      print(rawFormat);
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
      var rawFormat = jsonEncode({'id_kios': prefs.getInt('id')});
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
      var url = ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.deletehistory;
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

  // ===================== CATEGORY =====================
  // SAVE CATEGORY
  static Future<bool> saveCategory(dynamic data) async {
    try {
      var url =
          ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.savecategories;
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
          ApiEndPoints.authEndpoints.updatecategorystatus;
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
          ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.deletecategory;
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
          ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.listcategories;
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
          ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.detailcategory;
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
      int incomeId,
      int expenseId,
      String incomeName,
      String expenseName,
      int amount,
      String description,
      String transactionDate,
      String transactionTime) async {
    try {
      var rawFormat = (jsonEncode({
        'incomeId': incomeId,
        'expenseId': expenseId,
        'incomeName': incomeName,
        'expenseName': expenseName,
        'amount': amount,
        'description': description,
        'transactionDate': transactionDate,
        'transactionTime': transactionTime,
      }));
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
      int incomeId,
      String incomeName,
      int amount,
      String description,
      String transactionDate,
      String transactionTime) async {
    try {
      var rawFormat = (jsonEncode({
        'incomeId': incomeId,
        'incomeName': incomeName,
        'amount': amount,
        'description': description,
        'transactionDate': transactionDate,
        'transactionTime': transactionTime,
      }));
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
      DateTime startdate, DateTime enddate, String kios) async {
    try {
      var rawFormat = (jsonEncode({
        'startDate': startdate.toString(),
        'endDate': enddate.toString(),
        'kios': kios,
      }));
      var url = ApiEndPoints.baseUrl +
          ApiEndPoints.authEndpoints.monitoringbydaterange;
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
      String monthYear, String kios) async {
    try {
      var rawFormat = (jsonEncode({
        'monthYear': monthYear,
        'kios': kios,
      }));
      var url =
          ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.monitoringbymonth;
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

  // LIST CATEGORIES
  static Future<List<KiosModel>?> listOutlet() async {
    try {
      var url = ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.listoutlet;
      final response = await Dio().get(url);
      if (response.statusCode == 200) {
        List<dynamic> jsonData = response.data;
        return jsonData.map((e) => KiosModel.fromJson(e)).toList();
      }
      return null;
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
