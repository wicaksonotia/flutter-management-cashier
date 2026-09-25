import 'package:cashier_management/controllers/transaction_controller.dart';
import 'package:cashier_management/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AddTransactionSheet extends StatefulWidget {
  const AddTransactionSheet({super.key});

  @override
  State<AddTransactionSheet> createState() => _AddTransactionSheetState();
}

class _AddTransactionSheetState extends State<AddTransactionSheet> {
  late final TransactionController controller;

  final amountFocus = FocusNode();
  final descriptionFocus = FocusNode();

  @override
  void initState() {
    super.initState();

    controller = Get.find<TransactionController>();

    controller.amountController.clear();
    controller.descriptionController.clear();

    controller.isIncome.value = false;
    controller.setKategori();

    controller.fetchAllCategory(['PENGELUARAN']);
  }

  @override
  void dispose() {
    amountFocus.dispose();
    descriptionFocus.dispose();
    super.dispose();
  }

  String _currency(int value) {
    return NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(value);
  }

  String _selectedDate() {
    return DateFormat(
      'dd MMMM yyyy',
      'id_ID',
    ).format(
      controller.selectTransactionExpenseDate.value,
    );
  }

  String _selectedTime() {
    final time = controller.selectTransactionExpenseTime.value;

    return '${time.hour.toString().padLeft(2, '0')}:'
        '${time.minute.toString().padLeft(2, '0')}';
  }

  void _changeType(bool income) {
    controller.isIncome.value = income;
    controller.setKategori();

    controller.idCategoryTransaction.value = 0;
    controller.selectedCategoryTransaction.value = 'Category';

    controller.fetchAllCategory(
      income ? ['PEMASUKAN'] : ['PENGELUARAN'],
    );

    setState(() {});
  }

  Future<void> _selectCategory() async {
    final categories = controller.resultDataCategoryWithoutPagination.toList();

    if (categories.isEmpty) {
      await controller.fetchAllCategory(
        controller.isIncome.value ? ['PEMASUKAN'] : ['PENGELUARAN'],
      );
    }

    final updated = controller.resultDataCategoryWithoutPagination.toList();

    if (!mounted) return;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (_) {
        return SafeArea(
          child: SizedBox(
            height: MediaQuery.of(context).size.height * .62,
            child: Column(
              children: [
                const SizedBox(height: 12),
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: MyColors.border,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(height: 20),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Pilih kategori',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: MyColors.textPrimary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: updated.isEmpty
                      ? const Center(
                          child: Text(
                            'Belum ada kategori',
                            style: TextStyle(
                              color: MyColors.textSecondary,
                            ),
                          ),
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.all(16),
                          itemCount: updated.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 8),
                          itemBuilder: (_, index) {
                            final item = updated[index];

                            final selected =
                                controller.idCategoryTransaction.value ==
                                    (item.id ?? 0);

                            return InkWell(
                              borderRadius: BorderRadius.circular(14),
                              onTap: () {
                                controller.idCategoryTransaction.value =
                                    item.id ?? 0;

                                controller.selectedCategoryTransaction.value =
                                    item.categoryName ?? 'Category';

                                Navigator.pop(context);
                                setState(() {});
                              },
                              child: Container(
                                padding: const EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                  color: selected
                                      ? MyColors.primaryLight
                                      : MyColors.surface,
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: selected
                                        ? MyColors.selectedBorder
                                        : MyColors.border,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 38,
                                      height: 38,
                                      decoration: BoxDecoration(
                                        color: selected
                                            ? MyColors.primary
                                            : MyColors.surfaceSoft,
                                        borderRadius: BorderRadius.circular(11),
                                      ),
                                      child: Icon(
                                        Icons.category_outlined,
                                        size: 19,
                                        color: selected
                                            ? Colors.white
                                            : MyColors.textSecondary,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        item.categoryName ?? '-',
                                        style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700,
                                          color: MyColors.textPrimary,
                                        ),
                                      ),
                                    ),
                                    if (selected)
                                      const Icon(
                                        Icons.check_circle_rounded,
                                        color: MyColors.primary,
                                      ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _selectDate() async {
    await controller.showDialogDatePicker();
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _selectTime() async {
    await controller.showDialogTimePicker();
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _save() async {
    FocusScope.of(context).unfocus();

    if (controller.amountController.text.trim().isEmpty) {
      _error('Nominal transaksi belum diisi');
      return;
    }

    if (controller.descriptionController.text.trim().isEmpty) {
      _error('Keterangan transaksi belum diisi');
      return;
    }

    if (controller.idCategoryTransaction.value == 0) {
      _error('Kategori transaksi belum dipilih');
      return;
    }

    final success = await controller.saveTransaction();

    if (success && mounted) {
      Navigator.pop(context);
    }
  }

  void _error(String message) {
    Get.snackbar(
      'Perhatian',
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: MyColors.errorBg,
      colorText: MyColors.error,
      margin: const EdgeInsets.all(12),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;

    return Obx(
      () => Container(
        margin: const EdgeInsets.only(top: 50),
        decoration: const BoxDecoration(
          color: MyColors.background,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(28),
          ),
        ),
        child: SafeArea(
          top: false,
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
              20,
              12,
              20,
              bottom + 20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 42,
                    height: 4,
                    decoration: BoxDecoration(
                      color: MyColors.border,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // =================================================
                // HEADER
                // =================================================

                Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: MyColors.primaryLight,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(
                        Icons.account_balance_wallet_rounded,
                        color: MyColors.primary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Tambah transaksi',
                            style: TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.w800,
                              color: MyColors.textPrimary,
                            ),
                          ),
                          SizedBox(height: 3),
                          Text(
                            'Catat pemasukan atau pengeluaran',
                            style: TextStyle(
                              fontSize: 12,
                              color: MyColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 22),

                // =================================================
                // TYPE
                // =================================================

                _SectionLabel(
                  title: 'Jenis transaksi',
                ),
                const SizedBox(height: 8),

                Row(
                  children: [
                    Expanded(
                      child: _TypeButton(
                        title: 'Pemasukan',
                        icon: Icons.south_west_rounded,
                        selected: controller.isIncome.value,
                        color: MyColors.success,
                        background: MyColors.successBg,
                        onTap: () => _changeType(true),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _TypeButton(
                        title: 'Pengeluaran',
                        icon: Icons.north_east_rounded,
                        selected: !controller.isIncome.value,
                        color: MyColors.error,
                        background: MyColors.errorBg,
                        onTap: () => _changeType(false),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // =================================================
                // CENTRALIZED
                // =================================================

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 11,
                  ),
                  decoration: BoxDecoration(
                    color: MyColors.surface,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: MyColors.border,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: MyColors.primaryLight,
                          borderRadius: BorderRadius.circular(11),
                        ),
                        child: const Icon(
                          Icons.hub_outlined,
                          size: 19,
                          color: MyColors.primary,
                        ),
                      ),
                      const SizedBox(width: 11),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Transaksi terpusat',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: MyColors.textPrimary,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Tidak terkait outlet tertentu',
                              style: TextStyle(
                                fontSize: 10.5,
                                color: MyColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Switch.adaptive(
                        value: controller.isCentralized.value,
                        activeColor: MyColors.primary,
                        onChanged: (value) {
                          controller.isCentralized.value = value;

                          setState(() {});
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // =================================================
                // CATEGORY
                // =================================================

                _SectionLabel(
                  title: 'Kategori',
                ),
                const SizedBox(height: 8),

                _SelectorField(
                  icon: Icons.category_outlined,
                  title: 'Kategori transaksi',
                  value: controller.selectedCategoryTransaction.value,
                  onTap: _selectCategory,
                ),

                const SizedBox(height: 16),

                // =================================================
                // AMOUNT
                // =================================================

                _SectionLabel(
                  title: 'Nominal',
                ),
                const SizedBox(height: 8),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: MyColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: amountFocus.hasFocus
                          ? MyColors.primary
                          : MyColors.border,
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Rp',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: MyColors.textSecondary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: controller.amountController,
                          focusNode: amountFocus,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          decoration: const InputDecoration(
                            hintText: '0',
                            border: InputBorder.none,
                            hintStyle: TextStyle(
                              color: MyColors.textMuted,
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            color: MyColors.textPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // =================================================
                // DESCRIPTION
                // =================================================

                _SectionLabel(
                  title: 'Keterangan',
                ),
                const SizedBox(height: 8),

                Container(
                  decoration: BoxDecoration(
                    color: MyColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: MyColors.border,
                    ),
                  ),
                  child: TextField(
                    controller: controller.descriptionController,
                    focusNode: descriptionFocus,
                    minLines: 3,
                    maxLines: 5,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: const InputDecoration(
                      hintText: 'Contoh: Belanja jahe, susu, madu...',
                      hintStyle: TextStyle(
                        color: MyColors.textMuted,
                        fontSize: 12,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(15),
                    ),
                    style: const TextStyle(
                      fontSize: 13,
                      color: MyColors.textPrimary,
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // =================================================
                // DATE + TIME
                // =================================================

                Row(
                  children: [
                    Expanded(
                      child: _DateTimeField(
                        icon: Icons.calendar_today_rounded,
                        label: 'Tanggal',
                        value: _selectedDate(),
                        onTap: _selectDate,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _DateTimeField(
                        icon: Icons.access_time_rounded,
                        label: 'Waktu',
                        value: _selectedTime(),
                        onTap: _selectTime,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // =================================================
                // SAVE
                // =================================================

                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: MyColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onPressed: controller.isLoadingSaveTransaction.value
                        ? null
                        : _save,
                    child: controller.isLoadingSaveTransaction.value
                        ? const SizedBox(
                            width: 21,
                            height: 21,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: Colors.white,
                            ),
                          )
                        : const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.check_rounded,
                                size: 20,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Simpan Transaksi',
                                style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String title;

  const _SectionLabel({
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w800,
        color: MyColors.textPrimary,
      ),
    );
  }
}

class _TypeButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool selected;
  final Color color;
  final Color background;
  final VoidCallback onTap;

  const _TypeButton({
    required this.title,
    required this.icon,
    required this.selected,
    required this.color,
    required this.background,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
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
    );
  }
}

class _SelectorField extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final VoidCallback onTap;

  const _SelectorField({
    required this.icon,
    required this.title,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(15),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(
          color: MyColors.surface,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: MyColors.border,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: MyColors.primaryLight,
                borderRadius: BorderRadius.circular(11),
              ),
              child: Icon(
                icon,
                size: 19,
                color: MyColors.primary,
              ),
            ),
            const SizedBox(width: 11),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 10,
                      color: MyColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    value == 'Category' ? 'Pilih kategori' : value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: value == 'Category'
                          ? MyColors.textMuted
                          : MyColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: MyColors.textMuted,
            ),
          ],
        ),
      ),
    );
  }
}

class _DateTimeField extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final VoidCallback onTap;

  const _DateTimeField({
    required this.icon,
    required this.label,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(15),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: MyColors.surface,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: MyColors.border,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 17,
              color: MyColors.primary,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 9.5,
                      color: MyColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    value,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                      color: MyColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
