class OutletBranchModel {
  String? status;
  String? message;
  List<DataListOutletBranch>? data;

  OutletBranchModel({this.status, this.message, this.data});

  OutletBranchModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <DataListOutletBranch>[];
      json['data'].forEach((v) {
        data!.add(DataListOutletBranch.fromJson(v));
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

class DataListOutletBranch {
  int? id;
  int? idKios;
  String? cabang;
  String? alamat;
  String? phone;
  bool? status;
  Details? details;

  DataListOutletBranch(
      {this.id,
      this.idKios,
      this.cabang,
      this.alamat,
      this.phone,
      this.status,
      this.details});

  DataListOutletBranch.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    idKios = json['id_kios'];
    cabang = json['cabang'];
    alamat = json['alamat'];
    phone = json['phone'];
    status = json['status'];
    details =
        json['details'] != null ? Details.fromJson(json['details']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['id_kios'] = idKios;
    data['cabang'] = cabang;
    data['alamat'] = alamat;
    data['phone'] = phone;
    data['status'] = status;
    if (details != null) {
      data['details'] = details!.toJson();
    }
    return data;
  }
}

class Details {
  int? income;
  int? expense;
  int? balance;

  Details({this.income, this.expense, this.balance});

  Details.fromJson(Map<String, dynamic> json) {
    income = json['income'];
    expense = json['expense'];
    balance = json['balance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['income'] = income;
    data['expense'] = expense;
    data['balance'] = balance;
    return data;
  }
}
