class ProductCategoryModel {
  String? status;
  String? message;
  List<DataProductCategory>? data;

  ProductCategoryModel({this.status, this.message, this.data});

  ProductCategoryModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <DataProductCategory>[];
      json['data'].forEach((v) {
        data!.add(DataProductCategory.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DataProductCategory {
  int? idCategories;
  String? name;
  int? idKios;
  bool? status;
  int? sorting;
  int? statusProduk;

  DataProductCategory({
    this.idCategories,
    this.name,
    this.idKios,
    this.status,
    this.sorting,
    this.statusProduk,
  });

  DataProductCategory.fromJson(Map<String, dynamic> json) {
    idCategories = json['id_categories'];
    name = json['name'];
    idKios = json['id_kios'];
    status = json['status'];
    sorting = json['sorting'];
    statusProduk = json['status_produk'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id_categories'] = idCategories;
    data['name'] = name;
    data['id_kios'] = idKios;
    data['status'] = status;
    data['sorting'] = sorting;
    data['status_produk'] = statusProduk;
    return data;
  }
}
