import 'package:cashier_management/utils/colors.dart';
import 'package:flutter/material.dart';

class FinanceBackground extends StatelessWidget {
  final String brandName;
  final Widget child;
  final VoidCallback? onMenu;
  final VoidCallback? onReload;
  final bool isLoading;

  const FinanceBackground({
    super.key,
    required this.brandName,
    required this.child,
    this.onMenu,
    this.onReload,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // ============================================================
          // HEADER BACKGROUND
          // ============================================================
          Container(
            height: 285,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
              gradient: LinearGradient(
                colors: [
                  MyColors.primary,
                  MyColors.primaryDark,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomLeft,
              ),
            ),
          ),

          // ============================================================
          // DECORATION - LEFT
          // ============================================================
          Positioned(
            top: -90,
            left: -50,
            child: Container(
              width: 190,
              height: 190,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(
                  alpha: 0.12,
                ),
              ),
            ),
          ),

          // ============================================================
          // DECORATION - RIGHT
          // ============================================================
          Positioned(
            top: 45,
            right: -55,
            child: Container(
              width: 125,
              height: 125,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(
                  alpha: 0.12,
                ),
              ),
            ),
          ),

          Positioned(
            top: 65,
            right: -38,
            child: Container(
              width: 82,
              height: 82,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: MyColors.primary,
              ),
            ),
          ),

          // ============================================================
          // HEADER CONTENT
          // ============================================================
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                16,
                8,
                16,
                0,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // MENU
                  _FinanceHeaderButton(
                    icon: Icons.menu_rounded,
                    onTap: onMenu,
                  ),

                  const SizedBox(width: 12),

                  // TITLE
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Riwayat Transaksi',
                          style: TextStyle(
                            fontSize: 20,
                            height: 1.1,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(
                              Icons.storefront_rounded,
                              size: 14,
                              color: Colors.white70,
                            ),
                            const SizedBox(width: 5),
                            Flexible(
                              child: Text(
                                brandName.isEmpty ? 'Brand aktif' : brandName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white70,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // RELOAD
                  _FinanceHeaderButton(
                    icon: Icons.refresh_rounded,
                    onTap: isLoading ? null : onReload,
                    loading: isLoading,
                  ),
                ],
              ),
            ),
          ),

          // ============================================================
          // CONTENT / SUMMARY
          // ============================================================
          Positioned(
            top: 112,
            left: 16,
            right: 16,
            child: child,
          ),
        ],
      ),
    );
  }
}

class _FinanceHeaderButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final bool loading;

  const _FinanceHeaderButton({
    required this.icon,
    this.onTap,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Ink(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white.withValues(
              alpha: 0.10,
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.white.withValues(
                alpha: 0.10,
              ),
            ),
          ),
          child: Center(
            child: loading
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : Icon(
                    icon,
                    size: 20,
                    color: Colors.white,
                  ),
          ),
        ),
      ),
    );
  }
}
