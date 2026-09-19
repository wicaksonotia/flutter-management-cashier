import 'package:cashier_management/utils/colors.dart';
import 'package:flutter/material.dart';

class ProductManagementTabs extends StatelessWidget {
  final TabController controller;

  const ProductManagementTabs({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        height: 46,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: MyColors.surfaceSoft,
          borderRadius: BorderRadius.circular(14),
        ),
        child: TabBar(
          controller: controller,
          dividerColor: Colors.transparent,
          indicator: BoxDecoration(
            color: MyColors.surface,
            borderRadius: BorderRadius.circular(11),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: .05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          indicatorSize: TabBarIndicatorSize.tab,
          labelColor: MyColors.primary,
          unselectedLabelColor: MyColors.textSecondary,
          labelStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w800,
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
          tabs: const [
            Tab(
              icon: Icon(
                Icons.inventory_2_outlined,
                size: 18,
              ),
              text: 'Produk',
              iconMargin: EdgeInsets.only(bottom: 2),
            ),
            Tab(
              icon: Icon(
                Icons.category_outlined,
                size: 18,
              ),
              text: 'Kategori',
              iconMargin: EdgeInsets.only(bottom: 2),
            ),
          ],
        ),
      ),
    );
  }
}
