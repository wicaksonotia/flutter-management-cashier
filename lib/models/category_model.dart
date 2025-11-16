class CategoryModel {
  String? status;
  int? page;
  int? limit;
  int? total;
  bool? hasMore;
  List<DataCategory>? data;

  CategoryModel(
      {this.status,
      this.page,
      this.limit,
      this.total,
      this.hasMore,
      this.data});

  CategoryModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    page = json['page'];
    limit = json['limit'];
    total = json['total'];
    hasMore = json['hasMore'];
    if (json['data'] != null) {
      data = <DataCategory>[];
      json['data'].forEach((v) {
        data!.add(DataCategory.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['page'] = page;
    data['limit'] = limit;
    data['total'] = total;
    data['hasMore'] = hasMore;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DataCategory {
  int? id;
  String? categoryName;
  String? categoryType;
  bool? status;
  int? statusTransaksi;

  DataCategory(
      {this.id,
      this.categoryName,
      this.categoryType,
      this.status,
      this.statusTransaksi});

  DataCategory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryName = json['category_name'];
    categoryType = json['category_type'];
    status = json['status'];
    statusTransaksi = json['status_transaksi'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['category_name'] = categoryName;
    data['category_type'] = categoryType;
    data['status'] = status;
    data['status_transaksi'] = statusTransaksi;
    return data;
  }
}
