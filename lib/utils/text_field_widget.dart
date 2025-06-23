import 'package:cashier_management/utils/colors.dart';
import 'package:flutter/material.dart';

class TextFieldWidget extends StatelessWidget {
  const TextFieldWidget(
      {super.key,
      this.controller,
      required this.labelText,
      required this.hint,
      this.obscureText = false,
      this.validator,
      this.onChanged,
      this.onEditingComplete,
      this.suffixIcon,
      this.onTapSuffixIcon,
      this.prefixIcon,
      this.filled = false,
      this.enabled = true,
      this.initialValue,
      this.keyboardType = TextInputType.text,
      this.maxLines = 1});
  final String labelText;
  final String hint;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onTapSuffixIcon;
  final bool obscureText;
  final bool filled;
  final bool enabled;
  final String? initialValue;
  final TextInputType keyboardType;
  final int maxLines;

  final TextEditingController? controller;
  final Function()? onEditingComplete;

  final String? Function(String?)? validator;
  final Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: TextFormField(
        controller: controller,
        initialValue: initialValue,
        maxLines: maxLines,
        onEditingComplete: onEditingComplete,
        onChanged: onChanged,
        validator: validator,
        obscureText: obscureText,
        keyboardType: keyboardType,
        style: const TextStyle(fontFamily: "Inter", fontSize: 16),
        textCapitalization: TextCapitalization.characters,
        decoration: InputDecoration(
          labelText: labelText,
          contentPadding: const EdgeInsets.all(0),
          fillColor: Colors.white,
          border: const OutlineInputBorder(
            // borderRadius: BorderRadius.circular(10),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              bottomLeft: Radius.circular(10),
            ),
            borderSide: BorderSide(
              color: Colors.white,
              width: 0.0,
            ),
          ),
          enabledBorder: const OutlineInputBorder(
            // borderRadius: BorderRadius.circular(10),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              bottomLeft: Radius.circular(10),
            ),
            borderSide: BorderSide(
              color: Colors.white,
              width: 0.0,
            ),
          ),
          focusedBorder: const OutlineInputBorder(
            // borderRadius: BorderRadius.circular(10),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              bottomLeft: Radius.circular(10),
            ),
            borderSide: BorderSide(
              color: Colors.white,
              width: 0.0,
            ),
          ),
          hintText: hint,
          hintStyle: const TextStyle(
            fontFamily: "Inter",
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          prefixIcon: prefixIcon != null
              ? Icon(
                  prefixIcon,
                  color: MyColors.primary,
                  size: 25,
                )
              : null,
          suffixIcon: suffixIcon != null
              ? IconButton(
                  icon: Icon(
                    suffixIcon,
                    color: MyColors.primary,
                    size: 25,
                  ),
                  onPressed: onTapSuffixIcon,
                )
              : null,
          filled: filled,
          // enabled: enabled,
        ),
      ),
    );
  }
}
