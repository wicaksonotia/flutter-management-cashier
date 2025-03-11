import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:financial_apps/database/api_endpoints.dart';
import 'package:financial_apps/models/category_model.dart';

class RemoteDataSource {
  // ===================== CATEGORY =====================
  // SAVE CATEGORY
  static Future<bool> saveCategory(dynamic data) async {
    try {
      Dio dio = Dio();
      var url =
          ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.savecategories;
      Response response = await dio.post(url,
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
      Dio dio = Dio();
      var url =
          ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.updateCategory;
      Response response = await dio.post(url,
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

  //DELETE CATEGORY
  static Future<bool> deleteCategory(int id) async {
    try {
      var rawFormat = jsonEncode({'id': id});
      Dio dio = Dio();
      var url =
          ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.deletecategory;
      Response response = await dio.post(url,
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
  static Future<List<CategoryModel>?> listCategories(Object kategori) async {
    try {
      var rawFormat = jsonEncode({'kategori': kategori});
      Dio dio = Dio();
      var url =
          ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.listcategories;
      Response response = await dio.post(url,
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
}
