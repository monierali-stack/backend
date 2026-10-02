import 'package:flutter/material.dart';
import 'package:shop/core/components/network_or_placeholder.dart';
import 'package:shop/core/utils/app_colors.dart';
import 'package:shop/features/shop/data/models/order_model.dart';

class OrderCard extends StatelessWidget {
  const OrderCard({
    super.key,
    required this.order,
    this.onTap,
    this.onCancel,
    this.onTrackDriver,
  });

  final OrderModel order;
  final void Function()? onTap;
  final void Function()? onCancel;
  final void Function()? onTrackDriver;

  String get _formattedDate {
    final d = order.placedAt;
    final hour = d.hour % 12 == 0 ? 12 : d.hour % 12;
    final period = d.hour >= 12 ? 'pm' : 'am';
    final minute = d.minute.toString().padLeft(2, '0');
    return '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year} $hour:$minute $period';
  }

  @override
  Widget build(BuildContext context) {
    if (order.items.isEmpty) return const SizedBox.shrink();
    final firstItem = order.items.first;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.inactiveDot),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: NetworkOrPlaceholder(
                    url: firstItem.productImage,
                    width: 56,
                    height: 56,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        firstItem.productName,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.black,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _formattedDate,
                        style: TextStyle(fontSize: 11, color: AppColors.darkGery),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${order.itemCount} item${order.itemCount > 1 ? 's' : ''}',
                        style: TextStyle(fontSize: 11, color: AppColors.darkGery),
                      ),
                    ],
                  ),
                ),
                Text(
                  '\$${order.subtotal.toStringAsFixed(0)}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.black,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            if (order.status == OrderStatus.active)
              Row(
                children: [
                  Expanded(
                    child: _OrderActionButton(
                      label: 'Cancel',
                      filled: false,
                      onTap: onCancel,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _OrderActionButton(
                      label: 'Track Driver',
                      filled: true,
                      onTap: onTrackDriver,
                    ),
                  ),
                ],
              )
            else
              Row(
                children: [
                  Icon(
                    order.status == OrderStatus.completed
                        ? Icons.check_circle_outline
                        : Icons.cancel_outlined,
                    size: 16,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    order.status == OrderStatus.completed
                        ? 'Order delivered'
                        : 'Order Canceled',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class _OrderActionButton extends StatelessWidget {
  const _OrderActionButton({required this.label, required this.filled, this.onTap});

  final String label;
  final bool filled;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: filled ? AppColors.primary : AppColors.fieldFill,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: filled ? AppColors.white : AppColors.black,
          ),
        ),
      ),
    );
  }
}
