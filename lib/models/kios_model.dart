class KiosModel {
  int? idKios;
  String? kios;
  String? phone;
  String? keterangan;
  bool? isActive;
  String? logo;
  int? totalCabang;
  int? totalIncome;
  int? totalExpense;
  int? totalBalance;

  KiosModel(
      {this.idKios,
      this.kios,
      this.phone,
      this.keterangan,
      this.isActive,
      this.logo,
      this.totalCabang,
      this.totalIncome,
      this.totalExpense,
      this.totalBalance});

  KiosModel.fromJson(Map<String, dynamic> json) {
    idKios = json['id_kios'];
    kios = json['kios'];
    phone = json['phone'];
    keterangan = json['keterangan'];
    isActive = json['is_active'];
    logo = json['logo'];
    totalCabang = json['total_cabang'] ?? 0;
    totalIncome = json['total_income'] ?? 0;
    totalExpense = json['total_expense'] ?? 0;
    totalBalance = json['total_balance'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id_kios'] = idKios;
    data['kios'] = kios;
    data['phone'] = phone;
    data['keterangan'] = keterangan;
    data['is_active'] = isActive;
    data['logo'] = logo;
    data['total_cabang'] = totalCabang;
    data['total_income'] = totalIncome;
    data['total_expense'] = totalExpense;
    data['total_balance'] = totalBalance;
    return data;
  }
}
