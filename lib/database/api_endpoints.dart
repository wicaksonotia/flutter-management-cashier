class ApiEndPoints {
  static const String baseUrl = 'http://103.184.181.9/api/';
  static _AuthEndPoints authEndpoints = _AuthEndPoints();
}

class _AuthEndPoints {
  final String login = 'loginkios';
  // CATEGORY
  final String savecategories = 'financialsavecategory';
  final String listcategories = 'financiallistcategories';
  final String detailcategory = 'financialdetailcategory';
  final String updateCategory = 'financialupdatecategory';
  final String updatecategorystatus = 'financialupdatecategorystatus';
  final String deletecategory = 'financialdeletecategory';

  //TOTAL PER TYPE
  final String totalpertype = 'financialtotalpertype';
}
