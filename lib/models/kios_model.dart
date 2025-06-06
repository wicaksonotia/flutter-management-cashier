class KiosModel {
  int? id;
  String? kios;
  String? username;
  String? password;
  bool? accountStatus;
  String? alamat;
  String? gambar;

  KiosModel(
      {this.id,
      this.kios,
      this.username,
      this.password,
      this.accountStatus,
      this.alamat,
      this.gambar});

  KiosModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    kios = json['kios'];
    username = json['username'];
    password = json['password'];
    accountStatus = json['account_status'];
    alamat = json['alamat'];
    gambar = json['gambar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['kios'] = kios;
    data['username'] = username;
    data['password'] = password;
    data['account_status'] = accountStatus;
    data['alamat'] = alamat;
    data['gambar'] = gambar;
    return data;
  }
}
