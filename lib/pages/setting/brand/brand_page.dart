import 'package:cashier_management/controllers/cabang_controller.dart';
import 'package:cashier_management/controllers/kios_controller.dart';
import 'package:cashier_management/pages/navigation_drawer.dart'
    as custom_drawer;
import 'package:cashier_management/pages/setting/brand/widget/brand_card.dart';
import 'package:cashier_management/pages/setting/brand/widget/brand_empty_state.dart';
import 'package:cashier_management/pages/setting/brand/widget/brand_loading_state.dart';
import 'package:cashier_management/pages/setting/brand/widget/brand_summary.dart';
import 'package:cashier_management/routes.dart';
import 'package:cashier_management/utils/colors.dart';
import 'package:cashier_management/utils/management_header.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class BrandPage extends StatefulWidget {
  const BrandPage({super.key});

  @override
  State<BrandPage> createState() => _BrandPageState();
}

class _BrandPageState extends State<BrandPage> {
  late final KiosController kiosController;
  late final CabangController cabangController;

  @override
  void initState() {
    super.initState();

    kiosController = Get.isRegistered<KiosController>()
        ? Get.find<KiosController>()
        : Get.put(KiosController());

    cabangController = Get.isRegistered<CabangController>()
        ? Get.find<CabangController>()
        : Get.put(CabangController());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      kiosController.fetchDataListKiosFinancial();
    });
  }

  Future<void> _refresh() async {
    await kiosController.fetchDataListKiosFinancial();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const custom_drawer.NavigationDrawer(),
      backgroundColor: MyColors.background,
      body: SafeArea(
        child: Column(
          children: [
            ManagementHeader(
              title: 'Management Brand',
              subtitle: 'Kelola brand, outlet, dan informasi keuangan',
              addLabel: 'Tambah Brand',
              onAddTap: _addBrand,
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Obx(() {
                if (kiosController.isLoadingFinancialKios.value) {
                  return const BrandLoadingState();
                }

                return RefreshIndicator(
                  color: MyColors.primary,
                  backgroundColor: MyColors.surface,
                  onRefresh: _refresh,
                  child: _buildContent(),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    final data = kiosController.resultDataKios;

    if (data.isEmpty) {
      return const BrandEmptyState();
    }

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(
        16,
        4,
        16,
        24,
      ),
      children: [
        BrandSummary(data: data),
        const Gap(18),
        ...List.generate(
          data.length,
          (index) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: index == data.length - 1 ? 0 : 12,
              ),
              child: BrandCard(
                quotation: data[index],
                controller: kiosController,
                cabangController: cabangController,
              ),
            );
          },
        ),
      ],
    );
  }

  void _addBrand() {
    kiosController.clearOutletController();

    Navigator.of(context).pushNamed(
      RouterClass.addoutlet,
    );
  }
}
