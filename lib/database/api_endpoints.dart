class ApiEndPoints {
  static const String baseUrl = 'http://103.184.181.9/apiGlobal/';
  static _AuthEndPoints authEndpoints = _AuthEndPoints();
}

class _AuthEndPoints {
  final String login = 'loginadmin';
  final String homeTotalSaldo = 'FinancialTotalSaldo';
  final String homeTotalBranchSaldo = 'FinancialTotalBranchSaldo';
  final String homeTotalPerMonth = 'FinanciaGetSaldoPerBulan';

  //HISTORY
  final String histories = 'FinancialHistories';
  final String saveTransactionExpense = 'financialsavetransactionexpense';
  final String saveTransactionIncome = 'financialsavetransactionincome';
  final String deletehistory = 'financialdeletehistory';

  // KIOS
  final String listkios = 'FinancialListKios';
  final String listcabangkios = 'FinancialListCabangKios';

  // CATEGORY
  final String listcategories = 'FinancialListCategories';
  final String savecategories = 'financialsavecategory';
  final String detailcategory = 'financialdetailcategory';
  final String updateCategory = 'financialupdatecategory';
  final String updatecategorystatus = 'financialupdatecategorystatus';
  final String deletecategory = 'financialdeletecategory';

  //MONITORING
  final String monitoringbydaterange = 'financialmonitoringoutletbydaterange';
  final String monitoringbymonth = 'financialmonitoringoutletbymonth';
}
