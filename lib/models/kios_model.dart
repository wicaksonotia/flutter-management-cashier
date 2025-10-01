class KiosModel {
  int? idKios;
  String? kios;
  String? keterangan;
  bool? isActive;
  int? totalIncome;
  int? totalExpense;
  int? totalBalance;

  KiosModel(
      {this.idKios,
      this.kios,
      this.keterangan,
      this.isActive,
      this.totalIncome,
      this.totalExpense,
      this.totalBalance});

  KiosModel.fromJson(Map<String, dynamic> json) {
    idKios = json['id_kios'];
    kios = json['kios'];
    keterangan = json['keterangan'];
    isActive = json['is_active'];
    totalIncome = json['total_income'];
    totalExpense = json['total_expense'];
    totalBalance = json['total_balance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id_kios'] = idKios;
    data['kios'] = kios;
    data['keterangan'] = keterangan;
    data['is_active'] = isActive;
    data['total_income'] = totalIncome;
    data['total_expense'] = totalExpense;
    data['total_balance'] = totalBalance;
    return data;
  }
}
