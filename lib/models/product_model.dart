import 'dart:convert';
import 'dart:typed_data';

class ProductModel {
  String? status;
  String? message;
  List<DataProduct>? data;

  ProductModel({this.status, this.message, this.data});

  ProductModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <DataProduct>[];
      json['data'].forEach((v) {
        data!.add(DataProduct.fromJson(v));
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

class DataProduct {
  int? idProduct;
  int? idProductCategories;
  String? name;
  String? description;
  int? price;
  bool? status;
  bool? promo;
  bool? favorite;
  int? sorting;
  int? statusTransaksi;
  Uint8List? photo1;

  DataProduct(
      {this.idProduct,
      this.idProductCategories,
      this.name,
      this.description,
      this.price,
      this.status,
      this.promo,
      this.favorite,
      this.sorting,
      this.statusTransaksi,
      this.photo1});

  DataProduct.fromJson(Map<String, dynamic> json) {
    idProduct = json['id_product'];
    idProductCategories = json['id_product_categories'];
    name = json['name'];
    description = json['description'];
    price = json['price'];
    status = json['status'];
    promo = json['promo'];
    favorite = json['favorite'];
    sorting = json['sorting'];
    statusTransaksi = json['status_transaksi'];
    Uint8List decodePhoto;
    decodePhoto = const Base64Decoder().convert('${json['photo_1']}');
    photo1 = decodePhoto;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id_product'] = idProduct;
    data['id_product_categories'] = idProductCategories;
    data['name'] = name;
    data['description'] = description;
    data['price'] = price;
    data['status'] = status;
    data['promo'] = promo;
    data['favorite'] = favorite;
    data['sorting'] = sorting;
    data['status_transaksi'] = statusTransaksi;
    data['photo_1'] = photo1;
    return data;
  }
}
