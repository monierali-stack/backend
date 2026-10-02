import 'package:flutter/material.dart';
import 'package:shop/core/utils/app_colors.dart';

class NetworkOrPlaceholder extends StatelessWidget {
  const NetworkOrPlaceholder({
    super.key,
    required this.url,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.borderRadius,
    this.iconSize = 28,
  });

  final String? url;
  final BoxFit fit;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    Widget child;
    if (url == null || url!.isEmpty) {
      child = _placeholder();
    } else {
      child = Image.network(
        url!,
        fit: fit,
        width: width,
        height: height,
        loadingBuilder: (context, widget, progress) {
          if (progress == null) return widget;
          return _placeholder(loading: true);
        },
        errorBuilder: (context, error, stackTrace) => _placeholder(),
      );
    }
    if (borderRadius != null) {
      return ClipRRect(borderRadius: borderRadius!, child: child);
    }
    return child;
  }

  Widget _placeholder({bool loading = false}) {
    return Container(
      width: width,
      height: height,
      color: AppColors.fieldFill,
      alignment: Alignment.center,
      child: loading
          ? SizedBox(
              width: iconSize * 0.7,
              height: iconSize * 0.7,
              child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary),
            )
          : Icon(Icons.image_outlined, size: iconSize, color: AppColors.darkGery),
    );
  }
}
