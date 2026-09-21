import 'package:cashier_management/controllers/product_controller.dart';
import 'package:cashier_management/pages/navigation_drawer.dart'
    as custom_drawer;
import 'package:cashier_management/pages/setting/product_management/widget/product_category_management.dart';
import 'package:cashier_management/pages/setting/product_management/widget/product_list_management.dart';
import 'package:cashier_management/pages/setting/product_management/widget/product_management_header.dart';
import 'package:cashier_management/pages/setting/product_management/widget/product_management_tabs.dart';
import 'package:cashier_management/routes.dart';
import 'package:cashier_management/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductManagementPage extends StatefulWidget {
  const ProductManagementPage({super.key});

  @override
  State<ProductManagementPage> createState() => _ProductManagementPageState();
}

class _ProductManagementPageState extends State<ProductManagementPage>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  late final ProductController controller;
  late final TabController tabController;

  @override
  void initState() {
    super.initState();

    controller = Get.isRegistered<ProductController>()
        ? Get.find<ProductController>()
        : Get.put(ProductController());

    tabController = TabController(
      length: 2,
      vsync: this,
    );

    tabController.addListener(() {
      if (!tabController.indexIsChanging) {
        setState(() {});
      }
    });

    _loadData();
  }

  Future<void> _loadData() async {
    await controller.initializeBaseController();

    if (controller.idKios.value <= 0) {
      debugPrint(
        '[PRODUCT MANAGEMENT] idKios belum tersedia',
      );
      return;
    }

    debugPrint(
      '[PRODUCT MANAGEMENT] '
      'load dengan idKios: ${controller.idKios.value}',
    );

    await controller.fetchDataListProductCategory();
  }

  void _addData() {
    if (tabController.index == 0) {
      controller.clearProductController();

      Get.toNamed(
        RouterClass.addProduct,
      );
    } else {
      controller.clearProductCategoryController();

      Get.toNamed(
        RouterClass.addProductCategory,
      );
    }
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      drawer: const custom_drawer.NavigationDrawer(),
      backgroundColor: MyColors.background,
      body: SafeArea(
        child: Column(
          children: [
            ProductManagementHeader(
              title: tabController.index == 0 ? 'Produk' : 'Kategori',
              subtitle: tabController.index == 0
                  ? 'Kelola katalog produk'
                  : 'Kelola kategori produk',
              addLabel: tabController.index == 0 ? 'Produk' : 'Kategori',
              onMenuTap: () {
                scaffoldKey.currentState?.openDrawer();
              },
              onAddTap: _addData,
            ),
            const SizedBox(height: 8),
            ProductManagementTabs(
              controller: tabController,
            ),
            const SizedBox(height: 10),
            Expanded(
              child: TabBarView(
                controller: tabController,
                children: const [
                  ProductListManagement(),
                  ProductCategoryManagement(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
