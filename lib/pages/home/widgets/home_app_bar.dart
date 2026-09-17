import 'package:cashier_management/controllers/kios_controller.dart';
import 'package:cashier_management/pages/change_outlet_page.dart';
import 'package:cashier_management/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final KiosController kiosController;

  const HomeAppBar({
    super.key,
    required this.kiosController,
  });

  @override
  Size get preferredSize => const Size.fromHeight(76);

  void _showOutletSelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const ChangeOutletPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: MyColors.background,
      surfaceTintColor: Colors.transparent,
      automaticallyImplyLeading: false,
      toolbarHeight: 76,
      titleSpacing: 16,
      title: Row(
        children: [
          Builder(
            builder: (context) {
              return Material(
                color: MyColors.surface,
                borderRadius: BorderRadius.circular(14),
                child: InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: () {
                    Scaffold.of(context).openDrawer();
                  },
                  child: const SizedBox(
                    width: 44,
                    height: 44,
                    child: Icon(
                      Icons.menu_rounded,
                      color: MyColors.textPrimary,
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Obx(
              () => GestureDetector(
                onTap: () => _showOutletSelector(context),
                behavior: HitTestBehavior.opaque,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Outlet aktif',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: MyColors.textMuted,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            kiosController.selectedKios.value,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: MyColors.textPrimary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 3),
                        const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          size: 18,
                          color: MyColors.textSecondary,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: MyColors.primaryLight,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.person_rounded,
              color: MyColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}
