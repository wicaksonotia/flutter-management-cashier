import 'package:cashier_management/utils/colors.dart';
import 'package:flutter/material.dart';

class FinanceSegmented extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  const FinanceSegmented({
    super.key,
    required this.selectedIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    const items = [
      ('Semua', Icons.receipt_long_rounded),
      ('Pemasukan', Icons.south_west_rounded),
      ('Pengeluaran', Icons.north_east_rounded),
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: MyColors.surfaceSoft,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: MyColors.border,
          ),
        ),
        child: Row(
          children: List.generate(
            items.length,
            (index) {
              final selected = selectedIndex == index;

              return Expanded(
                child: GestureDetector(
                  onTap: () => onChanged(index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 6,
                    ),
                    decoration: BoxDecoration(
                      color: selected ? MyColors.surface : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: selected
                          ? const [
                              BoxShadow(
                                color: MyColors.shadow,
                                blurRadius: 5,
                                offset: Offset(0, 2),
                              ),
                            ]
                          : null,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          items[index].$2,
                          size: 15,
                          color:
                              selected ? MyColors.primary : MyColors.textMuted,
                        ),
                        const SizedBox(width: 5),
                        Flexible(
                          child: Text(
                            items[index].$1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 11.5,
                              fontWeight:
                                  selected ? FontWeight.w800 : FontWeight.w600,
                              color: selected
                                  ? MyColors.primary
                                  : MyColors.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
