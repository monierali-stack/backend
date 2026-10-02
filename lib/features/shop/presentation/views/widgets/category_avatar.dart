import 'package:flutter/material.dart';
import 'package:shop/core/components/network_or_placeholder.dart';
import 'package:shop/core/utils/app_colors.dart';
import 'package:shop/features/shop/data/models/category_model.dart';

class CategoryAvatar extends StatelessWidget {
  const CategoryAvatar({
    super.key,
    required this.category,
    this.isSelected = false,
    this.onTap,
  });

  final CategoryModel category;
  final bool isSelected;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? AppColors.primary : Colors.transparent,
                width: 2,
              ),
            ),
            child: ClipOval(
              child: NetworkOrPlaceholder(
                url: category.image,
                width: 56,
                height: 56,
              ),
            ),
          ),
          const SizedBox(height: 6),
          SizedBox(
            width: 60,
            child: Text(
              category.name,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isSelected ? AppColors.primary : AppColors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
