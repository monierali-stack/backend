import 'package:flutter/material.dart';

import '../utils/app_colors.dart';

class DefaultBtn extends StatelessWidget {
  const DefaultBtn({
    super.key,
    required this.text,
    required this.onTap,
    this.outlined = false,
    this.loading = false,
  });

  final String text;
  final void Function()? onTap;
  final bool outlined;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: loading ? null : onTap,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: outlined ? AppColors.white : AppColors.primary,
          borderRadius: BorderRadius.circular(12),
          border: outlined ? Border.all(color: AppColors.primary, width: 1.5) : null,
          boxShadow: outlined
              ? null
              : [
                  BoxShadow(
                    offset: const Offset(0, 5),
                    blurRadius: 10,
                    spreadRadius: 0,
                    color: AppColors.primary.withValues(alpha: 0.35),
                  ),
                ],
        ),
        padding: const EdgeInsets.symmetric(vertical: 14),
        alignment: Alignment.center,
        child: loading
            ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2.4,
                  color: outlined ? AppColors.primary : AppColors.white,
                ),
              )
            : Text(
                text,
                style: TextStyle(
                  color: outlined ? AppColors.primary : AppColors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }
}
