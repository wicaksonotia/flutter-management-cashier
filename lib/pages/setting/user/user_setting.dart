import 'package:cashier_management/controllers/login_controller.dart';
import 'package:cashier_management/routes.dart';
import 'package:cashier_management/utils/colors.dart';
import 'package:cashier_management/utils/confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cashier_management/pages/navigation_drawer.dart'
    as custom_drawer;

class UserSetting extends StatelessWidget {
  const UserSetting({super.key});

  @override
  Widget build(BuildContext context) {
    final LoginController _loginController = Get.find<LoginController>();

    return Scaffold(
      drawer: const custom_drawer.NavigationDrawer(),
      backgroundColor: MyColors.notionBgGrey,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50.0),
        child: AppBar(
          title: const Text(
            'User Settings',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: MyColors.primary,
          leading: Builder(
            builder: (context) {
              return IconButton(
                icon: const Icon(Icons.menu, color: Colors.white),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              );
            },
          ),
        ),
      ),
      body: Container(
        color: Colors.grey.shade50,
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Column(
          children: [
            BoxCategory(
              title: "Account Settings",
              children: [
                listTileMenu("Profile", Icons.person, RouterClass.profile),
                listTileMenu(
                  "Change Password",
                  Icons.lock,
                  RouterClass.changePassword,
                ),
              ],
            ),
            // const BoxCategory(title: "App Settings"),
            const Spacer(),
            SizedBox(
              width: 300,
              child: ElevatedButton(
                onPressed: () {
                  Get.bottomSheet(
                    ConfirmDialog(
                      title: 'Logout',
                      message: 'Are you sure, you want to logout?',
                      onConfirm: () async {
                        _loginController.logout();
                      },
                    ),
                    isScrollControlled: true,
                    backgroundColor: Colors.white,
                    shape: const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  side: const BorderSide(color: Colors.redAccent),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                child: const Text(
                  "Logout",
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Column listTileMenu(title, icon, route) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          leading: Icon(icon),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [Text(title)],
          ),
          onTap: () => Get.toNamed(route),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 55.0, right: 16.0),
          child: Divider(color: Colors.grey.shade300, thickness: 0.5),
        ),
      ],
    );
  }
}

class BoxCategory extends StatelessWidget {
  const BoxCategory({super.key, required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20.0, left: 10.0, right: 10.0),
      padding: const EdgeInsets.only(bottom: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: .3),
            spreadRadius: 0,
            blurRadius: 7,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: 16.0,
              top: 16.0,
              bottom: 5.0,
              right: 16.0,
            ),
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          Divider(color: Colors.grey.shade400, thickness: 0.5),
          ...children,
        ],
      ),
    );
  }
}
