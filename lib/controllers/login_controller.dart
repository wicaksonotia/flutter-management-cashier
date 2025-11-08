import 'package:dio/dio.dart' as Dio;
import 'package:cashier_management/database/api_request.dart';
import 'package:cashier_management/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends GetxController {
  var isPasswordVisible = false.obs;
  var isPasswordCurrentVisible = false.obs;
  var isPasswordNewVisible = false.obs;
  var isPasswordConfirmVisible = false.obs;
  var isLoading = false.obs;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController namaController = TextEditingController();
  TextEditingController noTelponController = TextEditingController();
  TextEditingController alamatController = TextEditingController();
  TextEditingController currentController = TextEditingController();
  TextEditingController newController = TextEditingController();
  TextEditingController confirmController = TextEditingController();
  var isLogin = false.obs;

  showPassword() {
    isPasswordVisible(!isPasswordVisible.value);
  }

  showCurrentPassword() {
    isPasswordCurrentVisible(!isPasswordCurrentVisible.value);
  }

  showNewPassword() {
    isPasswordNewVisible(!isPasswordNewVisible.value);
  }

  showConfirmPassword() {
    isPasswordConfirmVisible(!isPasswordConfirmVisible.value);
  }

  void clearChangePasswordControllers() {
    currentController.clear();
    newController.clear();
    confirmController.clear();
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

  void checkProfile() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    namaController.text = prefs.getString('nama_owner') ?? '';
    noTelponController.text = prefs.getString('phone_owner') ?? '';
    alamatController.text = prefs.getString('alamat_owner') ?? '';
  }

  Future<void> updateProfileProcess() async {
    try {
      isLoading(true);
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var rawFormat = {
        "id_owner": prefs.getInt('id_owner'),
        "nama": namaController.text,
        "phone": noTelponController.text,
        "alamat": alamatController.text,
      };
      bool result = await RemoteDataSource.updateProfile(rawFormat);
      if (result) {
        prefs.setString('nama_owner', namaController.text);
        prefs.setString('phone_owner', noTelponController.text);
        prefs.setString('alamat_owner', alamatController.text);
        Get.snackbar(
          'Notification',
          'Profile updated successfully',
          icon: const Icon(Icons.check),
          snackPosition: SnackPosition.TOP,
        );
      } else {
        throw "Failed to update profile";
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

  Future<void> changePasswordProcess() async {
    try {
      isLoading(true);
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      if (currentController.text.isEmpty ||
          newController.text.isEmpty ||
          confirmController.text.isEmpty) {
        throw "All fields are required";
      } else if (newController.text.contains(' ')) {
        throw "Password cannot contain spaces";
      } else if (confirmController.text.contains(' ')) {
        throw "Password cannot contain spaces";
      } else if (currentController.text.contains(' ')) {
        throw "Password cannot contain spaces";
      } else {
        String savedPassword = prefs.getString('password') ?? '';
        if (currentController.text != savedPassword) {
          throw "Current password is incorrect";
        } else if (newController.text.length < 6 ||
            confirmController.text.length < 6) {
          throw "Password must be at least 6 characters";
        } else if (newController.text != confirmController.text) {
          throw "New password and confirm password do not match";
        } else if (currentController.text == newController.text) {
          throw "New password must be different from current password";
        }
      }

      var rawFormat = {
        "id_owner": prefs.getInt('id_owner'),
        "new_password": newController.text,
      };
      bool result = await RemoteDataSource.changePasswordProcess(rawFormat);
      if (result) {
        prefs.setString('password', newController.text);
        clearChangePasswordControllers();
        throw "Password changed successfully";
      } else {
        throw "Failed to change password";
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
}
