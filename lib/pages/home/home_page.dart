import 'package:cashier_management/controllers/history_controller.dart';
import 'package:cashier_management/controllers/kios_controller.dart';
import 'package:cashier_management/controllers/total_per_type_controller.dart';
import 'package:cashier_management/pages/home/widgets/home_app_bar.dart';
import 'package:cashier_management/pages/home/widgets/home_branch_performance.dart';
import 'package:cashier_management/pages/home/widgets/home_hero_card.dart';
import 'package:cashier_management/pages/home/widgets/home_quick_actions.dart';
import 'package:cashier_management/pages/home/widgets/home_recent_transactions.dart';
import 'package:cashier_management/pages/home/widgets/home_sales_chart.dart';
import 'package:cashier_management/pages/home/widgets/home_section_header.dart';
import 'package:cashier_management/pages/home/widgets/home_stat_card.dart';
import 'package:cashier_management/pages/navigation_drawer.dart'
    as custom_drawer;
import 'package:cashier_management/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TotalPerTypeController totalController =
      Get.find<TotalPerTypeController>();

  final HistoryController historyController = Get.find<HistoryController>();

  final KiosController kiosController = Get.find<KiosController>();

  Future<void> _refresh() async {
    await Future.wait([
      Future.sync(() => totalController.getTotalSaldo()),
      Future.sync(() => totalController.getTotalBranchSaldo()),
      Future.sync(() => totalController.getTotalPerMonth()),
      Future.sync(() => historyController.getHistoriesBySingleDate()),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const custom_drawer.NavigationDrawer(),
      backgroundColor: MyColors.background,
      appBar: HomeAppBar(
        kiosController: kiosController,
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        color: MyColors.primary,
        backgroundColor: MyColors.surface,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          padding: const EdgeInsets.fromLTRB(
            16,
            8,
            16,
            32,
          ),
          children: [
            const HomeHeroCard(),
            const SizedBox(height: 20),
            const HomeSectionHeader(
              title: 'Ringkasan Hari Ini',
            ),
            const SizedBox(height: 10),
            const Row(
              children: [
                Expanded(
                  child: HomeStatCard(
                    icon: Icons.receipt_long_rounded,
                    title: 'Transaksi',
                    value: '128',
                    subtitle: 'hari ini',
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: HomeStatCard(
                    icon: Icons.shopping_bag_rounded,
                    title: 'Produk',
                    value: '246',
                    subtitle: 'terjual',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Row(
              children: [
                Expanded(
                  child: HomeStatCard(
                    icon: Icons.payments_rounded,
                    title: 'Rata-rata',
                    value: 'Rp 32K',
                    subtitle: 'per transaksi',
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: HomeStatCard(
                    icon: Icons.trending_up_rounded,
                    title: 'Pertumbuhan',
                    value: '+12.8%',
                    subtitle: 'vs kemarin',
                    accent: true,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const HomeSectionHeader(
              title: 'Akses Cepat',
            ),
            const SizedBox(height: 10),
            const HomeQuickActions(),
            const SizedBox(height: 24),
            HomeSectionHeader(
              title: 'Performa Penjualan',
              actionText: 'Bulan ini',
              onActionTap: () {},
            ),
            const SizedBox(height: 10),
            const HomeSalesChart(),
            const SizedBox(height: 24),
            HomeSectionHeader(
              title: 'Performa Outlet',
              actionText: 'Lihat semua',
              onActionTap: () {},
            ),
            const SizedBox(height: 10),
            const HomeBranchPerformance(),
            const SizedBox(height: 24),
            HomeSectionHeader(
              title: 'Transaksi Terbaru',
              actionText: 'Lihat semua',
              onActionTap: () {},
            ),
            const SizedBox(height: 10),
            const HomeRecentTransactions(),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
