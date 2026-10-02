import 'package:flutter/material.dart';
import 'package:shop/core/components/network_or_placeholder.dart';
import 'package:shop/core/utils/app_colors.dart';

// Decoupled from ProductModel so it can render both live cart/checkout
// rows (from ProductModel) and past-order rows (from OrderItemModel,
// which is a lighter snapshot without a rating/originalPrice).
class CartProductRow extends StatelessWidget {
  const CartProductRow({
    super.key,
    required this.name,
    required this.image,
    required this.price,
    required this.quantity,
    this.rating,
    this.originalPrice,
    this.editable = true,
    this.onIncrement,
    this.onDecrement,
  });

  final String name;
  final String? image;
  final double price;
  final double? originalPrice;
  final double? rating;
  final int quantity;
  final bool editable;
  final void Function()? onIncrement;
  final void Function()? onDecrement;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: NetworkOrPlaceholder(url: image, width: 68, height: 68),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppColors.black,
                    ),
                  ),
                  if (rating != null) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.star, size: 14, color: Colors.amber),
                        const SizedBox(width: 2),
                        Text(
                          '$rating',
                          style: TextStyle(fontSize: 12, color: AppColors.darkGery),
                        ),
                      ],
                    ),
                  ],
                  if (!editable) ...[
                    const SizedBox(height: 4),
                    Text(
                      '$quantity item${quantity > 1 ? 's' : ''}',
                      style: TextStyle(fontSize: 12, color: AppColors.darkGery),
                    ),
                  ],
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  children: [
                    Text(
                      '\$${price.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.black,
                      ),
                    ),
                    if (originalPrice != null) ...[
                      const SizedBox(width: 6),
                      Text(
                        '\$${originalPrice!.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.darkGery,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ],
                  ],
                ),
                if (editable) ...[
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      _StepperDot(icon: Icons.remove, onTap: onDecrement),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          '$quantity',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.black,
                          ),
                        ),
                      ),
                      _StepperDot(icon: Icons.add, onTap: onIncrement, filled: true),
                    ],
                  ),
                ],
              ],
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Total Order ($quantity) :',
              style: TextStyle(fontSize: 12, color: AppColors.darkGery),
            ),
            Text(
              '\$${(price * quantity).toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: AppColors.black,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Divider(color: AppColors.inactiveDot),
        const SizedBox(height: 16),
      ],
    );
  }
}

class _StepperDot extends StatelessWidget {
  const _StepperDot({required this.icon, this.onTap, this.filled = false});

  final IconData icon;
  final void Function()? onTap;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 22,
        width: 22,
        decoration: BoxDecoration(
          color: filled ? AppColors.primary : AppColors.fieldFill,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: 13,
          color: filled ? AppColors.white : AppColors.black,
        ),
      ),
    );
  }
}
