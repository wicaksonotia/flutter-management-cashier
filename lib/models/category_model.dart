class CategoryModel {
  int? id;
  String? categoryName;
  String? categoryType;
  bool? status;
  String? createdAt;

  CategoryModel(
      {this.id,
      this.categoryName,
      this.categoryType,
      this.status,
      this.createdAt});

  CategoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryName = json['category_name'];
    categoryType = json['category_type'];
    status = json['status'] == true;
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toMapInsert() {
    return {
      'category_name': categoryName,
      'category_type': categoryType,
    };
  }

  Map<String, dynamic> toMapUpdate() {
    return {
      'id': id,
      'category_name': categoryName,
      'category_type': categoryType,
    };
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['category_name'] = categoryName;
    data['category_type'] = categoryType;
    data['status'] = status;
    data['created_at'] = createdAt;
    return data;
  }
}
