import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:financial_apps/models/category_model.dart';
import 'package:financial_apps/models/transaction_model.dart';
import 'package:financial_apps/database/api_endpoints.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  DatabaseHelper._();
  static final instance = DatabaseHelper._();
  factory DatabaseHelper() => instance;

  Database? _db;
  Future<Database> get db async => _db ??= await initDB();

  static String tableCategories = 'table_categories';
  static String tableTransactions = 'table_transactions';

  static Future<Database> initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'financial.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (Database database, int version) async {
        await createTables(database);
      },
    );
  }

  Future close() async {
    final dbClient = await db;
    dbClient.close();
  }

  static Future<void> createTables(Database database) async {
    await database.execute("""
      CREATE TABLE IF NOT EXISTS $tableCategories(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        category_name TEXT,
        category_type TEXT,
        status BOOLEAN DEFAULT TRUE,
        created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
      """);

    await database.execute("""
      CREATE TABLE IF NOT EXISTS $tableTransactions(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        type TEXT,
        category_id INTEGER,
        category_name TEXT,
        transaction_date INTEGER,
        amount INTEGER,
        created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (category_id) REFERENCES table_categories (id)
      )
      """);
  }

  // ================================
  // CATEGORY
  // ================================
  Future<List<CategoryModel>> fetchCategories(String category) async {
    final dbClient = await db;
    var result = await dbClient.query(tableCategories);
    if (category != "All") {
      result = await dbClient.query(
        tableCategories,
        where: 'category_type = ?',
        whereArgs: [category],
      );
    }
    log('fetchCats: ${result.length}');
    return result.map((e) => CategoryModel.fromJson(e)).toList();
  }

  Future<CategoryModel?> detailCategories(int id) async {
    final dbClient = await db;
    final result = await dbClient.query(
      tableCategories,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    log('detailCat: ${result.length}');
    if (result.isNotEmpty) {
      return CategoryModel.fromJson(result.first);
    }
    return null;
  }

  Future<int> insertCategories(CategoryModel category) async {
    final dbClient = await db;
    final rowAffected = await dbClient.insert(
        tableCategories, category.toMapInsert(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    log('insertCat: $rowAffected');
    return rowAffected;
  }

  Future<int> deleteCategories(int id) async {
    final dbClient = await db;
    // final rowAffected = await dbClient.delete(
    //   tableCategories,
    //   where: 'id = ?',
    //   whereArgs: [id],
    // );
    final rowAffected = await dbClient.update(
      tableCategories,
      {'status': false},
      where: 'id = ?',
      whereArgs: [id],
    );
    log('deleteCat: $rowAffected');
    return rowAffected;
  }

  Future<bool> syncLocalToServerCategories() async {
    final dbClient = await db;
    final localData = await dbClient.query(tableCategories);
    try {
      Dio dio = Dio();
      var url =
          ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.savecategories;
      Response response = await dio.post(url,
          data: jsonEncode(localData),
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

  Future<bool> syncServerToLocalCategories() async {
    final dbClient = await db;
    try {
      Dio dio = Dio();
      var url =
          ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.listcategories;
      Response response = await dio.get(url);
      if (response.statusCode == 200) {
        await dbClient.delete(tableCategories);
        // CategoryModel category = CategoryModel.fromJson(response.data);
        for (var element in response.data) {
          await dbClient.insert(tableCategories, element,
              conflictAlgorithm: ConflictAlgorithm.replace);
        }
        return true;
      }
      return false;
    } catch (error) {
      return false;
    }
  }

  Future<int> updateCategories(int id, CategoryModel cat) async {
    final dbClient = await db;
    final rowAffected = await dbClient.update(
      tableCategories,
      cat.toMapUpdate(),
      where: 'id = ?',
      whereArgs: [cat.id],
    );
    log('updateCat: $rowAffected');
    return rowAffected;
  }

  // ================================
  // TRANSACTION
  // ================================
  Future<List<TransactionModel>> fetchTransactions(
      String category, int convertedDateBackToInt) async {
    final dbClient = await db;
    var result = await dbClient.query(
      tableTransactions,
      where: 'transaction_date = ?',
      whereArgs: [convertedDateBackToInt],
    );
    if (category != "All") {
      result = await dbClient.query(
        tableTransactions,
        where: 'category_name = ? AND transaction_date = ?',
        whereArgs: [category, convertedDateBackToInt],
      );
    }
    log('fetchTransactions: ${result.length}');
    return result.map((e) => TransactionModel.fromMap(e)).toList();
  }

  Future<int> insertTransactions(TransactionModel category) async {
    final dbClient = await db;
    final rowAffected = await dbClient.insert(
        tableTransactions, category.toMapInsert(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    log('insertTransactions: $rowAffected');
    return rowAffected;
  }

  Future<int> deleteTransactions(int id) async {
    final dbClient = await db;
    final rowAffected = await dbClient.delete(
      tableTransactions,
      where: 'id = ?',
      whereArgs: [id],
    );
    log('deleteTransactions: $rowAffected');
    return rowAffected;
  }

  // Future<int> updateTransactions(Cat cat) async {
  //   final dbClient = await db;
  //   final rowAffected = await dbClient.update(
  //     tableTransactions,
  //     cat.toMapUpdate(),
  //     where: 'id = ?',
  //     whereArgs: [cat.id],
  //   );
  //   log('updateTransactions: $rowAffected');
  //   return rowAffected;
  // }
}
