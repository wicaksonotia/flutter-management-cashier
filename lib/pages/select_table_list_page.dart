import 'package:cashier_management/utils/app_back_header.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import 'package:cashier_management/utils/colors.dart';
import 'package:cashier_management/utils/sizes.dart';

class SelectTableListPage<T> extends StatefulWidget {
  final String title;
  final RxBool isLoading;

  final List<T> items;

  final String Function(T) titleBuilder;
  final String Function(T)? subtitleBuilder;

  final bool Function(T) isSelected;
  final Future<void> Function(T) onItemTap;

  final Future<void> Function()? onRefresh;

  /// Aktifkan search.
  final bool enableSearch;

  /// Placeholder search.
  final String searchHint;

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
  });

  @override
  State<SelectTableListPage<T>> createState() => _SelectTableListPageState<T>();
}

class _SelectTableListPageState<T> extends State<SelectTableListPage<T>> {
  // ==========================================================
  // SEARCH
  // ==========================================================

  final TextEditingController _searchController = TextEditingController();

  String _searchText = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // ==========================================================
  // SEARCH FILTER
  // ==========================================================

  List<T> get _filteredItems {
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

  // ==========================================================
  // BUILD
  // ==========================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F8FC),
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

                  final filteredItems = _filteredItems;

                  if (widget.items.isEmpty) {
                    return _buildEmptyState(
                      icon: Icons.inbox_outlined,
                      title: 'Belum ada data',
                      message: 'Data yang tersedia akan ditampilkan di sini.',
                    );
                  }

                  if (filteredItems.isEmpty) {
                    return _buildEmptyState(
                      icon: Icons.search_off_rounded,
                      title: 'Data tidak ditemukan',
                      message: 'Tidak ada data yang cocok dengan pencarian.',
                      showClearButton: true,
                    );
                  }

                  return _buildItemList(filteredItems);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // SEARCH
  // ==========================================================

  Widget _buildSearch() {
    return Container(
      color: Colors.white,
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
            color: Color(0xFF9AA6B2),
            fontSize: 14,
          ),
          prefixIcon: const Icon(
            Icons.search_rounded,
            size: 21,
            color: Color(0xFF718096),
          ),
          suffixIcon: _searchText.isNotEmpty
              ? IconButton(
                  onPressed: _clearSearch,
                  icon: const Icon(
                    Icons.close_rounded,
                    size: 19,
                  ),
                )
              : null,
          filled: true,
          fillColor: const Color(0xFFF5F8FC),
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

  // ==========================================================
  // REFRESH
  // ==========================================================

  Future<void> _handleRefresh() async {
    if (widget.onRefresh == null) return;

    widget.isLoading.value = true;

    try {
      await widget.onRefresh!();
    } finally {
      widget.isLoading.value = false;
    }
  }

  // ==========================================================
  // LIST
  // ==========================================================

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
          onTap: () async {
            await widget.onItemTap(item);

            if (context.mounted) {
              Navigator.of(context).pop();
            }
          },
        );
      },
    );
  }

  // ==========================================================
  // LOADING
  // ==========================================================

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

  // ==========================================================
  // EMPTY
  // ==========================================================

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
      padding: const EdgeInsets.symmetric(horizontal: 24),
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
                style: const TextStyle(
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
  final Future<void> Function() onTap;

  const _SelectItemCard({
    required this.item,
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final hasSubtitle = subtitle != null && subtitle!.trim().isNotEmpty;

    return Container(
      decoration: BoxDecoration(
        color:
            isSelected ? MyColors.primary.withValues(alpha: .06) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected
              ? MyColors.primary.withValues(alpha: .35)
              : const Color(0xFFE7ECF3),
          width: isSelected ? 1.2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .025),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
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
              fontSize: 14.5,
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
    );
  }

  Widget _buildLeadingIcon() {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: isSelected
            ? MyColors.primary.withValues(alpha: .10)
            : const Color(0xFFF1F4F8),
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.category_outlined,
        size: 20,
        color: isSelected ? MyColors.primary : const Color(0xFF718096),
      ),
    );
  }

  Widget _buildSelectionIndicator() {
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
}
