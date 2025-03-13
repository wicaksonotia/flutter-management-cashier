class TotalPerTypeModel {
  String? gambar;
  String? status;
  String? message;
  List<DataList>? data;

  TotalPerTypeModel({this.status, this.message, this.data});

  TotalPerTypeModel.fromJson(Map<String, dynamic> json) {
    gambar = json['gambar'];
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <DataList>[];
      json['data'].forEach((v) {
        data!.add(DataList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['gambar'] = gambar;
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DataList {
  String? gambar;
  String? kategori;
  int? total;

  DataList({this.gambar, this.kategori, this.total});

  DataList.fromJson(Map<String, dynamic> json) {
    gambar = json['gambar'];
    kategori = json['kategori'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['gambar'] = gambar;
    data['kategori'] = kategori;
    data['total'] = total;
    return data;
  }
}
