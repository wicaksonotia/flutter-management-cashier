import 'package:cashier_management/utils/colors.dart';
import 'package:flutter/material.dart';

class ProductManagementHeader extends StatelessWidget {
  final VoidCallback onAddTap;
  final VoidCallback? onMenuTap;

  const ProductManagementHeader({
    super.key,
    required this.onAddTap,
    this.onMenuTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 4),
      child: Row(
        children: [
          // ======================================================
          // MENU
          // ======================================================

          Builder(
            builder: (context) {
              return _HeaderIconButton(
                icon: Icons.menu_rounded,
                onTap: onMenuTap ??
                    () {
                      Scaffold.of(context).openDrawer();
                    },
              );
            },
          ),

          const SizedBox(width: 12),

          // ======================================================
          // TITLE
          // ======================================================

          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Produk',
                  style: TextStyle(
                    color: MyColors.textPrimary,
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Kelola katalog produk',
                  style: TextStyle(
                    color: MyColors.textSecondary,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          // ======================================================
          // ADD
          // ======================================================

          Material(
            color: MyColors.primary,
            borderRadius: BorderRadius.circular(12),
            child: InkWell(
              onTap: onAddTap,
              borderRadius: BorderRadius.circular(12),
              child: const Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 13,
                  vertical: 10,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.add_rounded,
                      size: 19,
                      color: Colors.white,
                    ),
                    SizedBox(width: 5),
                    Text(
                      'Tambah',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _HeaderIconButton({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: MyColors.surface,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: MyColors.border,
            ),
          ),
          child: Icon(
            icon,
            size: 20,
            color: MyColors.textPrimary,
          ),
        ),
      ),
    );
  }
}
