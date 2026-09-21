import 'package:flutter/material.dart';

import 'package:cashier_management/utils/colors.dart';
import 'package:cashier_management/utils/sizes.dart';

class AppBackHeader extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBack;
  final Color? backgroundColor;
  final Color? titleColor;
  final bool centerTitle;

  const AppBackHeader({
    super.key,
    required this.title,
    this.onBack,
    this.backgroundColor,
    this.titleColor,
    this.centerTitle = false,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: backgroundColor ?? MyColors.background,
      surfaceTintColor: Colors.transparent,
      centerTitle: centerTitle,
      leading: IconButton(
        onPressed: onBack ??
            () {
              Navigator.of(context).maybePop();
            },
        icon: Icon(
          Icons.arrow_back_ios_new_rounded,
          size: 19,
          color: titleColor ?? MyColors.textPrimary,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: MySizes.fontSizeHeader,
          fontWeight: FontWeight.w700,
          color: titleColor ?? MyColors.textPrimary,
        ),
      ),
    );
  }
}
