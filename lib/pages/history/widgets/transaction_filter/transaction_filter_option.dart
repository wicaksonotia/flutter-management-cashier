import 'package:cashier_management/utils/colors.dart';
import 'package:flutter/material.dart';

class TransactionFilterOption extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final IconData? icon;

  const TransactionFilterOption({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 10,
          ),
          decoration: BoxDecoration(
            color: selected ? MyColors.selectedBackground : MyColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected ? MyColors.selectedBorder : MyColors.border,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: selected ? Colors.white : MyColors.surfaceSoft,
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Icon(
                  icon ??
                      (selected ? Icons.check_rounded : Icons.circle_outlined),
                  size: 17,
                  color: selected ? MyColors.primary : MyColors.textMuted,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
                    color: selected ? MyColors.primary : MyColors.textPrimary,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: selected ? MyColors.primary : Colors.transparent,
                  border: Border.all(
                    color: selected ? MyColors.primary : MyColors.border,
                    width: selected ? 0 : 1.5,
                  ),
                ),
                child: selected
                    ? const Icon(
                        Icons.check_rounded,
                        size: 13,
                        color: Colors.white,
                      )
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
