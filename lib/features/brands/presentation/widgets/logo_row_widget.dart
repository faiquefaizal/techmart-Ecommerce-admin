import 'package:flutter/material.dart';
import 'package:techmart_admin/features/brands/models/brand_model.dart';

class LogoRowWidget extends StatelessWidget {
  final BrandModel brand;
  const LogoRowWidget({super.key, required this.brand});

  @override
  Widget build(BuildContext context) {
    return Image.network(
      brand.imageUrl,
      width: 50,
      height: 50,
      errorBuilder:
          (context, error, stackTrace) =>
              const Icon(Icons.broken_image, size: 50),
    );
  }
}
