import 'package:cashier_management/controllers/history_controller.dart';
import 'package:cashier_management/pages/select_table_list_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TransactionCategoryFilterPage extends StatefulWidget {
  final int selectedType;
  final HistoryController controller;

  const TransactionCategoryFilterPage({
    super.key,
    required this.selectedType,
    required this.controller,
  });

  @override
  State<TransactionCategoryFilterPage> createState() =>
      _TransactionCategoryFilterPageState();
}

class _TransactionCategoryFilterPageState
    extends State<TransactionCategoryFilterPage> {
  final RxBool isLoading = false.obs;

  HistoryController get controller => widget.controller;

  String get title {
    switch (widget.selectedType) {
      case 1:
        return 'Kategori Pemasukan';
      case 2:
        return 'Kategori Pengeluaran';
      default:
        return 'Kategori Transaksi';
    }
  }

  String get searchHint {
    switch (widget.selectedType) {
      case 1:
        return 'Cari kategori pemasukan...';
      case 2:
        return 'Cari kategori pengeluaran...';
      default:
        return 'Cari kategori...';
    }
  }

  List<Map<String, dynamic>> get items {
    final Map<dynamic, Map<String, dynamic>> result = {};

    // Pemasukan
    if (widget.selectedType == 0 || widget.selectedType == 1) {
      for (final item in controller.listCategoryPemasukan) {
        final value = item['value'];

        result[value] = {
          'value': value,
          'nama': item['nama'],
          'jenis': 'PEMASUKAN',
        };
      }
    }

    // Pengeluaran
    if (widget.selectedType == 0 || widget.selectedType == 2) {
      for (final item in controller.listCategoryPengeluaran) {
        final value = item['value'];

        result[value] = {
          'value': value,
          'nama': item['nama'],
          'jenis': 'PENGELUARAN',
        };
      }
    }

    final data = result.values.toList();

    data.sort(
      (a, b) => (a['nama'] ?? '').toString().toLowerCase().compareTo(
            (b['nama'] ?? '').toString().toLowerCase(),
          ),
    );

    return data;
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadCategories();
    });
  }

  Future<void> _loadCategories() async {
    if (!mounted) return;

    try {
      isLoading(true);

      final futures = <Future<void>>[];

      if (widget.selectedType == 0 || widget.selectedType == 1) {
        futures.add(
          controller.getDataListCategoryPemasukan(),
        );
      }

      if (widget.selectedType == 0 || widget.selectedType == 2) {
        futures.add(
          controller.getDataListCategoryPengeluaran(),
        );
      }

      await Future.wait(futures);
    } catch (error) {
      debugPrint(
        'TransactionCategoryFilterPage load error: $error',
      );
    } finally {
      isLoading(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => SelectTableListPage<Map<String, dynamic>>(
        title: title,
        isLoading: isLoading,
        items: items,
        enableSearch: true,
        searchHint: searchHint,

        selectionMode: SelectTableSelectionMode.multiple,
        applyLabel: 'Terapkan',

        showSelectAll: true,

        itemIcon: Icons.receipt_long_outlined,
        selectedItemIcon: Icons.check_rounded,

        titleBuilder: (item) {
          return item['nama']?.toString() ?? '-';
        },

        subtitleBuilder: (item) {
          if (widget.selectedType != 0) {
            return '';
          }

          return item['jenis']?.toString() ?? '';
        },

        isSelected: (item) {
          return controller.tempTagCategory.contains(
            item['value'],
          );
        },

        onItemTap: (item) async {
          controller.toggleCategory(
            item['value'],
          );
        },

        selectedCount: controller.tempTagCategory.length,

        onSelectAll: () {
          controller.selectAllCategory();
        },

        // Jangan request history di sini.
        // Filter baru benar-benar diterapkan dari
        // TransactionFilterSheet saat tombol "Terapkan" ditekan.
        onApply: () async {},

        onRefresh: () async {
          await _loadCategories();
        },

        emptyTitle: 'Belum ada kategori',
        emptyMessage: 'Kategori transaksi belum tersedia.',

        searchEmptyTitle: 'Kategori tidak ditemukan',
        searchEmptyMessage: 'Tidak ada kategori yang cocok dengan pencarian.',
      ),
    );
  }
}
