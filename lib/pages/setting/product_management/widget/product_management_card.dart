import 'package:cashier_management/models/product_model.dart';
import 'package:cashier_management/pages/setting/product_management/widget/management_action_button.dart';
import 'package:cashier_management/pages/setting/product_management/widget/management_status_badge.dart';
import 'package:cashier_management/utils/colors.dart';
import 'package:cashier_management/utils/product_image.dart';
import 'package:flutter/material.dart';

class ProductManagementCard extends StatelessWidget {
  final DataProduct item;
  final bool isGrid;

  final VoidCallback? onEdit;
  final VoidCallback? onStatus;
  final VoidCallback? onDelete;
  final VoidCallback? onFavorite;

  const ProductManagementCard({
    super.key,
    required this.item,
    this.isGrid = true,
    this.onEdit,
    this.onStatus,
    this.onDelete,
    this.onFavorite,
  });

  bool get active => item.status ?? false;

  String get productName {
    final name = item.name?.trim();

    if (name == null || name.isEmpty) {
      return 'Produk';
    }

    return name;
  }

  String get productDescription {
    final description = item.description?.trim();

    if (description == null || description.isEmpty) {
      return 'Tidak ada deskripsi';
    }

    return description;
  }

  String get productPrice {
    final price = item.price ?? 0;

    return 'Rp ${price.toString().replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
          (match) => '${match[1]}.',
        )}';
  }

  @override
  Widget build(BuildContext context) {
    return isGrid ? _buildGridCard() : _buildListCard();
  }

  // ============================================================
  // GRID CARD
  // ============================================================

  Widget _buildGridCard() {
    return Container(
      decoration: BoxDecoration(
        color: MyColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: MyColors.border,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .035),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildGridImage(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                12,
                10,
                12,
                12,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildGridTitle(),
                  const SizedBox(height: 5),
                  _buildDescription(
                    maxLines: 2,
                  ),
                  const SizedBox(height: 8),
                  _buildPrice(),
                  const Spacer(),
                  _buildGridActions(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridImage() {
    return SizedBox(
      height: 104,
      width: double.infinity,
      child: Stack(
        children: [
          Positioned.fill(
            child: ProductImage(
              image: item.photo1,
              size: double.infinity,
              borderRadius: 0,
            ),
          ),

          // STATUS
          Positioned(
            top: 9,
            left: 9,
            child: ManagementStatusBadge(
              active: active,
            ),
          ),

          // FAVORITE
          Positioned(
            top: 7,
            right: 7,
            child: Material(
              color: Colors.white.withValues(alpha: .92),
              shape: const CircleBorder(),
              child: InkWell(
                onTap: onFavorite,
                customBorder: const CircleBorder(),
                child: Padding(
                  padding: const EdgeInsets.all(7),
                  child: Icon(
                    item.favorite == true
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_rounded,
                    size: 16,
                    color: item.favorite == true
                        ? MyColors.error
                        : MyColors.textMuted,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridTitle() {
    return Text(
      productName,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
        color: MyColors.textPrimary,
        fontSize: 13,
        fontWeight: FontWeight.w800,
        height: 1.25,
      ),
    );
  }

  Widget _buildGridActions() {
    return Row(
      children: [
        Expanded(
          child: ManagementActionButton(
            icon: Icons.edit_outlined,
            background: MyColors.primaryLight,
            foreground: MyColors.primaryDark,
            onTap: onEdit,
            height: 32,
            iconSize: 14,
            centerContent: true,
          ),
        ),
        const SizedBox(width: 5),
        Expanded(
          child: ManagementActionButton(
            icon: active
                ? Icons.pause_circle_outline_rounded
                : Icons.play_circle_outline_rounded,
            background: active ? Colors.orange.shade50 : Colors.green.shade50,
            foreground: active ? Colors.orange.shade800 : Colors.green.shade700,
            onTap: onStatus,
            height: 32,
            iconSize: 14,
            centerContent: true,
          ),
        ),
        const SizedBox(width: 5),
        Expanded(
          child: ManagementActionButton(
            icon: Icons.delete_outline_rounded,
            background:
                onDelete != null ? MyColors.errorBg : MyColors.surfaceSoft,
            foreground: onDelete != null ? MyColors.error : MyColors.textMuted,
            onTap: onDelete,
            height: 32,
            iconSize: 14,
            centerContent: true,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // LIST CARD
  // ============================================================

  Widget _buildListCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: MyColors.surface,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: MyColors.border,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .025),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProductImage(
            image: item.photo1,
            size: 76,
            borderRadius: 12,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildListHeader(),
                const SizedBox(height: 4),
                _buildDescription(
                  maxLines: 2,
                ),
                const SizedBox(height: 7),
                Row(
                  children: [
                    Text(
                      productPrice,
                      style: const TextStyle(
                        color: MyColors.primaryDark,
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(width: 7),
                    ManagementStatusBadge(
                      active: active,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                _buildListActions(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            productName,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: MyColors.textPrimary,
              fontSize: 13,
              fontWeight: FontWeight.w800,
              height: 1.25,
            ),
          ),
        ),
        const SizedBox(width: 5),
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onFavorite,
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: const EdgeInsets.all(3),
              child: Icon(
                item.favorite == true
                    ? Icons.favorite_rounded
                    : Icons.favorite_border_rounded,
                size: 17,
                color:
                    item.favorite == true ? MyColors.error : MyColors.textMuted,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildListActions() {
    return Wrap(
      spacing: 5,
      runSpacing: 5,
      children: [
        ManagementActionButton(
          icon: Icons.edit_outlined,
          label: 'Edit',
          background: MyColors.primaryLight,
          foreground: MyColors.primaryDark,
          onTap: onEdit,
          height: 30,
          iconSize: 13,
          fontSize: 9,
        ),
        ManagementActionButton(
          icon: active
              ? Icons.pause_circle_outline_rounded
              : Icons.play_circle_outline_rounded,
          label: active ? 'Nonaktif' : 'Aktifkan',
          background: active ? Colors.orange.shade50 : Colors.green.shade50,
          foreground: active ? Colors.orange.shade800 : Colors.green.shade700,
          onTap: onStatus,
          height: 30,
          iconSize: 13,
          fontSize: 9,
        ),
        ManagementActionButton(
          icon: Icons.delete_outline_rounded,
          label: 'Hapus',
          background:
              onDelete != null ? MyColors.errorBg : MyColors.surfaceSoft,
          foreground: onDelete != null ? MyColors.error : MyColors.textMuted,
          onTap: onDelete,
          height: 30,
          iconSize: 13,
          fontSize: 9,
        ),
      ],
    );
  }

  // ============================================================
  // COMMON
  // ============================================================

  Widget _buildDescription({
    int maxLines = 2,
  }) {
    return Text(
      productDescription,
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
        color: MyColors.textMuted,
        fontSize: 10,
        height: 1.35,
      ),
    );
  }

  Widget _buildPrice() {
    return Text(
      productPrice,
      style: const TextStyle(
        color: MyColors.primaryDark,
        fontSize: 14,
        fontWeight: FontWeight.w900,
      ),
    );
  }
}
