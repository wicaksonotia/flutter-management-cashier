class ApiEndPoints {
  static const String ipPublic = 'http://36.93.148.82/pkbsurabaya/';

  static const String baseUrl = '${ipPublic}apiGlobal/';

  static final _AuthEndPoints authEndpoints = _AuthEndPoints();
}

class _AuthEndPoints {
  // ============================================================
  // LOGIN
  // ============================================================

  final String login = 'loginadmin';

  // ============================================================
  // HOME
  // ============================================================

  final String homeTotalSaldo = 'FinancialTotalSaldo';

  final String homeTotalBranchSaldo = 'FinancialTotalBranchSaldo';

  final String homeTotalPerMonth = 'FinanciaGetSaldoPerBulan';

  // ============================================================
  // HISTORY / TRANSACTION
  // ============================================================

  final String histories = 'FinancialHistories';

  final String saveTransaction = 'FinancialSaveTransaction';

  final String updateTransaction = 'FinancialUpdateTransaction';

  final String deleteHistory = 'FinancialDeleteHistory';

  // ============================================================
  // KIOS
  // ============================================================

  final String listKiosAndDetail = 'FinancialListKiosAndDetail';

  final String listKios = 'FinancialListKios';

  final String saveKios = 'FinancialSaveKios';

  final String deleteKios = 'FinancialDeleteKios';

  final String updateStatusOutlet = 'FinancialUpdateStatusOutlet';

  // ============================================================
  // CABANG
  // ============================================================

  final String saveCabang = 'FinancialSaveCabang';

  final String deleteBranch = 'FinancialDeleteBranch';

  final String updateStatusBranch = 'FinancialUpdateStatusBranch';

  final String listCabangKios = 'FinancialListCabangKios';

  // ============================================================
  // PROFILE
  // ============================================================

  final String updateProfile = 'FinancialUpdateProfile';

  final String changePassword = 'FinancialChangePassword';

  // ============================================================
  // CATEGORY
  // ============================================================

  final String listCategories = 'FinancialListCategories';

  final String saveCategory = 'FinancialSaveCategory';

  final String detailCategory = 'FinancialDetailCategory';

  final String updateCategory = 'FinancialUpdateCategory';

  final String updateCategoryStatus = 'FinancialUpdateCategoryStatus';

  final String deleteCategory = 'FinancialDeleteCategory';

  // ============================================================
  // MONITORING
  // ============================================================

  final String monitoringByDateRange = 'FinancialMonitoringOutletByDateRange';

  final String monitoringByMonth = 'FinancialMonitoringOutletByMonth';

  // ============================================================
  // EMPLOYEE
  // ============================================================

  final String listEmployee = 'FinancialListEmployee';

  final String saveEmployee = 'FinancialSaveEmployee';

  final String updateEmployeeStatus = 'FinancialUpdateEmployeeStatus';

  final String updateEmployeeBranch = 'FinancialUpdateEmployeeBranch';

  final String deleteEmployee = 'FinancialDeleteEmployee';

  final String resetPassword = 'FinancialResetPassword';

  // ============================================================
  // PRODUCT CATEGORY
  // ============================================================

  final String listProductCategory = 'FinancialListProductCategory';

  final String saveProductCategory = 'FinancialSaveProductCategory';

  final String updateProductCategoryStatus =
      'FinancialUpdateProductCategoryStatus';

  final String deleteProductCategory = 'FinancialDeleteProductCategory';

  final String updateProductCategorySorting =
      'FinancialUpdateProductCategorySorting';

  // ============================================================
  // PRODUCT
  // ============================================================

  final String listProduct = 'FinancialListProduct';

  final String saveProduct = 'FinancialSaveProduct';

  final String updateProductStatus = 'FinancialUpdateProductStatus';

  final String updateProductFavorite = 'FinancialUpdateProductFavorite';

  final String deleteProduct = 'FinancialDeleteProduct';

  final String updateProductSorting = 'FinancialUpdateProductSorting';
}
