import 'package:cashier_management/utils/colors.dart';
import 'package:flutter/material.dart';

class ProductManagementHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final String addLabel;

  final VoidCallback onAddTap;
  final VoidCallback? onMenuTap;

  const ProductManagementHeader({
    super.key,
    required this.title,
    required this.subtitle,
    required this.addLabel,
    required this.onAddTap,
    this.onMenuTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 4),
      child: Row(
        children: [
          Builder(
            builder: (context) {
              return _HeaderIconButton(
                icon: Icons.menu_rounded,
                onTap: onMenuTap ?? () => Scaffold.of(context).openDrawer(),
              );
            },
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: MyColors.textPrimary,
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: MyColors.textSecondary,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Material(
            color: MyColors.primary,
            borderRadius: BorderRadius.circular(12),
            child: InkWell(
              onTap: onAddTap,
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 13,
                  vertical: 10,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.add_rounded,
                      size: 19,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      addLabel,
                      style: const TextStyle(
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
            border: Border.all(color: MyColors.border),
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
