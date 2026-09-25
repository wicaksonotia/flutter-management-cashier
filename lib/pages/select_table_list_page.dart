import 'package:cashier_management/utils/app_back_header.dart';
import 'package:cashier_management/utils/colors.dart';
import 'package:cashier_management/utils/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

enum SelectTableSelectionMode {
  single,
  multiple,
}

class SelectTableListPage<T> extends StatefulWidget {
  final String title;
  final RxBool isLoading;

  final List<T> items;

  final String Function(T) titleBuilder;
  final String Function(T)? subtitleBuilder;

  final bool Function(T) isSelected;
  final Future<void> Function(T) onItemTap;

  final Future<void> Function()? onRefresh;

  final bool enableSearch;
  final String searchHint;

  final SelectTableSelectionMode selectionMode;

  final String applyLabel;

  final IconData itemIcon;
  final IconData selectedItemIcon;

  final Color? itemIconColor;

  final bool showSelectAll;
  final VoidCallback? onSelectAll;

  final int? selectedCount;

  final Future<void> Function()? onApply;

  final String emptyTitle;
  final String emptyMessage;

  final String searchEmptyTitle;
  final String searchEmptyMessage;

  const SelectTableListPage({
    super.key,
    required this.title,
    required this.isLoading,
    required this.items,
    required this.titleBuilder,
    this.subtitleBuilder,
    required this.isSelected,
    required this.onItemTap,
    this.onRefresh,
    this.enableSearch = false,
    this.searchHint = 'Cari...',
    this.selectionMode = SelectTableSelectionMode.single,
    this.applyLabel = 'Terapkan',
    this.itemIcon = Icons.category_outlined,
    this.selectedItemIcon = Icons.check_rounded,
    this.itemIconColor,
    this.showSelectAll = false,
    this.onSelectAll,
    this.selectedCount,
    this.onApply,
    this.emptyTitle = 'Belum ada data',
    this.emptyMessage = 'Data yang tersedia akan ditampilkan di sini.',
    this.searchEmptyTitle = 'Data tidak ditemukan',
    this.searchEmptyMessage = 'Tidak ada data yang cocok dengan pencarian.',
  });

  bool get isMultiple => selectionMode == SelectTableSelectionMode.multiple;

  @override
  State<SelectTableListPage<T>> createState() => _SelectTableListPageState<T>();
}

class _SelectTableListPageState<T> extends State<SelectTableListPage<T>> {
  final TextEditingController _searchController = TextEditingController();

  String _searchText = '';

  bool get isMultiple => widget.isMultiple;

  int get selectedCount {
    if (widget.selectedCount != null) {
      return widget.selectedCount!;
    }

    return widget.items.where(widget.isSelected).length;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // ============================================================
  // SEARCH
  // ============================================================

  List<T> get filteredItems {
    final query = _searchText.trim().toLowerCase();

    if (query.isEmpty) {
      return widget.items;
    }

    return widget.items.where((item) {
      final title = widget.titleBuilder(item).toLowerCase();

      final subtitle = widget.subtitleBuilder?.call(item).toLowerCase() ?? '';

      return title.contains(query) || subtitle.contains(query);
    }).toList();
  }

  void _onSearchChanged(String value) {
    setState(() {
      _searchText = value;
    });
  }

  void _clearSearch() {
    _searchController.clear();

    setState(() {
      _searchText = '';
    });
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.background,
      appBar: AppBackHeader(
        title: widget.title,
      ),
      body: Column(
        children: [
          if (widget.enableSearch) _buildSearch(),
          Expanded(
            child: RefreshIndicator(
              color: MyColors.primary,
              backgroundColor: Colors.white,
              strokeWidth: 2.2,
              onRefresh: _handleRefresh,
              child: Obx(
                () {
                  if (widget.isLoading.value) {
                    return _buildLoadingList();
                  }

                  final data = filteredItems;

                  if (widget.items.isEmpty) {
                    return _buildEmptyState(
                      icon: Icons.inbox_outlined,
                      title: widget.emptyTitle,
                      message: widget.emptyMessage,
                    );
                  }

                  if (data.isEmpty) {
                    return _buildEmptyState(
                      icon: Icons.search_off_rounded,
                      title: widget.searchEmptyTitle,
                      message: widget.searchEmptyMessage,
                      showClearButton: true,
                    );
                  }

                  return _buildItemList(data);
                },
              ),
            ),
          ),
          if (isMultiple) _buildBottomAction(),
        ],
      ),
    );
  }

  // ============================================================
  // SEARCH
  // ============================================================

  Widget _buildSearch() {
    return Container(
      color: MyColors.surface,
      padding: const EdgeInsets.fromLTRB(
        16,
        8,
        16,
        12,
      ),
      child: TextField(
        controller: _searchController,
        onChanged: _onSearchChanged,
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          hintText: widget.searchHint,
          hintStyle: const TextStyle(
            color: MyColors.textMuted,
            fontSize: 13,
          ),
          prefixIcon: const Icon(
            Icons.search_rounded,
            size: 21,
            color: MyColors.textSecondary,
          ),
          suffixIcon: _searchText.isNotEmpty
              ? IconButton(
                  onPressed: _clearSearch,
                  icon: const Icon(
                    Icons.close_rounded,
                    size: 19,
                    color: MyColors.textSecondary,
                  ),
                )
              : null,
          filled: true,
          fillColor: MyColors.background,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(
              color: MyColors.primary.withValues(alpha: .35),
              width: 1,
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // LIST
  // ============================================================

  Widget _buildItemList(List<T> items) {
    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(
        parent: BouncingScrollPhysics(),
      ),
      padding: const EdgeInsets.fromLTRB(
        16,
        16,
        16,
        24,
      ),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final item = items[index];

        return _SelectItemCard<T>(
          item: item,
          title: widget.titleBuilder(item),
          subtitle: widget.subtitleBuilder?.call(item),
          isSelected: widget.isSelected(item),
          selectionMode: widget.selectionMode,
          itemIcon: widget.itemIcon,
          selectedItemIcon: widget.selectedItemIcon,
          itemIconColor: widget.itemIconColor,
          onTap: () async {
            await widget.onItemTap(item);

            if (!isMultiple && context.mounted) {
              Navigator.of(context).pop(item);
            }

            if (isMultiple && mounted) {
              setState(() {});
            }
          },
        );
      },
    );
  }

  // ============================================================
  // BOTTOM ACTION
  // ============================================================

  Widget _buildBottomAction() {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        16,
        10,
        16,
        16,
      ),
      decoration: const BoxDecoration(
        color: MyColors.surface,
        border: Border(
          top: BorderSide(
            color: MyColors.divider,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            if (widget.showSelectAll && widget.onSelectAll != null) ...[
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    widget.onSelectAll!();

                    if (mounted) {
                      setState(() {});
                    }
                  },
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(
                      double.infinity,
                      48,
                    ),
                    side: const BorderSide(
                      color: MyColors.border,
                    ),
                    foregroundColor: MyColors.textSecondary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(13),
                    ),
                  ),
                  child: const Text(
                    'Semua',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
            ],
            Expanded(
              flex: 2,
              child: ElevatedButton(
                onPressed: _handleApply,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(
                    double.infinity,
                    48,
                  ),
                  backgroundColor: MyColors.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(13),
                  ),
                ),
                child: Text(
                  selectedCount > 0
                      ? '${widget.applyLabel} ($selectedCount)'
                      : widget.applyLabel,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleApply() async {
    if (widget.onApply != null) {
      await widget.onApply!();
    }

    if (mounted) {
      Navigator.of(context).pop(true);
    }
  }

  // ============================================================
  // REFRESH
  // ============================================================

  Future<void> _handleRefresh() async {
    if (widget.onRefresh == null) {
      return;
    }

    try {
      await widget.onRefresh!();
    } catch (error) {
      debugPrint(
        'SelectTableListPage refresh error: $error',
      );
    }
  }

  // ============================================================
  // LOADING
  // ============================================================

  Widget _buildLoadingList() {
    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(
        parent: BouncingScrollPhysics(),
      ),
      padding: const EdgeInsets.fromLTRB(
        16,
        16,
        16,
        24,
      ),
      itemCount: 7,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (_, __) {
        return _buildShimmerItem();
      },
    );
  }

  Widget _buildShimmerItem() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade200,
      highlightColor: Colors.white,
      child: Container(
        height: 76,
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 150,
                    height: 14,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: 100,
                    height: 10,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 24,
              height: 24,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // EMPTY
  // ============================================================

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String message,
    bool showClearButton = false,
  }) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(
        parent: BouncingScrollPhysics(),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
      ),
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * .25,
        ),
        Icon(
          icon,
          size: 54,
          color: const Color(0xFFB8C4D4),
        ),
        const SizedBox(height: 16),
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Color(0xFF344563),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: MySizes.fontSizeSm,
            color: Colors.grey.shade600,
          ),
        ),
        if (showClearButton) ...[
          const SizedBox(height: 16),
          Center(
            child: TextButton(
              onPressed: _clearSearch,
              child: const Text(
                'Hapus pencarian',
                style: TextStyle(
                  color: MyColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

// ============================================================
// SELECT ITEM CARD
// ============================================================

class _SelectItemCard<T> extends StatelessWidget {
  final T item;
  final String title;
  final String? subtitle;
  final bool isSelected;
  final SelectTableSelectionMode selectionMode;
  final IconData itemIcon;
  final IconData selectedItemIcon;
  final Color? itemIconColor;
  final Future<void> Function() onTap;

  const _SelectItemCard({
    required this.item,
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.selectionMode,
    required this.itemIcon,
    required this.selectedItemIcon,
    required this.itemIconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final hasSubtitle = subtitle != null && subtitle!.trim().isNotEmpty;

    final borderRadius = BorderRadius.circular(16);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 160),
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .025),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: borderRadius,
        clipBehavior: Clip.antiAlias,
        child: Ink(
          decoration: BoxDecoration(
            color: isSelected
                ? MyColors.primary.withValues(alpha: .06)
                : Colors.white,
            borderRadius: borderRadius,
            border: Border.all(
              color: isSelected
                  ? MyColors.primary.withValues(alpha: .35)
                  : const Color(0xFFE7ECF3),
              width: isSelected ? 1.2 : 1,
            ),
          ),
          child: ListTile(
            onTap: () async {
              await onTap();
            },
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 7,
            ),
            leading: _buildLeadingIcon(),
            title: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: isSelected ? MyColors.primary : const Color(0xFF172B4D),
              ),
            ),
            subtitle: hasSubtitle
                ? Padding(
                    padding: const EdgeInsets.only(top: 3),
                    child: Text(
                      subtitle!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: MySizes.fontSizeSm,
                        color: Color(0xFF7A869A),
                      ),
                    ),
                  )
                : null,
            trailing: _buildSelectionIndicator(),
          ),
        ),
      ),
    );
  }

  Widget _buildLeadingIcon() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 160),
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: isSelected
            ? MyColors.primary.withValues(alpha: .10)
            : const Color(0xFFF1F4F8),
        shape: BoxShape.circle,
      ),
      child: Icon(
        isSelected ? selectedItemIcon : itemIcon,
        size: 20,
        color: isSelected
            ? MyColors.primary
            : itemIconColor ?? const Color(0xFF718096),
      ),
    );
  }

  Widget _buildSelectionIndicator() {
    if (selectionMode == SelectTableSelectionMode.single) {
      return AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected ? MyColors.primary : Colors.transparent,
          border: Border.all(
            color: isSelected ? MyColors.primary : const Color(0xFFD5DCE6),
            width: isSelected ? 0 : 1.5,
          ),
        ),
        child: isSelected
            ? const Icon(
                Icons.check_rounded,
                size: 16,
                color: Colors.white,
              )
            : null,
      );
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: isSelected ? MyColors.primary : Colors.transparent,
        borderRadius: BorderRadius.circular(7),
        border: Border.all(
          color: isSelected ? MyColors.primary : const Color(0xFFD5DCE6),
          width: isSelected ? 0 : 1.5,
        ),
      ),
      child: isSelected
          ? const Icon(
              Icons.check_rounded,
              size: 16,
              color: Colors.white,
            )
          : null,
    );
  }
}
