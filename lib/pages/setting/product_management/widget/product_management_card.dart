import 'package:cashier_management/models/product_model.dart';
import 'package:cashier_management/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProductManagementCard extends StatelessWidget {
  final DataProduct item;
  final bool isGrid;

  final VoidCallback onEdit;
  final VoidCallback onStatus;
  final VoidCallback? onDelete;
  final VoidCallback onFavorite;

  const ProductManagementCard({
    super.key,
    required this.item,
    required this.isGrid,
    required this.onEdit,
    required this.onStatus,
    required this.onDelete,
    required this.onFavorite,
  });

  String _price() {
    return NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp.',
      decimalDigits: 0,
    ).format(item.price ?? 0);
  }

  @override
  Widget build(BuildContext context) {
    return isGrid ? _buildGridCard() : _buildListCard();
  }

  // ==========================================================
  // GRID
  // ==========================================================

  Widget _buildGridCard() {
    final active = item.status ?? false;
    final favorite = item.favorite ?? false;

    return Container(
      decoration: BoxDecoration(
        color: MyColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: MyColors.border,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .025),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(11),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ==================================================
            // IMAGE PLACEHOLDER
            // ==================================================

            Stack(
              children: [
                Container(
                  height: 104,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: MyColors.surfaceSoft,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.fastfood_outlined,
                      size: 34,
                      color: MyColors.textMuted,
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  left: 8,
                  child: _StatusBadge(
                    active: active,
                  ),
                ),
                Positioned(
                  top: 5,
                  right: 5,
                  child: Material(
                    color: Colors.white.withValues(alpha: .92),
                    shape: const CircleBorder(),
                    child: InkWell(
                      onTap: onFavorite,
                      customBorder: const CircleBorder(),
                      child: Padding(
                        padding: const EdgeInsets.all(7),
                        child: Icon(
                          favorite
                              ? Icons.star_rounded
                              : Icons.star_border_rounded,
                          size: 18,
                          color: favorite
                              ? Colors.amber.shade700
                              : MyColors.textMuted,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 9),

            // ==================================================
            // NAME
            // ==================================================

            Text(
              item.name ?? '-',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: MyColors.textPrimary,
                fontSize: 13,
                fontWeight: FontWeight.w800,
              ),
            ),

            const SizedBox(height: 3),

            Text(
              (item.description ?? '').isEmpty
                  ? 'Tanpa deskripsi'
                  : item.description!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: MyColors.textSecondary,
                fontSize: 10,
              ),
            ),

            const SizedBox(height: 5),

            Text(
              _price(),
              style: const TextStyle(
                color: MyColors.primary,
                fontSize: 13,
                fontWeight: FontWeight.w800,
              ),
            ),

            const Spacer(),

            // ==================================================
            // ACTION
            // ==================================================

            Row(
              children: [
                Expanded(
                  child: _ActionButton(
                    label: 'Edit',
                    icon: Icons.edit_outlined,
                    background: MyColors.primaryLight,
                    foreground: MyColors.primaryDark,
                    onTap: onEdit,
                  ),
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: _ActionButton(
                    label: active ? 'Nonaktif' : 'Aktifkan',
                    icon: active
                        ? Icons.pause_circle_outline_rounded
                        : Icons.play_circle_outline_rounded,
                    background:
                        active ? Colors.orange.shade50 : Colors.green.shade50,
                    foreground:
                        active ? Colors.orange.shade800 : Colors.green.shade700,
                    onTap: onStatus,
                  ),
                ),
                const SizedBox(width: 5),
                _DeleteButton(
                  onTap: onDelete,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================================
  // LIST
  // ==========================================================

  Widget _buildListCard() {
    final active = item.status ?? false;
    final favorite = item.favorite ?? false;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: MyColors.surface,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(
          color: MyColors.border,
        ),
      ),
      child: Row(
        children: [
          // ====================================================
          // IMAGE
          // ====================================================

          Container(
            width: 76,
            height: 76,
            decoration: BoxDecoration(
              color: MyColors.surfaceSoft,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.fastfood_outlined,
              size: 30,
              color: MyColors.textMuted,
            ),
          ),

          const SizedBox(width: 12),

          // ====================================================
          // CONTENT
          // ====================================================

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.name ?? '-',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: MyColors.textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: onFavorite,
                        borderRadius: BorderRadius.circular(20),
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: Icon(
                            favorite
                                ? Icons.star_rounded
                                : Icons.star_border_rounded,
                            size: 20,
                            color: favorite
                                ? Colors.amber.shade700
                                : MyColors.textMuted,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  (item.description ?? '').isEmpty
                      ? 'Tanpa deskripsi'
                      : item.description!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: MyColors.textSecondary,
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text(
                      _price(),
                      style: const TextStyle(
                        color: MyColors.primary,
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(width: 8),
                    _StatusBadge(
                      active: active,
                    ),
                  ],
                ),
                const SizedBox(height: 9),
                Row(
                  children: [
                    _SmallActionButton(
                      label: 'Edit',
                      icon: Icons.edit_outlined,
                      foreground: MyColors.primaryDark,
                      background: MyColors.primaryLight,
                      onTap: onEdit,
                    ),
                    const SizedBox(width: 6),
                    _SmallActionButton(
                      label: active ? 'Nonaktifkan' : 'Aktifkan',
                      icon: active
                          ? Icons.pause_circle_outline_rounded
                          : Icons.play_circle_outline_rounded,
                      foreground: active
                          ? Colors.orange.shade800
                          : Colors.green.shade700,
                      background:
                          active ? Colors.orange.shade50 : Colors.green.shade50,
                      onTap: onStatus,
                    ),
                    const SizedBox(width: 6),
                    _SmallActionButton(
                      label: 'Hapus',
                      icon: Icons.delete_outline_rounded,
                      foreground: MyColors.error,
                      background: MyColors.errorBg,
                      onTap: onDelete,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ==========================================================
// STATUS
// ==========================================================

class _StatusBadge extends StatelessWidget {
  final bool active;

  const _StatusBadge({
    required this.active,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: active ? Colors.green.shade50 : MyColors.errorBg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        active ? 'Aktif' : 'Nonaktif',
        style: TextStyle(
          color: active ? Colors.green.shade700 : MyColors.error,
          fontSize: 9,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

// ==========================================================
// GRID ACTION
// ==========================================================

class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color background;
  final Color foreground;
  final VoidCallback onTap;

  const _ActionButton({
    required this.label,
    required this.icon,
    required this.background,
    required this.foreground,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: background,
      borderRadius: BorderRadius.circular(9),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(9),
        child: SizedBox(
          height: 31,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 14,
                color: foreground,
              ),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: foreground,
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==========================================================
// DELETE GRID
// ==========================================================

class _DeleteButton extends StatelessWidget {
  final VoidCallback? onTap;

  const _DeleteButton({
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;

    return Tooltip(
      message:
          enabled ? 'Hapus produk' : 'Produk sudah digunakan dalam transaksi',
      child: Material(
        color: enabled ? MyColors.errorBg : MyColors.surfaceSoft,
        borderRadius: BorderRadius.circular(9),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(9),
          child: SizedBox(
            width: 35,
            height: 31,
            child: Icon(
              Icons.delete_outline_rounded,
              size: 16,
              color: enabled ? MyColors.error : MyColors.textMuted,
            ),
          ),
        ),
      ),
    );
  }
}

// ==========================================================
// LIST ACTION
// ==========================================================

class _SmallActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color foreground;
  final Color background;
  final VoidCallback? onTap;

  const _SmallActionButton({
    required this.label,
    required this.icon,
    required this.foreground,
    required this.background,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;

    return Tooltip(
      message: enabled ? label : 'Produk sudah digunakan dalam transaksi',
      child: Material(
        color: enabled ? background : MyColors.surfaceSoft,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 6,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: 13,
                  color: enabled ? foreground : MyColors.textMuted,
                ),
                const SizedBox(width: 4),
                Text(
                  label,
                  style: TextStyle(
                    color: enabled ? foreground : MyColors.textMuted,
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
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
