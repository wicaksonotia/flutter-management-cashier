class EmployeeModel {
  String? status;
  String? message;
  List<DataEmployee>? data;

  EmployeeModel({this.status, this.message, this.data});

  EmployeeModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <DataEmployee>[];
      json['data'].forEach((v) {
        data!.add(DataEmployee.fromJson(v));
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

class DataEmployee {
  int? idKasir;
  String? namaKasir;
  String? phoneKasir;
  String? usernameKasir;
  bool? statusKasir;
  bool? statusTransaksi;
  int? defaultOutlet;
  String? defaultOutletName;
  int? idKios;
  String? namaKios;
  List<int>? idCabang;
  List<String>? cabang;

  DataEmployee(
      {this.idKasir,
      this.namaKasir,
      this.phoneKasir,
      this.usernameKasir,
      this.statusKasir,
      this.statusTransaksi,
      this.defaultOutlet,
      this.defaultOutletName,
      this.idKios,
      this.namaKios,
      this.idCabang,
      this.cabang});

  DataEmployee.fromJson(Map<String, dynamic> json) {
    idKasir = json['id_kasir'];
    namaKasir = json['nama_kasir'];
    phoneKasir = json['phone_kasir'];
    usernameKasir = json['username_kasir'];
    statusKasir = json['status_kasir'];
    statusTransaksi = json['status_transaksi'];
    defaultOutlet = json['default_outlet'];
    defaultOutletName = json['default_outlet_name'];
    idKios = json['id_kios'];
    namaKios = json['nama_kios'];
    idCabang = json['id_cabang'].cast<int>();
    cabang = json['cabang'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id_kasir'] = idKasir;
    data['nama_kasir'] = namaKasir;
    data['phone_kasir'] = phoneKasir;
    data['username_kasir'] = usernameKasir;
    data['status_kasir'] = statusKasir;
    data['status_transaksi'] = statusTransaksi;
    data['default_outlet'] = defaultOutlet;
    data['default_outlet_name'] = defaultOutletName;
    data['id_kios'] = idKios;
    data['nama_kios'] = namaKios;
    data['id_cabang'] = idCabang;
    data['cabang'] = cabang;
    return data;
  }
}
