class ApiEndPoints {
  // static const String baseUrl = 'http://103.184.181.9/apiGlobal/';
  static const String ipPublic = 'http://36.93.148.82/pkbsurabaya/';
  static const String baseUrl = '${ipPublic}apiGlobal/';
  static _AuthEndPoints authEndpoints = _AuthEndPoints();
}

class _AuthEndPoints {
  final String login = 'loginadmin';
  final String homeTotalSaldo = 'FinancialTotalSaldo';
  final String homeTotalBranchSaldo = 'FinancialTotalBranchSaldo';
  final String homeTotalPerMonth = 'FinanciaGetSaldoPerBulan';

  // HISTORY
  final String histories = 'FinancialHistories';
  final String saveTransactionExpense = 'FinancialSaveTransactionExpense';
  final String saveTransactionIncome = 'FinancialSaveTransactionIncome';
  final String deleteHistory = 'FinancialDeleteHistory';

  // KIOS
  final String listKiosAndDetail = 'FinancialListKiosAndDetail';
  final String listKios = 'FinancialListKios';
  final String saveKios = 'FinancialSaveKios';
  final String deleteKios = 'FinancialDeleteKios';
  final String updateStatusOutlet = 'FinancialUpdateStatusOutlet';

  // CABANG
  final String saveCabang = 'FinancialSaveCabang';
  final String deleteBranch = 'FinancialDeleteBranch';
  final String updateStatusBranch = 'FinancialUpdateStatusBranch';
  final String listCabangKios = 'FinancialListCabangKios';

  // PROFILE
  final String updateProfile = 'FinancialUpdateProfile';
  final String changePassword = 'FinancialChangePassword';

  // CATEGORY
  final String listCategories = 'FinancialListCategories';
  final String saveCategory = 'FinancialSaveCategory';
  final String detailCategory = 'FinancialDetailCategory';
  final String updateCategory = 'FinancialUpdateCategory';
  final String updateCategoryStatus = 'FinancialUpdateCategoryStatus';
  final String deleteCategory = 'FinancialDeleteCategory';

  // MONITORING
  final String monitoringByDateRange = 'FinancialMonitoringOutletByDateRange';
  final String monitoringByMonth = 'FinancialMonitoringOutletByMonth';

  // EMPLOYEE
  final String listEmployee = 'FinancialListEmployee';
  final String saveEmployee = 'FinancialSaveEmployee';
  final String detailEmployee = 'FinancialDetailEmployee';
  final String updateEmployee = 'FinancialUpdateEmployee';
  final String updateEmployeeStatus = 'FinancialUpdateEmployeeStatus';
  final String updateEmployeeBranch = 'FinancialUpdateEmployeeBranch';
  final String deleteEmployee = 'FinancialDeleteEmployee';
}
