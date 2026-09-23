import 'package:cashier_management/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputField extends StatelessWidget {
  final String label;
  final IconData icon;
  final TextEditingController controller;
  final int maxLines;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final String? hint;
  final String? helperText;
  final bool enabled;

  const InputField({
    super.key,
    required this.label,
    required this.icon,
    required this.controller,
    this.maxLines = 1,
    this.keyboardType,
    this.inputFormatters,
    this.hint,
    this.helperText,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      enabled: enabled,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: MyColors.textPrimary,
      ),
      cursorColor: MyColors.primary,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        helperText: helperText,
        helperMaxLines: 2,
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        labelStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: MyColors.textSecondary,
        ),
        floatingLabelStyle: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: MyColors.primary,
        ),
        helperStyle: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: MyColors.textMuted,
          height: 1.3,
        ),
        prefixIcon: Padding(
          padding: const EdgeInsets.only(
            left: 13,
            right: 10,
          ),
          child: Icon(
            icon,
            size: 19,
            color: MyColors.textSecondary,
          ),
        ),
        prefixIconConstraints: const BoxConstraints(
          minWidth: 48,
          minHeight: 48,
        ),
        filled: true,
        fillColor: MyColors.background,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 15,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
          borderSide: const BorderSide(
            color: MyColors.border,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
          borderSide: const BorderSide(
            color: MyColors.border,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
          borderSide: BorderSide(
            color: MyColors.primary.withValues(alpha: .65),
            width: 1.3,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
          borderSide: const BorderSide(
            color: MyColors.border,
          ),
        ),
      ),
    );
  }
}
