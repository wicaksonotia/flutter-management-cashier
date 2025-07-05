import 'package:cashier_management/initial_binding.dart';
import 'package:cashier_management/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialBinding: InitialBinding(),
      initialRoute: RouterClass.login,
      getPages: RouterClass.routes,
      defaultTransition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 500),
    );
  }
}
