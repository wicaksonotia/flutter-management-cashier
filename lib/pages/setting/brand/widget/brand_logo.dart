import 'package:cashier_management/database/api_endpoints.dart';
import 'package:cashier_management/utils/colors.dart';
import 'package:flutter/material.dart';

class BrandLogo extends StatelessWidget {
  final String? logo;

  const BrandLogo({
    super.key,
    required this.logo,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 68,
      height: 68,
      decoration: BoxDecoration(
        color: MyColors.surfaceSoft,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: MyColors.border,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: logo != null && logo!.trim().isNotEmpty
          ? Image.network(
              '${ApiEndPoints.ipPublic}images/logo/$logo',
              fit: BoxFit.contain,
              errorBuilder: (
                context,
                error,
                stackTrace,
              ) {
                return const _LogoPlaceholder();
              },
            )
          : const _LogoPlaceholder(),
    );
  }
}

class _LogoPlaceholder extends StatelessWidget {
  const _LogoPlaceholder();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Icon(
        Icons.storefront_outlined,
        size: 29,
        color: MyColors.textMuted,
      ),
    );
  }
}
