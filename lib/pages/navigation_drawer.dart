import 'package:cashier_management/controllers/login_controller.dart';
import 'package:cashier_management/controllers/monitoring_outlet_controller.dart';
import 'package:cashier_management/pages/change_outlet_page.dart';
import 'package:cashier_management/utils/colors.dart';
import 'package:cashier_management/routes.dart';
import 'package:cashier_management/utils/confirm_dialog.dart';
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
            _buildDrawerHeader(),
            _buildDrawerItem(
              icon: Icons.shopping_cart,
              text: "Home",
              onTap: () {
                Navigator.of(context).pop();
                Get.toNamed(RouterClass.home);
              },
              selected: Get.currentRoute == RouterClass.home,
            ),
            Divider(color: Colors.grey.shade300),
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: Text("Transactions",
                  style: TextStyle(
                      fontSize: MySizes.fontSizeLg, letterSpacing: 1)),
            ),
            _buildDrawerItem(
              icon: Icons.home_work,
              text: "History Per Outlet",
              onTap: () {
                Navigator.of(context).pop();
                final MonitoringOutletController monitoringOutletController =
                    Get.put(MonitoringOutletController());
                monitoringOutletController.setKiosForTransaksiPerOutlet();
                Get.toNamed(RouterClass.monitoringoutlet);
              },
              selected: Get.currentRoute == RouterClass.monitoringoutlet,
            ),
            _buildDrawerItem(
              icon: Icons.account_balance_wallet,
              text: "Income/Expenditure",
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
            _buildDrawerItem(
              icon: Icons.store,
              text: "Brand",
              onTap: () {
                Navigator.of(context).pop();
                Get.toNamed(RouterClass.outlet);
              },
              selected: Get.currentRoute == RouterClass.outlet,
            ),
            _buildDrawerItem(
              icon: Icons.supervisor_account,
              text: "Employee",
              onTap: () {
                Navigator.of(context).pop();
                Get.toNamed(RouterClass.listemployee);
              },
              selected: Get.currentRoute == RouterClass.listemployee,
            ),
            Container(
              color: Colors.transparent,
              child: ListTile(
                leading: Icon(Icons.inventory,
                    color: (Get.currentRoute == RouterClass.listproduct ||
                            Get.currentRoute == RouterClass.productcategory)
                        ? MyColors.primary
                        : Colors.black),
                title: Text('Product',
                    style: TextStyle(
                        color: (Get.currentRoute == RouterClass.listproduct ||
                                Get.currentRoute == RouterClass.productcategory)
                            ? MyColors.primary
                            : Colors.black)),
              ),
            ),
            _buildSubItem(
              text: "Category",
              onTap: () {
                Navigator.of(context).pop();
                Get.toNamed(RouterClass.productcategory);
              },
              selected: Get.currentRoute == RouterClass.productcategory,
            ),
            _buildSubItem(
              text: "List Product",
              onTap: () {
                Navigator.of(context).pop();
                Get.toNamed(RouterClass.listproduct);
              },
              selected: Get.currentRoute == RouterClass.listproduct,
            ),
            _buildDrawerItem(
              icon: Icons.supervisor_account,
              text: "Category Income/Expenditure",
              onTap: () {
                Navigator.of(context).pop();
                Get.toNamed(RouterClass.category);
              },
              selected: Get.currentRoute == RouterClass.category,
            ),
            Divider(color: Colors.grey.shade300),
            _buildDrawerItem(
              icon: Icons.manage_accounts,
              text: "Account",
              onTap: () {
                Navigator.of(context).pop();
                Get.toNamed(RouterClass.userSetting);
              },
              selected: Get.currentRoute == RouterClass.userSetting,
            ),
            _buildDrawerItem(
              icon: Icons.logout,
              text: "Log Out",
              onTap: () {
                Get.bottomSheet(
                  ConfirmDialog(
                    title: 'Logout',
                    message: 'Are you sure, you want to logout?',
                    onConfirm: () async {
                      loginController.logout();
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerHeader() {
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
        return InkWell(
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
          child: UserAccountsDrawerHeader(
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
                const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: Colors.white,
                  size: MySizes.iconSm,
                ),
              ],
            ),
            currentAccountPicture: const CircleAvatar(
              backgroundImage: AssetImage('assets/clerk.png'),
              backgroundColor: Colors.white,
            ),
          ),
        );
      },
    );
  }

  Widget _buildDrawerItem({
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

  Widget _buildSubItem({
    required String text,
    required VoidCallback onTap,
    bool selected = false,
  }) {
    return Container(
      color: selected ? MyColors.notionBgPurple : Colors.transparent,
      padding: const EdgeInsets.only(left: 50, right: 25),
      child: ListTile(
        dense: true,
        contentPadding: EdgeInsets.zero,
        title: Text(text,
            style:
                TextStyle(color: selected ? MyColors.primary : Colors.black)),
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: selected ? MyColors.primary : Colors.black,
          size: MySizes.iconXs,
        ),
        selected: selected,
        onTap: onTap,
      ),
    );
  }
}
