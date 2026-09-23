import 'package:cashier_management/controllers/cabang_controller.dart';
import 'package:cashier_management/pages/navigation_drawer.dart'
    as custom_drawer;
import 'package:cashier_management/pages/setting/branch/widget/branch_card.dart';
import 'package:cashier_management/pages/setting/branch/widget/branch_empty_state.dart';
import 'package:cashier_management/pages/setting/branch/widget/branch_loading_state.dart';
import 'package:cashier_management/routes.dart';
import 'package:cashier_management/utils/colors.dart';
import 'package:cashier_management/utils/management_header.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BranchPage extends StatefulWidget {
  const BranchPage({super.key});

  @override
  State<BranchPage> createState() => _BranchPageState();
}

class _BranchPageState extends State<BranchPage> {
  late final CabangController cabangController;

  @override
  void initState() {
    super.initState();

    cabangController = Get.isRegistered<CabangController>()
        ? Get.find<CabangController>()
        : Get.put(CabangController());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      cabangController.fetchDataListCabangFinancial();
    });
  }

  Future<void> _refresh() async {
    await cabangController.fetchDataListCabangFinancial();
  }

  void _handleBack() {
    Navigator.pop(context);
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
              title: 'Management Outlet',
              subtitle: 'Brand ${cabangController.headerNamaKios.value}',
              addLabel: 'Tambah Outlet',
              onAddTap: _addOutlet,
              showBack: true,
              onBackTap: _handleBack,
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Obx(() {
                if (cabangController.isLoadingList.value) {
                  return const BranchLoadingState();
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
    final data = cabangController.resultItem;

    if (data.isEmpty) {
      return const BranchEmptyState();
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
        _buildSectionHeader(data.length),
        const SizedBox(height: 10),
        ...List.generate(
          data.length,
          (index) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: index == data.length - 1 ? 0 : 12,
              ),
              child: BranchCard(
                quotation: data[index],
                controller: cabangController,
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildSectionHeader(int total) {
    return Row(
      children: [
        const Expanded(
          child: Text(
            'Daftar Outlet',
            style: TextStyle(
              color: MyColors.textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 9,
            vertical: 5,
          ),
          decoration: BoxDecoration(
            color: MyColors.surfaceSoft,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            '$total outlet',
            style: const TextStyle(
              color: MyColors.textSecondary,
              fontSize: 10,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }

  void _addOutlet() {
    cabangController.branchId.value = 0;

    Get.toNamed(
      RouterClass.addbranch,
    );
  }
}
