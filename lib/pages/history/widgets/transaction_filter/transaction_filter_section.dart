import 'package:cashier_management/utils/colors.dart';
import 'package:cashier_management/pages/history/widgets/transaction_filter/transaction_filter_option.dart';
import 'package:flutter/material.dart';

class TransactionFilterSection extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final List<Map<String, dynamic>> items;
  final List<dynamic> selectedValues;
  final VoidCallback onSelectAll;
  final ValueChanged<dynamic> onToggle;
  final bool isLoading;
  final String emptyText;

  const TransactionFilterSection({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.items,
    required this.selectedValues,
    required this.onSelectAll,
    required this.onToggle,
    required this.isLoading,
    required this.emptyText,
  });

  bool _isSelected(dynamic value) {
    return selectedValues.contains(value);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(),
        const SizedBox(height: 12),
        _buildContent(),
      ],
    );
  }

  Widget _buildHeader() {
    final isAll = selectedValues.isEmpty;

    return Row(
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: MyColors.surfaceSoft,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            size: 18,
            color: MyColors.primary,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: MyColors.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 10.5,
                  color: MyColors.textMuted,
                ),
              ),
            ],
          ),
        ),
        if (isAll)
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 4,
            ),
            decoration: BoxDecoration(
              color: MyColors.surfaceSoft,
              borderRadius: BorderRadius.circular(7),
            ),
            child: const Text(
              'Semua',
              style: TextStyle(
                fontSize: 9.5,
                fontWeight: FontWeight.w700,
                color: MyColors.textSecondary,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildContent() {
    if (isLoading) {
      return _buildLoading();
    }

    if (items.isEmpty) {
      return _buildEmpty();
    }

    return Column(
      children: [
        TransactionFilterOption(
          label: 'Semua',
          selected: selectedValues.isEmpty,
          icon: Icons.select_all_rounded,
          onTap: onSelectAll,
        ),
        const SizedBox(height: 8),
        ...items.asMap().entries.map(
          (entry) {
            final index = entry.key;
            final item = entry.value;

            final value = item['value'];
            final label = item['nama']?.toString() ?? '-';

            return Padding(
              padding: EdgeInsets.only(
                bottom: index == items.length - 1 ? 0 : 8,
              ),
              child: TransactionFilterOption(
                label: label,
                selected: _isSelected(value),
                onTap: () => onToggle(value),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildLoading() {
    return Column(
      children: List.generate(
        3,
        (index) => Container(
          width: double.infinity,
          height: 54,
          margin: EdgeInsets.only(
            bottom: index == 2 ? 0 : 8,
          ),
          decoration: BoxDecoration(
            color: MyColors.surfaceSoft,
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget _buildEmpty() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 16,
      ),
      decoration: BoxDecoration(
        color: MyColors.surfaceSoft,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: MyColors.border,
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.info_outline_rounded,
            size: 18,
            color: MyColors.textMuted,
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Text(
              emptyText,
              style: const TextStyle(
                fontSize: 11,
                color: MyColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
