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
  int? idKios;
  String? kios;
  int? idCabang;
  String? cabang;
  String? alamatCabang;
  String? phoneCabang;
  bool? statusCabang;
  int? idKasir;
  String? usernameKasir;
  String? passwordKasir;
  String? namaKasir;
  String? phoneKasir;
  bool? statusKasir;
  String? keterangan;
  int? defaultOutlet;

  DataEmployee(
      {this.idKios,
      this.kios,
      this.idCabang,
      this.cabang,
      this.alamatCabang,
      this.phoneCabang,
      this.statusCabang,
      this.idKasir,
      this.usernameKasir,
      this.passwordKasir,
      this.namaKasir,
      this.phoneKasir,
      this.statusKasir,
      this.keterangan,
      this.defaultOutlet});

  DataEmployee.fromJson(Map<String, dynamic> json) {
    idKios = json['id_kios'];
    kios = json['kios'];
    idCabang = json['id_cabang'];
    cabang = json['cabang'];
    alamatCabang = json['alamat_cabang'];
    phoneCabang = json['phone_cabang'];
    statusCabang = json['status_cabang'];
    idKasir = json['id_kasir'];
    usernameKasir = json['username_kasir'];
    passwordKasir = json['password_kasir'];
    namaKasir = json['nama_kasir'];
    phoneKasir = json['phone_kasir'];
    statusKasir = json['status_kasir'];
    keterangan = json['keterangan'];
    defaultOutlet = json['default_outlet'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id_kios'] = idKios;
    data['kios'] = kios;
    data['id_cabang'] = idCabang;
    data['cabang'] = cabang;
    data['alamat_cabang'] = alamatCabang;
    data['phone_cabang'] = phoneCabang;
    data['status_cabang'] = statusCabang;
    data['id_kasir'] = idKasir;
    data['username_kasir'] = usernameKasir;
    data['password_kasir'] = passwordKasir;
    data['nama_kasir'] = namaKasir;
    data['phone_kasir'] = phoneKasir;
    data['status_kasir'] = statusKasir;
    data['keterangan'] = keterangan;
    data['default_outlet'] = defaultOutlet;
    return data;
  }
}
