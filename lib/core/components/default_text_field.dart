import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../utils/app_colors.dart';

class DefaultTextField extends StatelessWidget {
  const DefaultTextField({
    super.key,
    this.onChanged,
    this.validator,
    required this.controller,
    this.obscureText = false,
    this.suffixIcon,
    required this.hint,
    this.prefixPath,
    this.prefixIcon,
    this.keyboardType,
  });

  final String hint;
  final String? prefixPath;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: onChanged,
      validator: validator,
      controller: controller,
      keyboardType: keyboardType,
      obscuringCharacter: '*',
      obscureText: obscureText,
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.fieldFill,
        hintText: hint,
        hintStyle: TextStyle(
          fontSize: 14,
          color: AppColors.darkGery,
          fontWeight: FontWeight.w400,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.primary),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red),
        ),
        suffixIcon: suffixIcon,
        prefixIcon: prefixPath != null
            ? Padding(
                padding: const EdgeInsets.all(20.0),
                child: SvgPicture.asset(
                  prefixPath!,
                  height: 24,
                  width: 24,
                ),
              )
            : prefixIcon != null
                ? Icon(prefixIcon, color: AppColors.darkGery, size: 20)
                : null,
      ),
    );
  }
}
