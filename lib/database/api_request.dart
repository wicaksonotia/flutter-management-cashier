import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:financial_apps/database/api_endpoints.dart';
import 'package:financial_apps/models/category_model.dart';
import 'package:financial_apps/models/history_model.dart';
import 'package:financial_apps/models/monitoring_outlet_model.dart';
import 'package:financial_apps/models/total_model.dart';
import 'package:financial_apps/models/total_per_type_model.dart';

class RemoteDataSource {
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
  static Future<TotalModel?> total() async {
    try {
      var url = ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.total;
      final response = await Dio().get(url);
      if (response.statusCode == 200) {
        final TotalModel res = TotalModel.fromJson(response.data);
        return res;
      }
      return null;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  static Future<TotalPerTypeModel?> totalPerType() async {
    try {
      var url = ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.totalpertype;
      final response = await Dio().get(url);
      if (response.statusCode == 200) {
        final TotalPerTypeModel res = TotalPerTypeModel.fromJson(response.data);
        return res;
      }
      return null;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  static Future<FinancialHistoryModel?> historyByDateRange(
      DateTime startdate, DateTime enddate, Object subKategori) async {
    try {
      var rawFormat = (jsonEncode({
        'startDate': startdate.toString(),
        'endDate': enddate.toString(),
        // 'kategori': kategori,
        'subKategori': subKategori,
      }));
      var url =
          ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.historybydaterange;
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

  static Future<FinancialHistoryModel?> historyByMonth(
      String monthYear, Object subKategori) async {
    try {
      var rawFormat = (jsonEncode({
        'monthYear': monthYear,
        // 'kategori': kategori,
        'subKategori': subKategori,
      }));
      var url =
          ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.historybymonth;
      Response response = await Dio().post(url,
          data: rawFormat,
          options: Options(
            contentType: Headers.jsonContentType,
          ));
      if (response.statusCode == 200) {
        final FinancialHistoryModel res =
            FinancialHistoryModel.fromJson(response.data);
        // print(res.toJson());
        return res;
      }
      return null;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

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
        // print(res.toJson());
        return res;
      }
      return null;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // LIST CATEGORIES
  static Future<List<CategoryModel>?> listOutlet() async {
    try {
      var url = ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.listoutlet;
      final response = await Dio().get(url);
      if (response.statusCode == 200) {
        List<dynamic> jsonData = response.data;
        return jsonData.map((e) => CategoryModel.fromJson(e)).toList();
      }
      return null;
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
