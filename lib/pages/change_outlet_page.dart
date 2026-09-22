import 'package:cashier_management/controllers/history_controller.dart';
import 'package:cashier_management/controllers/kios_controller.dart';
import 'package:cashier_management/controllers/monitoring_outlet_controller.dart';
import 'package:cashier_management/controllers/product_controller.dart';
import 'package:cashier_management/controllers/total_per_type_controller.dart';
import 'package:cashier_management/database/api_endpoints.dart';
import 'package:cashier_management/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChangeOutletPage extends StatefulWidget {
  const ChangeOutletPage({super.key});

  @override
  State<ChangeOutletPage> createState() => _ChangeOutletPageState();
}

class _ChangeOutletPageState extends State<ChangeOutletPage> {
  // ==========================================================
  // CONTROLLERS
  // ==========================================================

  late final KiosController kiosController;
  late final TotalPerTypeController totalPerTypeController;
  late final HistoryController historyController;
  late final MonitoringOutletController monitoringOutletController;

  bool isChangingOutlet = false;

  @override
  void initState() {
    super.initState();

    kiosController = Get.isRegistered<KiosController>()
        ? Get.find<KiosController>()
        : Get.put(KiosController());

    totalPerTypeController = Get.isRegistered<TotalPerTypeController>()
        ? Get.find<TotalPerTypeController>()
        : Get.put(TotalPerTypeController());

    historyController = Get.isRegistered<HistoryController>()
        ? Get.find<HistoryController>()
        : Get.put(HistoryController());

    monitoringOutletController = Get.isRegistered<MonitoringOutletController>()
        ? Get.find<MonitoringOutletController>()
        : Get.put(MonitoringOutletController());

    _loadData();
  }

  // ==========================================================
  // LOAD DATA
  // ==========================================================

  Future<void> _loadData() async {
    await kiosController.fetchDataListKios();
  }

  // ==========================================================
  // BUILD
  // ==========================================================

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              color: MyColors.background,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(24),
              ),
            ),
            child: Obx(() {
              if (kiosController.isLoadingKios.value) {
                return const _LoadingState();
              }

              if (kiosController.resultDataKios.isEmpty) {
                return const _EmptyState();
              }

              return _buildContent();
            }),
          ),

          // ======================================================
          // CHANGE BRAND LOADING
          // ======================================================

          if (isChangingOutlet) const _ChangingOutletOverlay(),
        ],
      ),
    );
  }

  // ==========================================================
  // CONTENT
  // ==========================================================

  Widget _buildContent() {
    return Column(
      children: [
        _buildHeader(),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(
              16,
              4,
              16,
              24,
            ),
            children: [
              _buildCurrentBrand(),
              const SizedBox(height: 20),
              _buildSectionHeader(),
              const SizedBox(height: 10),
              _buildBrandList(),
            ],
          ),
        ),
      ],
    );
  }

  // ==========================================================
  // HEADER
  // ==========================================================

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        20,
        14,
        12,
        16,
      ),
      decoration: const BoxDecoration(
        color: MyColors.surface,
        border: Border(
          bottom: BorderSide(
            color: MyColors.border,
          ),
        ),
      ),
      child: Column(
        children: [
          // Drag indicator
          Container(
            width: 38,
            height: 4,
            decoration: BoxDecoration(
              color: MyColors.border,
              borderRadius: BorderRadius.circular(10),
            ),
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              // Icon
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: MyColors.primaryLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.storefront_outlined,
                  color: MyColors.primaryDark,
                  size: 21,
                ),
              ),

              const SizedBox(width: 12),

              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Brand & Outlet',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: MyColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      'Pilih brand yang ingin dikelola',
                      style: TextStyle(
                        fontSize: 12,
                        color: MyColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),

              IconButton(
                tooltip: 'Tutup',
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(
                  Icons.close_rounded,
                  color: MyColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // CURRENT BRAND
  // ==========================================================

  Widget _buildCurrentBrand() {
    return Obx(() {
      final activeName = kiosController.selectedKios.value;

      return Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: MyColors.primaryLight,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: MyColors.primary.withValues(alpha: .10),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: MyColors.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.check_circle_outline_rounded,
                color: MyColors.primary,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Brand aktif',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: MyColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    activeName.isEmpty ? '-' : activeName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: MyColors.primaryDark,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 9,
                vertical: 5,
              ),
              decoration: BoxDecoration(
                color: MyColors.surface,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'AKTIF',
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w800,
                  letterSpacing: .5,
                  color: MyColors.primary,
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  // ==========================================================
  // SECTION HEADER
  // ==========================================================

  Widget _buildSectionHeader() {
    return Row(
      children: [
        const Expanded(
          child: Text(
            'Daftar Brand',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: MyColors.textPrimary,
            ),
          ),
        ),
        Obx(
          () => Text(
            '${kiosController.resultDataKios.length} brand',
            style: const TextStyle(
              fontSize: 11,
              color: MyColors.textMuted,
            ),
          ),
        ),
      ],
    );
  }

  // ==========================================================
  // BRAND LIST
  // ==========================================================

  Widget _buildBrandList() {
    return Obx(() {
      final data = kiosController.resultDataKios;

      return Column(
        children: List.generate(
          data.length,
          (index) {
            final kios = data[index];

            return Padding(
              padding: EdgeInsets.only(
                bottom: index == data.length - 1 ? 0 : 10,
              ),
              child: _BrandCard(
                name: kios.kios ?? '-',
                description: kios.keterangan ?? '-',
                logo: kios.logo,
                isActive: kiosController.idKios.value == kios.idKios,
                enabled: !isChangingOutlet,
                onTap: () {
                  _changeOutlet(
                    kios.idKios ?? 0,
                    kios.kios ?? '',
                  );
                },
              ),
            );
          },
        ),
      );
    });
  }

  // ==========================================================
  // CHANGE BRAND
  // ==========================================================

  Future<void> _changeOutlet(
    int newKiosId,
    String newKiosName,
  ) async {
    if (newKiosId <= 0 || isChangingOutlet) {
      return;
    }

    // Brand yang sama.
    if (kiosController.idKios.value == newKiosId) {
      Navigator.of(context).pop();
      return;
    }

    setState(() {
      isChangingOutlet = true;
    });

    try {
      // ========================================================
      // UPDATE ACTIVE BRAND
      // ========================================================

      kiosController.idKios.value = newKiosId;
      kiosController.selectedKios.value = newKiosName;

      await kiosController.changeOutlet();

      // ========================================================
      // HOME
      // ========================================================

      await totalPerTypeController.getTotalBranchSaldo();
      await totalPerTypeController.getTotalPerMonth();

      // ========================================================
      // TRANSACTION HISTORY
      // ========================================================

      await historyController.changeOutlet();

      // ========================================================
      // MONITORING
      // ========================================================

      await monitoringOutletController.changeOutlet();

      // ========================================================
      // PRODUCT
      // ========================================================

      if (Get.isRegistered<ProductController>()) {
        final productController = Get.find<ProductController>();

        await productController.refreshAfterBrandChanged();
      }

      // ========================================================
      // CLOSE
      // ========================================================

      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e, stack) {
      debugPrint(
        '[CHANGE OUTLET] ERROR: $e\n$stack',
      );

      if (!mounted) return;

      setState(() {
        isChangingOutlet = false;
      });

      Get.snackbar(
        'Gagal',
        'Gagal mengganti brand.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: MyColors.errorBg,
        colorText: MyColors.error,
        icon: const Icon(
          Icons.error_outline_rounded,
          color: MyColors.error,
        ),
      );
    }
  }
}

// ============================================================================
// CHANGING OUTLET OVERLAY
// ============================================================================

class _ChangingOutletOverlay extends StatelessWidget {
  const _ChangingOutletOverlay();

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: AbsorbPointer(
        absorbing: true,
        child: Container(
          color: Colors.black.withValues(alpha: .28),
          child: Center(
            child: Container(
              width: 220,
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 22,
              ),
              decoration: BoxDecoration(
                color: MyColors.surface,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: .10),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 30,
                    height: 30,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: MyColors.primary,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Mengganti brand...',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: MyColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Sedang memuat data brand baru',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 11,
                      height: 1.4,
                      color: MyColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// BRAND CARD
// ============================================================================

class _BrandCard extends StatelessWidget {
  final String name;
  final String description;
  final String? logo;
  final bool isActive;
  final bool enabled;
  final VoidCallback onTap;

  const _BrandCard({
    required this.name,
    required this.description,
    required this.logo,
    required this.isActive,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 180),
      opacity: enabled ? 1 : .55,
      child: Material(
        color: MyColors.surface,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: enabled ? onTap : null,
          borderRadius: BorderRadius.circular(16),
          splashColor: MyColors.primary.withValues(
            alpha: .05,
          ),
          highlightColor: MyColors.primary.withValues(
            alpha: .025,
          ),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isActive
                    ? MyColors.primary.withValues(alpha: .25)
                    : MyColors.border,
                width: isActive ? 1.2 : 1,
              ),
            ),
            child: Row(
              children: [
                // ==================================================
                // LOGO
                // ==================================================

                _BrandLogo(
                  logo: logo,
                ),

                const SizedBox(width: 12),

                // ==================================================
                // INFORMATION
                // ==================================================

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: isActive
                              ? MyColors.primaryDark
                              : MyColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 11,
                          height: 1.4,
                          color: MyColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 10),

                // ==================================================
                // ACTIVE / ACTION
                // ==================================================

                if (isActive)
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: MyColors.primaryLight,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.check_rounded,
                      size: 19,
                      color: MyColors.primary,
                    ),
                  )
                else
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: MyColors.surfaceSoft,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 13,
                      color: MyColors.textMuted,
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

// ============================================================================
// BRAND LOGO
// ============================================================================

class _BrandLogo extends StatelessWidget {
  final String? logo;

  const _BrandLogo({
    required this.logo,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 62,
      height: 62,
      decoration: BoxDecoration(
        color: MyColors.surfaceSoft,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: MyColors.border,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: logo != null && logo!.trim().isNotEmpty
          ? Image.network(
              '${ApiEndPoints.ipPublic}images/logo/$logo',
              fit: BoxFit.contain,
              errorBuilder: (
                context,
                error,
                stackTrace,
              ) {
                return const _LogoPlaceholder();
              },
            )
          : const _LogoPlaceholder(),
    );
  }
}

// ============================================================================
// LOGO PLACEHOLDER
// ============================================================================

class _LogoPlaceholder extends StatelessWidget {
  const _LogoPlaceholder();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Icon(
        Icons.storefront_outlined,
        size: 28,
        color: MyColors.textMuted,
      ),
    );
  }
}

// ============================================================================
// LOADING STATE
// ============================================================================

// ============================================================================
// LOADING STATE
// ============================================================================

class _LoadingState extends StatefulWidget {
  const _LoadingState();

  @override
  State<_LoadingState> createState() => _LoadingStateState();
}

class _LoadingStateState extends State<_LoadingState>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 14),
        const _SheetDragIndicator(),
        const SizedBox(height: 22),
        Expanded(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _ShimmerBox(
                    animation: _animationController,
                    width: 64,
                    height: 64,
                    borderRadius: 14,
                  ),
                  const SizedBox(height: 16),
                  _ShimmerBox(
                    animation: _animationController,
                    width: 130,
                    height: 13,
                    borderRadius: 7,
                  ),
                  const SizedBox(height: 8),
                  _ShimmerBox(
                    animation: _animationController,
                    width: 190,
                    height: 10,
                    borderRadius: 5,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ShimmerBox extends StatelessWidget {
  final Animation<double> animation;
  final double width;
  final double height;
  final double borderRadius;

  const _ShimmerBox({
    required this.animation,
    required this.width,
    required this.height,
    required this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            final position = animation.value * 2 - 1;

            return LinearGradient(
              begin: Alignment(position - 1, 0),
              end: Alignment(position + 1, 0),
              colors: [
                MyColors.surfaceSoft,
                MyColors.border.withValues(alpha: .65),
                MyColors.surfaceSoft,
              ],
            ).createShader(bounds);
          },
          child: Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              color: MyColors.surfaceSoft,
              borderRadius: BorderRadius.circular(borderRadius),
            ),
          ),
        );
      },
    );
  }
}

// ============================================================================
// EMPTY STATE
// ============================================================================

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 14),
        const _SheetDragIndicator(),
        Expanded(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: MyColors.surfaceSoft,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: const Icon(
                      Icons.store_mall_directory_outlined,
                      size: 30,
                      color: MyColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'Belum ada brand',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: MyColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'Brand yang tersedia belum dapat ditampilkan.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      height: 1.5,
                      color: MyColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ============================================================================
// SHEET DRAG INDICATOR
// ============================================================================

class _SheetDragIndicator extends StatelessWidget {
  const _SheetDragIndicator();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 38,
      height: 4,
      decoration: BoxDecoration(
        color: MyColors.border,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}
