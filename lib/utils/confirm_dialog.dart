import 'package:cashier_management/utils/colors.dart';
import 'package:flutter/material.dart';

enum AppConfirmType {
  primary,
  success,
  warning,
  danger,
}

class AppConfirmDialog extends StatelessWidget {
  final String title;
  final String message;
  final String confirmText;
  final String cancelText;
  final IconData icon;
  final AppConfirmType type;
  final VoidCallback onConfirm;

  const AppConfirmDialog({
    super.key,
    required this.title,
    required this.message,
    required this.onConfirm,
    this.confirmText = 'Konfirmasi',
    this.cancelText = 'Batal',
    this.icon = Icons.help_outline_rounded,
    this.type = AppConfirmType.primary,
  });

  Color get _accentColor {
    switch (type) {
      case AppConfirmType.primary:
        return MyColors.primary;
      case AppConfirmType.success:
        return MyColors.success;
      case AppConfirmType.warning:
        return MyColors.warning;
      case AppConfirmType.danger:
        return MyColors.error;
    }
  }

  Color get _accentBackground {
    switch (type) {
      case AppConfirmType.primary:
        return MyColors.primaryLight;
      case AppConfirmType.success:
        return MyColors.successBg;
      case AppConfirmType.warning:
        return MyColors.warningBg;
      case AppConfirmType.danger:
        return MyColors.errorBg;
    }
  }

  static Future<bool> show(
    BuildContext context, {
    required String title,
    required String message,
    String confirmText = 'Konfirmasi',
    String cancelText = 'Batal',
    IconData icon = Icons.help_outline_rounded,
    AppConfirmType type = AppConfirmType.primary,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) {
        return AppConfirmDialog(
          title: title,
          message: message,
          confirmText: confirmText,
          cancelText: cancelText,
          icon: icon,
          type: type,
          onConfirm: () {
            Navigator.of(dialogContext).pop(true);
          },
        );
      },
    );

    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 24,
      ),
      child: Container(
        width: 420,
        decoration: BoxDecoration(
          color: MyColors.surface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: MyColors.border,
          ),
          boxShadow: const [
            BoxShadow(
              color: MyColors.shadow,
              blurRadius: 30,
              offset: Offset(0, 12),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            24,
            24,
            24,
            20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _DialogIcon(
                icon: icon,
                color: _accentColor,
                backgroundColor: _accentBackground,
              ),
              const SizedBox(height: 18),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: MyColors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 9),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: MyColors.textSecondary,
                  fontSize: 13,
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: _DialogButton(
                      text: cancelText,
                      backgroundColor: MyColors.surfaceSoft,
                      foregroundColor: MyColors.textSecondary,
                      onTap: () {
                        Navigator.of(context).pop(false);
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _DialogButton(
                      text: confirmText,
                      backgroundColor: _accentColor,
                      foregroundColor: Colors.white,
                      onTap: onConfirm,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DialogIcon extends StatelessWidget {
  final IconData icon;
  final Color color;
  final Color backgroundColor;

  const _DialogIcon({
    required this.icon,
    required this.color,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 58,
      height: 58,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Icon(
        icon,
        size: 28,
        color: color,
      ),
    );
  }
}

class _DialogButton extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final Color foregroundColor;
  final VoidCallback onTap;

  const _DialogButton({
    required this.text,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
