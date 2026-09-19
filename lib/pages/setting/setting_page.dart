import 'package:cashier_management/routes.dart';
import 'package:cashier_management/utils/colors.dart';
import 'package:cashier_management/utils/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.background,
      appBar: _buildAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(
            20,
            8,
            20,
            32,
          ),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              _buildHeader(),

              const SizedBox(height: 28),

              // ==================================================
              // AKUN
              // ==================================================

              _buildSection(
                title: 'AKUN',
                children: [
                  _buildSettingItem(
                    icon: Icons.person_outline_rounded,
                    title: 'Profile',
                    subtitle:
                        'Informasi akun dan identitas pengguna',
                    onTap: () {
                      Get.toNamed(
                        RouterClass.profile,
                      );
                    },
                  ),
                  _buildSettingItem(
                    icon: Icons.lock_outline_rounded,
                    title: 'Keamanan',
                    subtitle:
                        'Kelola password dan keamanan akun',
                    onTap: () {
                      Get.toNamed(
                        RouterClass.changePassword,
                      );
                    },
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // ==================================================
              // APLIKASI
              // ==================================================

              _buildSection(
                title: 'APLIKASI',
                children: [
                  _buildSettingItem(
                    icon: Icons.palette_outlined,
                    title: 'Tampilan',
                    subtitle:
                        'Preferensi tampilan aplikasi',
                    onTap: () {
                      // TODO:
                      // Tambahkan halaman tampilan
                    },
                  ),
                  _buildSettingItem(
                    icon:
                        Icons.notifications_none_rounded,
                    title: 'Notifikasi',
                    subtitle:
                        'Atur preferensi pemberitahuan',
                    onTap: () {
                      // TODO:
                      // Tambahkan halaman notifikasi
                    },
                  ),
                  _buildSettingItem(
                    icon:
                        Icons.info_outline_rounded,
                    title: 'Tentang Aplikasi',
                    subtitle:
                        'Informasi versi dan aplikasi',
                    onTap: () {
                      _showAboutDialog(context);
                    },
                  ),
                ],
              ),

              const SizedBox(height: 30),

              _buildFooter(),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // APP BAR
  // ============================================================

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: MyColors.background,
      elevation: 0,
      surfaceTintColor:
          Colors.transparent,
      leading: IconButton(
        onPressed: () => Get.back(),
        icon: const Icon(
          Icons.arrow_back_ios_new_rounded,
          size: 19,
          color: MyColors.textPrimary,
        ),
      ),
      title: const Text(
        'Pengaturan',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: MyColors.textPrimary,
        ),
      ),
      centerTitle: false,
    );
  }

  // ============================================================
  // HEADER
  // ============================================================

  Widget _buildHeader() {
    return const Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Text(
          'Kelola aplikasi',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            letterSpacing: -.6,
            color: MyColors.textPrimary,
          ),
        ),
        SizedBox(height: 7),
        Text(
          'Atur akun dan preferensi aplikasi.',
          style: TextStyle(
            fontSize: MySizes.fontSizeMd,
            height: 1.45,
            color: MyColors.textSecondary,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // SECTION
  // ============================================================

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: 4,
            bottom: 9,
          ),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: .9,
              color: MyColors.textMuted,
            ),
          ),
        ),

        Container(
          decoration: BoxDecoration(
            color: MyColors.surface,
            borderRadius:
                BorderRadius.circular(16),
            border: Border.all(
              color: MyColors.border,
            ),
          ),
          child: Column(
            children: _withDividers(children),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // SETTING ITEM
  // ============================================================

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        splashColor:
            MyColors.primary.withValues(alpha: .04),
        highlightColor:
            MyColors.primary.withValues(alpha: .025),
        child: Padding(
          padding:
              const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration:
                    BoxDecoration(
                  color: MyColors.surfaceSoft,
                  borderRadius:
                      BorderRadius.circular(
                    12,
                  ),
                ),
                child: Icon(
                  icon,
                  size: 21,
                  color:
                      MyColors.textSecondary,
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow:
                          TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize:
                            MySizes.fontSizeMd,
                        fontWeight:
                            FontWeight.w600,
                        color:
                            MyColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      maxLines: 2,
                      overflow:
                          TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize:
                            MySizes.fontSizeSm,
                        height: 1.3,
                        color:
                            MyColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 10),

              const Icon(
                Icons.chevron_right_rounded,
                size: 22,
                color: MyColors.textMuted,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // DIVIDERS
  // ============================================================

  List<Widget> _withDividers(
    List<Widget> children,
  ) {
    final List<Widget> result = [];

    for (int i = 0;
        i < children.length;
        i++) {
      result.add(children[i]);

      if (i < children.length - 1) {
        result.add(
          const Divider(
            height: 1,
            thickness: .7,
            indent: 72,
            color: MyColors.border,
          ),
        );
      }
    }

    return result;
  }

  // ============================================================
  // ABOUT
  // ============================================================

  void _showAboutDialog(
    BuildContext context,
  ) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          backgroundColor:
              MyColors.surface,
          shape:
              RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(20),
          ),
          title: const Text(
            'KASIRA CMS',
            style: TextStyle(
              fontWeight:
                  FontWeight.w700,
              color:
                  MyColors.textPrimary,
            ),
          ),
          content: const Column(
            mainAxisSize:
                MainAxisSize.min,
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                'Cashier Management System',
                style: TextStyle(
                  color:
                      MyColors.textSecondary,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Version 1.0.0',
                style: TextStyle(
                  fontSize:
                      MySizes.fontSizeSm,
                  color:
                      MyColors.textMuted,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () =>
                  Get.back(),
              child: const Text(
                'Tutup',
                style: TextStyle(
                  color:
                      MyColors.primaryDark,
                  fontWeight:
                      FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // FOOTER
  // ============================================================

  Widget _buildFooter() {
    return Center(
      child: Column(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration:
                const BoxDecoration(
              color:
                  MyColors.primaryLight,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.storefront_outlined,
              size: 21,
              color:
                  MyColors.primaryDark,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'KASIRA CMS',
            style: TextStyle(
              fontSize:
                  MySizes.fontSizeSm,
              fontWeight:
                  FontWeight.w700,
              color:
                  MyColors.textSecondary,
            ),
          ),
          const SizedBox(height: 3),
          const Text(
            'Cashier Management System',
            style: TextStyle(
              fontSize: 11,
              color:
                  MyColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}