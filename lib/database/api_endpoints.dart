class ApiEndPoints {
  static const String baseUrl = 'http://103.184.181.9/apiGlobal/';
  static _AuthEndPoints authEndpoints = _AuthEndPoints();
}

class _AuthEndPoints {
  final String login = 'loginadmin';
  final String homeHistorybydate = 'FinancialHistoryByDate';
  final String homeTotalSaldo = 'FinancialTotalSaldo';
  final String homeTotalBranchSaldo = 'FinancialTotalBranchSaldo';
  final String homeTotalPerMonth = 'FinanciaGetSaldoPerBulan';

  // CATEGORY
  final String savecategories = 'financialsavecategory';
  final String listcategories = 'financiallistcategories';
  final String detailcategory = 'financialdetailcategory';
  final String updateCategory = 'financialupdatecategory';
  final String updatecategorystatus = 'financialupdatecategorystatus';
  final String deletecategory = 'financialdeletecategory';

  //HISTORY
  final String historybydaterange = 'financialhistorybydaterange';
  final String historybymonth = 'financialhistorybymonth';
  final String historybyyear = 'financialhistorybyyear';
  final String saveTransactionExpense = 'financialsavetransactionexpense';
  final String saveTransactionIncome = 'financialsavetransactionincome';
  final String deletehistory = 'financialdeletehistory';

  //MONITORING
  final String monitoringbydaterange = 'financialmonitoringoutletbydaterange';
  final String monitoringbymonth = 'financialmonitoringoutletbymonth';
  final String listoutlet = 'financialmonitoringoutletlist';
}
