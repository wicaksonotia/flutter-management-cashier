import 'package:cashier_management/utils/colors.dart';
import 'package:flutter/material.dart';

class FinanceLoadingState extends StatelessWidget {
  const FinanceLoadingState({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 5, 16, 100),
      child: Column(
        children: List.generate(
          5,
          (_) => Container(
            margin: const EdgeInsets.only(bottom: 10),
            height: 105,
            decoration: BoxDecoration(
              color: MyColors.surfaceSoft,
              borderRadius: BorderRadius.circular(17),
              border: Border.all(
                color: MyColors.divider,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
