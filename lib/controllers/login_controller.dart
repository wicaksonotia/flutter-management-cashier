import 'package:dio/dio.dart' as Dio;
import 'package:cashier_management/database/api_request.dart';
import 'package:cashier_management/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends GetxController {
  var isPasswordVisible = false.obs;
  var isLoading = false.obs;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  var isLogin = false.obs;

  showPassword() {
    isPasswordVisible(!isPasswordVisible.value);
  }

  @override
  void onInit() {
    checkLoginStatus();
    super.onInit();
  }

  Future<void> loginWithEmail() async {
    try {
      isLoading(true);
      Dio.FormData formData = Dio.FormData.fromMap({
        "username": emailController.text.trim(),
        "password": passwordController.text,
      });
      bool result = await RemoteDataSource.login(formData);
      if (result) {
        Get.offNamed(RouterClass.home);
      } else {
        throw "Kios is not regsitered";
      }
    } catch (error) {
      Get.snackbar(
        'Notification',
        error.toString(),
        icon: const Icon(Icons.error),
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoading(false);
    }
  }

  void checkLoginStatus() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    isLogin.value = prefs.getBool('statusLogin') ?? false;
    if (isLogin.value == true) {
      Get.offAllNamed(RouterClass.home);
    } else {
      Get.offAllNamed(RouterClass.login);
    }
  }

  void logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    isLogin.value = false;
    Get.offAllNamed(RouterClass.login);
  }
}
