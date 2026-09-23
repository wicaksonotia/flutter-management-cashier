import 'package:cashier_management/controllers/login_controller.dart';
import 'package:cashier_management/pages/navigation_drawer.dart'
    as custom_drawer;
import 'package:cashier_management/routes.dart';
import 'package:cashier_management/utils/colors.dart';
import 'package:cashier_management/utils/confirm_dialog.dart';
import 'package:cashier_management/utils/management_header.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserSetting extends StatelessWidget {
  const UserSetting({super.key});

  @override
  Widget build(BuildContext context) {
    final LoginController loginController = Get.find<LoginController>();

    return Scaffold(
      drawer: const custom_drawer.NavigationDrawer(),
      backgroundColor: MyColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // =====================================================
              // HEADER
              // =====================================================

              ManagementHeader(
                title: 'Settings',
                subtitle: 'Kelola pengaturan akun dan aplikasi',
              ),

              const SizedBox(height: 10),

              // =====================================================
              // ACCOUNT
              // =====================================================

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: _AccountHeader(),
              ),

              const SizedBox(height: 28),

              // =====================================================
              // ACCOUNT SECTION
              // =====================================================

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: _SectionHeader(
                  title: 'Account',
                  subtitle: 'Manage your personal account',
                ),
              ),

              const SizedBox(height: 12),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _SettingsCard(
                  children: [
                    _SettingsTile(
                      icon: Icons.person_outline_rounded,
                      iconBackground: MyColors.primary.withValues(
                        alpha: 0.10,
                      ),
                      iconColor: MyColors.primary,
                      title: 'Profile',
                      subtitle: 'View and manage your profile',
                      onTap: () {
                        Get.toNamed(RouterClass.profile);
                      },
                    ),
                    const _SettingsDivider(),
                    _SettingsTile(
                      icon: Icons.lock_outline_rounded,
                      iconBackground: MyColors.warning.withValues(
                        alpha: 0.10,
                      ),
                      iconColor: MyColors.warning,
                      title: 'Change Password',
                      subtitle: 'Update your account password',
                      onTap: () {
                        Get.toNamed(
                          RouterClass.changePassword,
                        );
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // =====================================================
              // SUPPORT SECTION
              // =====================================================

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: _SectionHeader(
                  title: 'Support',
                  subtitle: 'Find answers and get help',
                ),
              ),

              const SizedBox(height: 12),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _SettingsCard(
                  children: [
                    _SettingsTile(
                      icon: Icons.help_outline_rounded,
                      iconBackground: MyColors.info.withValues(
                        alpha: 0.10,
                      ),
                      iconColor: MyColors.info,
                      title: 'FAQ',
                      subtitle: 'Frequently asked questions',
                      onTap: () {
                        // TODO:
                        // Tambahkan route FAQ ketika halaman FAQ
                        // sudah dibuat.
                      },
                    ),
                    const _SettingsDivider(),
                    const _VersionTile(),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // =====================================================
              // LOGOUT
              // =====================================================

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _LogoutButton(
                  onPressed: () {
                    _confirmLogout(
                      context,
                      loginController,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _confirmLogout(
    BuildContext context,
    LoginController loginController,
  ) async {
    final confirmed = await AppConfirmDialog.show(
      context,
      title: 'Keluar dari Aplikasi',
      message: 'Apakah Anda yakin ingin logout dari akun ini?',
      confirmText: 'Logout',
      cancelText: 'Batal',
      icon: Icons.logout_rounded,
      type: AppConfirmType.danger,
    );

    if (!confirmed) return;

    await loginController.logout();
  }
}

// ================================================================
// ACCOUNT HEADER
// ================================================================

class _AccountHeader extends StatelessWidget {
  const _AccountHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: MyColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: MyColors.border,
        ),
        boxShadow: [
          BoxShadow(
            color: MyColors.textPrimary.withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          const _ProfileAvatar(),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Admin / Owner',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: MyColors.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Container(
                      width: 7,
                      height: 7,
                      decoration: const BoxDecoration(
                        color: MyColors.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 7),
                    const Text(
                      'Administrator',
                      style: TextStyle(
                        color: MyColors.textSecondary,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ================================================================
// PROFILE AVATAR
// ================================================================

class _ProfileAvatar extends StatelessWidget {
  const _ProfileAvatar();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: MyColors.primary.withValues(alpha: 0.10),
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.person_rounded,
        size: 30,
        color: MyColors.primary,
      ),
    );
  }
}

// ================================================================
// SECTION HEADER
// ================================================================

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: MyColors.textPrimary,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(
              color: MyColors.textSecondary,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

// ================================================================
// SETTINGS CARD
// ================================================================

class _SettingsCard extends StatelessWidget {
  const _SettingsCard({
    required this.children,
  });

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: MyColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: MyColors.border,
        ),
        boxShadow: [
          BoxShadow(
            color: MyColors.textPrimary.withValues(alpha: 0.035),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: children,
      ),
    );
  }
}

// ================================================================
// SETTINGS TILE
// ================================================================

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.iconBackground,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final Color iconBackground;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          child: Row(
            children: [
              _MenuIcon(
                icon: icon,
                backgroundColor: iconBackground,
                iconColor: iconColor,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: MyColors.textPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: MyColors.textSecondary,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              const Icon(
                Icons.chevron_right_rounded,
                size: 22,
                color: MyColors.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ================================================================
// MENU ICON
// ================================================================

class _MenuIcon extends StatelessWidget {
  const _MenuIcon({
    required this.icon,
    required this.backgroundColor,
    required this.iconColor,
  });

  final IconData icon;
  final Color backgroundColor;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(13),
      ),
      child: Icon(
        icon,
        size: 21,
        color: iconColor,
      ),
    );
  }
}

// ================================================================
// DIVIDER
// ================================================================

class _SettingsDivider extends StatelessWidget {
  const _SettingsDivider();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(left: 74),
      child: Divider(
        height: 1,
        thickness: 0.6,
        color: MyColors.border,
      ),
    );
  }
}

// ================================================================
// VERSION TILE
// ================================================================

class _VersionTile extends StatelessWidget {
  const _VersionTile();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 15,
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: MyColors.textSecondary.withValues(
                alpha: 0.10,
              ),
              borderRadius: BorderRadius.circular(13),
            ),
            child: const Icon(
              Icons.info_outline_rounded,
              size: 21,
              color: MyColors.textSecondary,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Application Version',
                  style: TextStyle(
                    color: MyColors.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Cashier Management',
                  style: TextStyle(
                    color: MyColors.textSecondary,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          const Text(
            '1.0.0',
            style: TextStyle(
              color: MyColors.textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// ================================================================
// LOGOUT BUTTON
// ================================================================

class _LogoutButton extends StatelessWidget {
  const _LogoutButton({
    required this.onPressed,
  });

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: const Icon(
          Icons.logout_rounded,
          size: 19,
        ),
        label: const Text(
          'Logout',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: OutlinedButton.styleFrom(
          foregroundColor: MyColors.error,
          backgroundColor: MyColors.surface,
          side: BorderSide(
            color: MyColors.error.withValues(alpha: 0.25),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}
