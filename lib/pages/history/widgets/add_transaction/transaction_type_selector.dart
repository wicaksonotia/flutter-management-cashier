import 'package:cashier_management/utils/colors.dart';
import 'package:flutter/material.dart';

class TransactionTypeSelector extends StatelessWidget {
  final bool selectedIncome;
  final bool enabled;
  final ValueChanged<bool> onChanged;

  const TransactionTypeSelector({
    super.key,
    required this.selectedIncome,
    required this.enabled,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _TypeButton(
            title: 'Pemasukan',
            icon: Icons.south_west_rounded,
            selected: selectedIncome,
            color: MyColors.success,
            background: MyColors.successBg,
            enabled: enabled,
            onTap: () => onChanged(true),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _TypeButton(
            title: 'Pengeluaran',
            icon: Icons.north_east_rounded,
            selected: !selectedIncome,
            color: MyColors.error,
            background: MyColors.errorBg,
            enabled: enabled,
            onTap: () => onChanged(false),
          ),
        ),
      ],
    );
  }
}

class _TypeButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool selected;
  final Color color;
  final Color background;
  final bool enabled;
  final VoidCallback onTap;

  const _TypeButton({
    required this.title,
    required this.icon,
    required this.selected,
    required this.color,
    required this.background,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 150),
      opacity: enabled ? 1 : .5,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: enabled ? onTap : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(
            horizontal: 13,
            vertical: 13,
          ),
          decoration: BoxDecoration(
            color: selected ? background : MyColors.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: selected ? color.withOpacity(.35) : MyColors.border,
              width: selected ? 1.3 : 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: selected ? color : MyColors.surfaceSoft,
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Icon(
                  icon,
                  size: 17,
                  color: selected ? Colors.white : MyColors.textSecondary,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: selected ? color : MyColors.textSecondary,
                  ),
                ),
              ),
              if (selected)
                Icon(
                  Icons.check_circle_rounded,
                  size: 18,
                  color: color,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
