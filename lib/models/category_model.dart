class CategoryModel {
  int? id;
  String? categoryName;
  String? transactionType;
  bool? status;

  CategoryModel(
      {this.id, this.categoryName, this.transactionType, this.status});

  CategoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryName = json['category_name'];
    transactionType = json['category_type'];
    status = json['status'] == true;
  }

  Map<String, dynamic> toMapInsert() {
    return {
      'category_name': categoryName,
      'category_type': transactionType,
    };
  }

  Map<String, dynamic> toMapUpdate() {
    return {
      'id': id,
      'category_name': categoryName,
      'category_type': transactionType,
    };
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['category_name'] = categoryName;
    data['category_type'] = transactionType;
    data['status'] = status;
    return data;
  }
}
