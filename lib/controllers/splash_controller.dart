import 'package:cashier_management/controllers/login_controller.dart';
import 'package:cashier_management/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashController extends GetxController {
  final RxBool isLoading = true.obs;
  final RxDouble progress = 0.0.obs;
  final RxString loadingText = 'Menyiapkan aplikasi...'.obs;

  @override
  void onReady() {
    super.onReady();
    initializeApp();
  }

  Future<void> initializeApp() async {
    try {
      isLoading.value = true;

      // 1. CHECK SESSION
      loadingText.value = 'Memeriksa sesi...';
      progress.value = 0.15;

      final SharedPreferences prefs = await SharedPreferences.getInstance();

      final bool isLogin = prefs.getBool('statusLogin') ?? false;

      await Future.delayed(
        const Duration(milliseconds: 150),
      );

      // 2. BELUM LOGIN: KE HALAMAN LOGIN
      if (!isLogin) {
        loadingText.value = 'Membuka halaman login...';
        progress.value = 1.0;

        await Future.delayed(
          const Duration(milliseconds: 200),
        );

        Get.offAllNamed(RouterClass.login);
        return;
      }

      // 3. LOAD PROFILE
      loadingText.value = 'Memuat data pengguna...';
      progress.value = 0.40;

      final LoginController loginController = Get.find<LoginController>();

      await loginController.checkProfile();

      await Future.delayed(
        const Duration(milliseconds: 150),
      );

      // 4. PREPARE SYSTEM
      loadingText.value = 'Menyiapkan sistem...';
      progress.value = 0.65;

      await Future.delayed(
        const Duration(milliseconds: 300),
      );

      // 5. FINISH
      loadingText.value = 'Hampir selesai...';
      progress.value = 1.0;

      await Future.delayed(
        const Duration(milliseconds: 250),
      );

      // 6. ROUTING BERDASARKAN KEBERADAAN KIOS
      final int idKios = prefs.getInt('id_kios') ?? 0;

      if (idKios > 0) {
        Get.offAllNamed(RouterClass.home);
      } else {
        Get.offAllNamed(RouterClass.addoutlet);
      }
    } catch (error, stackTrace) {
      debugPrint('SPLASH INITIALIZATION ERROR: $error');
      debugPrint('STACK: $stackTrace');

      Get.offAllNamed(RouterClass.login);
    } finally {
      isLoading.value = false;
    }
  }
}
