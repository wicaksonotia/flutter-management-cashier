import 'package:flutter/material.dart';

class ManagementActionButton extends StatelessWidget {
  final IconData icon;
  final String? label;
  final Color background;
  final Color foreground;
  final VoidCallback? onTap;

  final double height;
  final double iconSize;
  final double fontSize;

  /// Digunakan untuk button yang memenuhi lebar parent
  /// tetapi isi icon / label harus berada di tengah.
  final bool centerContent;

  const ManagementActionButton({
    super.key,
    required this.icon,
    required this.background,
    required this.foreground,
    this.label,
    this.onTap,
    this.height = 32,
    this.iconSize = 14,
    this.fontSize = 9,
    this.centerContent = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: background,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          height: height,
          padding: EdgeInsets.symmetric(
            horizontal: label == null ? 8 : 7,
          ),
          child: Row(
            mainAxisSize: centerContent ? MainAxisSize.max : MainAxisSize.min,
            mainAxisAlignment: centerContent
                ? MainAxisAlignment.center
                : MainAxisAlignment.start,
            children: [
              Icon(
                icon,
                size: iconSize,
                color: foreground,
              ),
              if (label != null) ...[
                const SizedBox(width: 4),
                Text(
                  label!,
                  style: TextStyle(
                    color: foreground,
                    fontSize: fontSize,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
