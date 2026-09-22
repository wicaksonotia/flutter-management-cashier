import 'package:cashier_management/utils/colors.dart';
import 'package:flutter/material.dart';

class ProfileTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final int maxLines;

  const ProfileTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.keyboardType,
    this.textInputAction,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      maxLines: maxLines,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: Colors.black87,
      ),
      cursorColor: MyColors.primary,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        labelStyle: const TextStyle(
          fontSize: 13,
          color: Colors.black45,
        ),
        floatingLabelStyle: const TextStyle(
          fontSize: 13,
          color: MyColors.primary,
          fontWeight: FontWeight.w600,
        ),
        hintStyle: const TextStyle(
          fontSize: 13,
          color: Colors.black26,
        ),
        prefixIcon: Padding(
          padding: const EdgeInsets.only(
            left: 14,
            right: 10,
          ),
          child: Icon(
            icon,
            size: 20,
            color: Colors.black38,
          ),
        ),
        prefixIconConstraints: const BoxConstraints(
          minWidth: 48,
        ),
        filled: true,
        fillColor: const Color(0xFFF8F9FB),
        contentPadding: EdgeInsets.symmetric(
          horizontal: 16,
          vertical: maxLines > 1 ? 16 : 17,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: Colors.black.withValues(alpha: 0.05),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: MyColors.primary.withValues(alpha: 0.65),
            width: 1.3,
          ),
        ),
      ),
    );
  }
}
