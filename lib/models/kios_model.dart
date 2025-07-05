class KiosModel {
  int? idOwner;
  int? idKios;
  String? kios;

  KiosModel({this.idOwner, this.idKios, this.kios});

  KiosModel.fromJson(Map<String, dynamic> json) {
    idOwner = json['id_owner'];
    idKios = json['id_kios'];
    kios = json['kios'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id_owner'] = idOwner;
    data['id_kios'] = idKios;
    data['kios'] = kios;
    return data;
  }
}
