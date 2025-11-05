import 'package:cashier_management/controllers/login_controller.dart';
import 'package:cashier_management/controllers/monitoring_outlet_controller.dart';
import 'package:cashier_management/pages/change_outlet_page.dart';
import 'package:cashier_management/utils/colors.dart';
import 'package:cashier_management/routes.dart';
import 'package:cashier_management/utils/sizes.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NavigationDrawer extends StatelessWidget {
  const NavigationDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final LoginController loginController = Get.find<LoginController>();
    return Drawer(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(0.0)),
      ),
      child: Container(
        color: Colors.white,
        child: ListView(
          children: [
            buildDrawerHeader(),
            buildDrawerItem(
              icon: Icons.shopping_cart,
              text: "Home",
              onTap: () {
                Navigator.of(context).pop();
                Get.toNamed(RouterClass.home);
              },
              selected: Get.currentRoute == RouterClass.home,
            ),
            buildDrawerItem(
              icon: Icons.home_work,
              text: "Transaksi Per Outlet",
              onTap: () {
                Navigator.of(context).pop();
                final MonitoringOutletController monitoringOutletController =
                    Get.put(MonitoringOutletController());
                monitoringOutletController.setKiosForTransaksiPerOutlet();
                Get.toNamed(RouterClass.monitoringoutlet);
              },
              selected: Get.currentRoute == RouterClass.monitoringoutlet,
            ),
            Divider(color: Colors.grey.shade300),
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: Text("Transaksi Belanja",
                  style: TextStyle(
                      fontSize: MySizes.fontSizeLg, letterSpacing: 1)),
            ),
            buildDrawerItem(
              icon: Icons.edit_document,
              text: "Input Transaksi",
              onTap: () {
                Navigator.of(context).pop();
                Get.toNamed(RouterClass.addtransaction);
              },
              selected: Get.currentRoute == RouterClass.addtransaction,
            ),
            buildDrawerItem(
              icon: Icons.history,
              text: "Riwayat",
              onTap: () {
                Navigator.of(context).pop();
                Get.toNamed(RouterClass.transactionhistory);
              },
              selected: Get.currentRoute == RouterClass.transactionhistory,
            ),
            Divider(color: Colors.grey.shade300),
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: Text("Setting",
                  style: TextStyle(
                      fontSize: MySizes.fontSizeLg, letterSpacing: 1)),
            ),
            buildDrawerItem(
              icon: Icons.manage_accounts,
              text: "Outlet",
              onTap: () {
                Navigator.of(context).pop();
                Get.toNamed(RouterClass.outlet);
              },
            ),
            buildDrawerItem(
              icon: Icons.manage_accounts,
              text: "User Outlet",
              onTap: () => '',
            ),
            buildDrawerItem(
              icon: Icons.production_quantity_limits,
              text: "Product",
              onTap: () => '',
            ),
            Divider(color: Colors.grey.shade300),
            buildDrawerItem(
              icon: Icons.logout,
              text: "Log Out",
              onTap: () {
                loginController.logout();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDrawerHeader() {
    return FutureBuilder<SharedPreferences>(
      future: SharedPreferences.getInstance(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: MyColors.primary),
            accountName: Text(
              '',
              style: TextStyle(
                color: Colors.white,
                fontSize: MySizes.fontSizeLg,
              ),
            ),
            accountEmail: Text(
              '',
              style: TextStyle(
                color: Colors.white,
                fontSize: MySizes.fontSizeMd,
              ),
            ),
            currentAccountPicture: CircleAvatar(
              backgroundImage: AssetImage('assets/clerk.png'),
              backgroundColor: Colors.white,
            ),
          );
        }
        final prefs = snapshot.data!;
        return UserAccountsDrawerHeader(
          decoration: const BoxDecoration(color: MyColors.primary),
          accountName: Text(
            prefs.getString('kios') ?? '',
            style: const TextStyle(
              color: Colors.white,
              fontSize: MySizes.fontSizeLg,
            ),
          ),
          accountEmail: Row(
            children: [
              Text(
                prefs.getString('phone') ?? '',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: MySizes.fontSizeMd,
                ),
              ),
              const Gap(10),
              GestureDetector(
                onTap: () {
                  Get.back();
                  showModalBottomSheet(
                    context: context,
                    constraints: const BoxConstraints(
                      minWidth: double.infinity,
                    ),
                    builder: (context) => const ChangeOutletPage(),
                    isScrollControlled: true,
                    backgroundColor: Colors.white,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                  );
                },
                child: const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: Colors.white,
                  size: MySizes.iconSm,
                ),
              ),
            ],
          ),
          currentAccountPicture: const CircleAvatar(
            backgroundImage: AssetImage('assets/clerk.png'),
            backgroundColor: Colors.white,
          ),
        );
      },
    );
  }

  Widget buildDrawerItem({
    required String text,
    required IconData icon,
    required VoidCallback onTap,
    bool selected = false,
  }) {
    return Container(
      color: selected ? MyColors.notionBgPurple : Colors.transparent,
      child: ListTile(
        leading: Icon(icon, color: selected ? MyColors.primary : Colors.black),
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: selected ? MyColors.primary : Colors.black,
          size: MySizes.iconXs,
        ),
        title: Text(text,
            style:
                TextStyle(color: selected ? MyColors.primary : Colors.black)),
        selected: selected,
        onTap: onTap,
      ),
    );
  }
}
