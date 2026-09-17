import 'package:cashier_management/database/api_request.dart';
import 'package:cashier_management/routes.dart';
import 'package:dio/dio.dart' as Dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends GetxController {
  // ============================================================
  // STATE
  // ============================================================

  final RxBool isPasswordVisible = false.obs;
  final RxBool isPasswordCurrentVisible = false.obs;
  final RxBool isPasswordNewVisible = false.obs;
  final RxBool isPasswordConfirmVisible = false.obs;

  final RxBool isLoading = false.obs;
  final RxBool isLogin = false.obs;

  // ============================================================
  // TEXT CONTROLLERS
  // ============================================================

  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final TextEditingController namaController = TextEditingController();

  final TextEditingController noTelponController = TextEditingController();

  final TextEditingController alamatController = TextEditingController();

  final TextEditingController currentController = TextEditingController();

  final TextEditingController newController = TextEditingController();

  final TextEditingController confirmController = TextEditingController();

  // ============================================================
  // LIFECYCLE
  // ============================================================

  @override
  void onInit() {
    super.onInit();

    // Jangan cek login di sini.
    //
    // Session/login sekarang menjadi tanggung jawab
    // SplashController.
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();

    namaController.dispose();
    noTelponController.dispose();
    alamatController.dispose();

    currentController.dispose();
    newController.dispose();
    confirmController.dispose();

    super.onClose();
  }

  // ============================================================
  // PASSWORD VISIBILITY
  // ============================================================

  void showPassword() {
    isPasswordVisible.toggle();
  }

  void showCurrentPassword() {
    isPasswordCurrentVisible.toggle();
  }

  void showNewPassword() {
    isPasswordNewVisible.toggle();
  }

  void showConfirmPassword() {
    isPasswordConfirmVisible.toggle();
  }

  // ============================================================
  // LOGIN
  // ============================================================

  Future<void> loginWithEmail() async {
    try {
      isLoading.value = true;

      final Dio.FormData formData = Dio.FormData.fromMap({
        "username": emailController.text.trim(),
        "password": passwordController.text,
      });

      final bool result = await RemoteDataSource.login(formData);

      if (!result) {
        throw "Kios is not registered";
      }

      // --------------------------------------------------------
      // Setelah login berhasil
      // --------------------------------------------------------

      Get.offAllNamed(
        RouterClass.home,
      );
    } catch (error) {
      Get.snackbar(
        'Notification',
        error.toString(),
        icon: const Icon(Icons.error),
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // ============================================================
  // CHECK LOGIN STATUS
  // ============================================================
  //
  // Fungsi ini tetap tersedia kalau sewaktu-waktu dibutuhkan.
  // Tetapi TIDAK dipanggil dari onInit().
  //
  // Startup/session checking dilakukan oleh SplashController.
  // ============================================================

  Future<bool> checkLoginStatus() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final bool result = prefs.getBool('statusLogin') ?? false;

    isLogin.value = result;

    return result;
  }

  // ============================================================
  // LOAD PROFILE
  // ============================================================

  Future<void> checkProfile() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // ----------------------------------------------------------
    // PROFILE OWNER
    // ----------------------------------------------------------

    namaController.text = prefs.getString('nama_owner') ?? '';

    noTelponController.text = prefs.getString('phone_owner') ?? '';

    alamatController.text = prefs.getString('alamat_owner') ?? '';
  }

  // ============================================================
  // UPDATE PROFILE
  // ============================================================

  Future<void> updateProfileProcess() async {
    try {
      isLoading.value = true;

      final SharedPreferences prefs = await SharedPreferences.getInstance();

      final rawFormat = {
        "id_owner": prefs.getInt('id_owner'),
        "nama": namaController.text.trim(),
        "phone": noTelponController.text.trim(),
        "alamat": alamatController.text.trim(),
      };

      final bool result = await RemoteDataSource.updateProfile(
        rawFormat,
      );

      if (!result) {
        throw "Failed to update profile";
      }

      // --------------------------------------------------------
      // Update SharedPreferences
      // --------------------------------------------------------

      await prefs.setString(
        'nama_owner',
        namaController.text.trim(),
      );

      await prefs.setString(
        'phone_owner',
        noTelponController.text.trim(),
      );

      await prefs.setString(
        'alamat_owner',
        alamatController.text.trim(),
      );

      // --------------------------------------------------------
      // SUCCESS
      // --------------------------------------------------------

      Get.snackbar(
        'Notification',
        'Profile updated successfully',
        icon: const Icon(Icons.check),
        snackPosition: SnackPosition.TOP,
      );
    } catch (error) {
      Get.snackbar(
        'Notification',
        error.toString(),
        icon: const Icon(Icons.error),
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // ============================================================
  // CHANGE PASSWORD
  // ============================================================

  Future<void> changePasswordProcess() async {
    try {
      isLoading.value = true;

      final SharedPreferences prefs = await SharedPreferences.getInstance();

      // --------------------------------------------------------
      // VALIDATION
      // --------------------------------------------------------

      if (currentController.text.isEmpty ||
          newController.text.isEmpty ||
          confirmController.text.isEmpty) {
        throw "All fields are required";
      }

      if (currentController.text.contains(' ') ||
          newController.text.contains(' ') ||
          confirmController.text.contains(' ')) {
        throw "Password cannot contain spaces";
      }

      final String savedPassword = prefs.getString('password') ?? '';

      if (currentController.text != savedPassword) {
        throw "Current password is incorrect";
      }

      if (newController.text.length < 6 || confirmController.text.length < 6) {
        throw "Password must be at least 6 characters";
      }

      if (newController.text != confirmController.text) {
        throw "New password and confirm password do not match";
      }

      if (currentController.text == newController.text) {
        throw "New password must be different from current password";
      }

      // --------------------------------------------------------
      // REQUEST
      // --------------------------------------------------------

      final rawFormat = {
        "id_owner": prefs.getInt('id_owner'),
        "new_password": newController.text,
      };

      final bool result = await RemoteDataSource.changePasswordProcess(
        rawFormat,
      );

      if (!result) {
        throw "Failed to change password";
      }

      // --------------------------------------------------------
      // SAVE PASSWORD
      // --------------------------------------------------------

      await prefs.setString(
        'password',
        newController.text,
      );

      clearChangePasswordControllers();

      // --------------------------------------------------------
      // SUCCESS
      // --------------------------------------------------------

      Get.snackbar(
        'Notification',
        'Password changed successfully',
        icon: const Icon(Icons.check),
        snackPosition: SnackPosition.TOP,
      );
    } catch (error) {
      Get.snackbar(
        'Notification',
        error.toString(),
        icon: const Icon(Icons.error),
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // ============================================================
  // CLEAR CHANGE PASSWORD
  // ============================================================

  void clearChangePasswordControllers() {
    currentController.clear();
    newController.clear();
    confirmController.clear();
  }

  // ============================================================
  // LOGOUT
  // ============================================================

  Future<void> logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.clear();

    isLogin.value = false;

    Get.offAllNamed(
      RouterClass.login,
    );
  }
}
