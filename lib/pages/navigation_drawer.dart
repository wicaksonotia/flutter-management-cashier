import 'package:cashier_management/controllers/login_controller.dart';
import 'package:cashier_management/controllers/monitoring_outlet_controller.dart';
import 'package:cashier_management/pages/change_outlet_page.dart';
import 'package:cashier_management/routes.dart';
import 'package:cashier_management/utils/colors.dart';
import 'package:cashier_management/utils/logout_confirmation_dialog.dart';
import 'package:cashier_management/utils/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NavigationDrawer extends StatefulWidget {
  const NavigationDrawer({super.key});

  @override
  State<NavigationDrawer> createState() => _NavigationDrawerState();
}

class _NavigationDrawerState extends State<NavigationDrawer> {
  late final LoginController loginController;

  String _kios = '';
  String _phone = '';
  bool _productExpanded = false;

  @override
  void initState() {
    super.initState();

    loginController = Get.find<LoginController>();

    _productExpanded = Get.currentRoute == RouterClass.listproduct ||
        Get.currentRoute == RouterClass.productcategory;

    _loadProfile();
  }

  // ============================================================
  // LOAD PROFILE
  // ============================================================

  Future<void> _loadProfile() async {
    final prefs = await SharedPreferences.getInstance();

    if (!mounted) return;

    setState(() {
      _kios = prefs.getString('kios') ?? '';
      _phone = prefs.getString('phone') ?? '';
    });
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: MyColors.background,
      elevation: 0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
      child: SafeArea(
        child: Column(
          children: [
            // ==================================================
            // HEADER
            // ==================================================

            _buildProfileSection(),

            // ==================================================
            // MENU
            // ==================================================

            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(
                  12,
                  16,
                  12,
                  12,
                ),
                children: [
                  // ==================================================
                  // HOME
                  // ==================================================

                  _buildSectionTitle('UTAMA'),

                  const SizedBox(height: 6),

                  _buildDrawerItem(
                    icon: Icons.dashboard_outlined,
                    text: 'Dashboard',
                    route: RouterClass.home,
                  ),

                  const SizedBox(height: 22),

                  // ==================================================
                  // TRANSACTIONS
                  // ==================================================

                  _buildSectionTitle('TRANSAKSI'),

                  const SizedBox(height: 6),

                  _buildDrawerItem(
                    icon: Icons.account_balance_wallet_outlined,
                    text: 'Income / Expenditure',
                    route: RouterClass.transactionhistory,
                  ),

                  _buildDrawerItem(
                    icon: Icons.storefront_outlined,
                    text: 'History Per Outlet',
                    route: RouterClass.monitoringoutlet,
                    onTap: _openMonitoringOutlet,
                  ),

                  const SizedBox(height: 22),

                  // ==================================================
                  // SETTINGS
                  // ==================================================

                  _buildSectionTitle('PENGATURAN'),

                  const SizedBox(height: 6),

                  _buildDrawerItem(
                    icon: Icons.store_outlined,
                    text: 'Brand',
                    route: RouterClass.outlet,
                  ),

                  _buildDrawerItem(
                    icon: Icons.groups_outlined,
                    text: 'Employee',
                    route: RouterClass.listemployee,
                  ),

                  // ==================================================
                  // PRODUCT
                  // ==================================================

                  _buildProductMenu(),

                  _buildDrawerItem(
                    icon: Icons.category_outlined,
                    text: 'Income / Expenditure Category',
                    route: RouterClass.category,
                  ),

                  const SizedBox(height: 22),

                  // ==================================================
                  // ACCOUNT
                  // ==================================================

                  _buildSectionTitle('AKUN'),

                  const SizedBox(height: 6),

                  _buildDrawerItem(
                    icon: Icons.manage_accounts_outlined,
                    text: 'Account',
                    route: RouterClass.userSetting,
                  ),
                ],
              ),
            ),

            // ======================================================
            // LOGOUT
            // ======================================================

            _buildLogoutButton(),

            const SizedBox(height: 8),

            // ======================================================
            // VERSION
            // ======================================================

            _buildAppVersion(),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // PROFILE SECTION
  // ============================================================

  Widget _buildProfileSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        20,
        20,
        20,
        18,
      ),
      decoration: const BoxDecoration(
        color: MyColors.surface,
        border: Border(
          bottom: BorderSide(
            color: MyColors.border,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ==================================================
          // USER
          // ==================================================

          Row(
            children: [
              _buildAvatar(),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _kios.isEmpty ? 'KASIRA' : _kios,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: MySizes.fontSizeLg,
                        fontWeight: FontWeight.w700,
                        color: MyColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _phone.isEmpty ? 'Cashier Management' : _phone,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: MySizes.fontSizeSm,
                        color: MyColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // ==================================================
          // BRAND / OUTLET
          // ==================================================

          _buildOutletCard(),
        ],
      ),
    );
  }

  // ============================================================
  // AVATAR
  // ============================================================

  Widget _buildAvatar() {
    return Container(
      width: 56,
      height: 56,
      padding: const EdgeInsets.all(4),
      decoration: const BoxDecoration(
        color: MyColors.primaryLight,
        shape: BoxShape.circle,
      ),
      child: const CircleAvatar(
        backgroundColor: MyColors.surface,
        backgroundImage: AssetImage(
          'assets/clerk.png',
        ),
      ),
    );
  }

  // ============================================================
  // OUTLET CARD
  // ============================================================

  Widget _buildOutletCard() {
    return Material(
      color: MyColors.surfaceSoft,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        splashColor: MyColors.primary.withValues(alpha: .06),
        highlightColor: MyColors.primary.withValues(alpha: .03),
        onTap: () {
          Get.back();

          _showChangeOutlet(context);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 11,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: MyColors.border,
            ),
          ),
          child: Row(
            children: [
              // ==================================================
              // ICON
              // ==================================================

              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: MyColors.primaryLight,
                  borderRadius: BorderRadius.circular(9),
                ),
                child: const Icon(
                  Icons.storefront_outlined,
                  size: MySizes.iconSm,
                  color: MyColors.primaryDark,
                ),
              ),

              const SizedBox(width: 10),

              // ==================================================
              // TEXT
              // ==================================================

              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Brand & Outlet',
                      style: TextStyle(
                        fontSize: MySizes.fontSizeSm,
                        color: MyColors.textMuted,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Kelola outlet',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: MySizes.fontSizeSm,
                        fontWeight: FontWeight.w600,
                        color: MyColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              const Icon(
                Icons.swap_horiz_rounded,
                size: MySizes.iconSm,
                color: MyColors.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // SECTION TITLE
  // ============================================================

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 4,
      ),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: .8,
          color: MyColors.textMuted,
        ),
      ),
    );
  }

  // ============================================================
  // DRAWER ITEM
  // ============================================================

  Widget _buildDrawerItem({
    required IconData icon,
    required String text,
    String? route,
    VoidCallback? onTap,
  }) {
    final bool isActive = route != null && Get.currentRoute == route;

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 2,
      ),
      child: Material(
        color: isActive ? MyColors.primaryLight : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          splashColor: MyColors.primary.withValues(alpha: .06),
          highlightColor: MyColors.primary.withValues(alpha: .03),
          onTap: onTap ??
              () {
                Get.back();

                if (route != null) {
                  Get.toNamed(route);
                }
              },
          child: AnimatedContainer(
            duration: const Duration(
              milliseconds: 180,
            ),
            curve: Curves.easeOutCubic,
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 11,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isActive
                    ? MyColors.primary.withValues(alpha: .12)
                    : Colors.transparent,
              ),
            ),
            child: Row(
              children: [
                // ==================================================
                // ICON
                // ==================================================

                AnimatedContainer(
                  duration: const Duration(
                    milliseconds: 180,
                  ),
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: isActive ? MyColors.surface : MyColors.surfaceSoft,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    icon,
                    size: MySizes.iconSm,
                    color: isActive
                        ? MyColors.primaryDark
                        : MyColors.textSecondary,
                  ),
                ),

                const SizedBox(width: 12),

                // ==================================================
                // TEXT
                // ==================================================

                Expanded(
                  child: Text(
                    text,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: MySizes.fontSizeMd,
                      fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                      color: isActive
                          ? MyColors.primaryDark
                          : MyColors.textPrimary,
                    ),
                  ),
                ),

                // ==================================================
                // ACTIVE INDICATOR
                // ==================================================

                AnimatedContainer(
                  duration: const Duration(
                    milliseconds: 180,
                  ),
                  width: isActive ? 6 : 0,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: MyColors.primary,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // PRODUCT MENU
  // ============================================================

  // ============================================================
// PRODUCT MENU - ACCORDION
// ============================================================

  Widget _buildProductMenu() {
    final bool productActive = Get.currentRoute == RouterClass.listproduct ||
        Get.currentRoute == RouterClass.productcategory;

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 2,
      ),
      child: Material(
        color: productActive ? MyColors.primaryLight : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: productActive
                  ? MyColors.primary.withValues(alpha: .12)
                  : Colors.transparent,
            ),
          ),
          child: Column(
            children: [
              // ==================================================
              // PRODUCT HEADER
              // ==================================================

              InkWell(
                borderRadius: BorderRadius.circular(12),
                splashColor: MyColors.primary.withValues(alpha: .06),
                highlightColor: MyColors.primary.withValues(alpha: .03),
                onTap: () {
                  setState(() {
                    _productExpanded = !_productExpanded;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 11,
                  ),
                  child: Row(
                    children: [
                      // ICON
                      AnimatedContainer(
                        duration: const Duration(
                          milliseconds: 180,
                        ),
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: productActive
                              ? MyColors.surface
                              : MyColors.surfaceSoft,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.inventory_2_outlined,
                          size: MySizes.iconSm,
                          color: productActive
                              ? MyColors.primaryDark
                              : MyColors.textSecondary,
                        ),
                      ),

                      const SizedBox(width: 12),

                      // TEXT
                      Expanded(
                        child: Text(
                          'Product',
                          style: TextStyle(
                            fontSize: MySizes.fontSizeMd,
                            fontWeight: productActive
                                ? FontWeight.w700
                                : FontWeight.w500,
                            color: productActive
                                ? MyColors.primaryDark
                                : MyColors.textPrimary,
                          ),
                        ),
                      ),

                      // ARROW
                      AnimatedRotation(
                        duration: const Duration(
                          milliseconds: 200,
                        ),
                        curve: Curves.easeOutCubic,
                        turns: _productExpanded ? .5 : 0,
                        child: const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          size: 22,
                          color: MyColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ==================================================
              // SUB MENU
              // ==================================================

              AnimatedSize(
                duration: const Duration(
                  milliseconds: 220,
                ),
                curve: Curves.easeOutCubic,
                child: _productExpanded
                    ? Padding(
                        padding: const EdgeInsets.fromLTRB(
                          14,
                          0,
                          14,
                          10,
                        ),
                        child: Column(
                          children: [
                            _buildSubItem(
                              icon: Icons.category_outlined,
                              text: 'Category',
                              route: RouterClass.productcategory,
                            ),
                            _buildSubItem(
                              icon: Icons.inventory_2_outlined,
                              text: 'List Product',
                              route: RouterClass.listproduct,
                            ),
                          ],
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
// PRODUCT SUB ITEM
// ============================================================

  Widget _buildSubItem({
    required IconData icon,
    required String text,
    required String route,
  }) {
    final bool isActive = Get.currentRoute == route;

    return Padding(
      padding: const EdgeInsets.only(
        left: 48,
        top: 2,
        bottom: 2,
      ),
      child: Material(
        color: isActive ? MyColors.surface : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          splashColor: MyColors.primary.withValues(alpha: .06),
          highlightColor: MyColors.primary.withValues(alpha: .03),
          onTap: () {
            Get.back();
            Get.toNamed(route);
          },
          child: AnimatedContainer(
            duration: const Duration(
              milliseconds: 180,
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 9,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isActive
                    ? MyColors.primary.withValues(alpha: .10)
                    : Colors.transparent,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 17,
                  color: isActive ? MyColors.primary : MyColors.textMuted,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    text,
                    style: TextStyle(
                      fontSize: MySizes.fontSizeSm,
                      fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                      color: isActive
                          ? MyColors.primaryDark
                          : MyColors.textSecondary,
                    ),
                  ),
                ),
                if (isActive)
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: MyColors.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // MONITORING OUTLET
  // ============================================================

  void _openMonitoringOutlet() {
    Get.back();

    final MonitoringOutletController monitoringOutletController =
        Get.isRegistered<MonitoringOutletController>()
            ? Get.find<MonitoringOutletController>()
            : Get.put(
                MonitoringOutletController(),
              );

    monitoringOutletController.setKiosForTransaksiPerOutlet();

    Get.toNamed(
      RouterClass.monitoringoutlet,
    );
  }

  // ============================================================
  // LOGOUT
  // ============================================================

  Widget _buildLogoutButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        12,
        4,
        12,
        0,
      ),
      child: Material(
        color: MyColors.surface,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          splashColor: MyColors.error.withValues(alpha: .06),
          highlightColor: MyColors.error.withValues(alpha: .03),
          onTap: () {
            _confirmLogout(context);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 11,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: MyColors.border,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: MyColors.errorBg,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.logout_rounded,
                    size: MySizes.iconSm,
                    color: MyColors.error,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Logout',
                    style: TextStyle(
                      fontSize: MySizes.fontSizeMd,
                      fontWeight: FontWeight.w600,
                      color: MyColors.error,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // CONFIRM LOGOUT
  // ============================================================

  Future<void> _confirmLogout(BuildContext context) {
    return LogoutConfirmationDialog.show(
      context: context,
      onConfirm: () async {
        await loginController.logout();
      },
    );
  }

  // ============================================================
  // VERSION
  // ============================================================

  Widget _buildAppVersion() {
    return const Padding(
      padding: EdgeInsets.only(
        bottom: 12,
      ),
      child: Text(
        'KASIRA CMS',
        style: TextStyle(
          fontSize: 11,
          color: MyColors.textMuted,
        ),
      ),
    );
  }

  // ============================================================
  // CHANGE OUTLET
  // ============================================================

  void _showChangeOutlet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: MyColors.surface,
      constraints: const BoxConstraints(
        minWidth: double.infinity,
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (_) => const ChangeOutletPage(),
    );
  }
}
