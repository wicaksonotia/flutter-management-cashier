class FinancialHistoryModel {
  String? status;
  String? message;
  List<DataHistory>? data;

  FinancialHistoryModel({this.status, this.message, this.data});

  FinancialHistoryModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <DataHistory>[];
      json['data'].forEach((v) {
        data!.add(DataHistory.fromJson(v));
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

class DataHistory {
  int? id;
  String? note;
  int? amount;
  String? transactionDate;
  String? transactionType;
  bool? deleteStatus;
  String? deleteReason;
  int? transactionCategoryId;
  String? transactionName;
  int? idKios;
  String? kios;
  int? idCabang;
  String? cabang;
  int? idKasir;
  String? namaKasir;

  DataHistory(
      {this.id,
      this.note,
      this.amount,
      this.transactionDate,
      this.transactionType,
      this.deleteStatus,
      this.deleteReason,
      this.transactionCategoryId,
      this.transactionName,
      this.idKios,
      this.kios,
      this.idCabang,
      this.cabang,
      this.idKasir,
      this.namaKasir});

  DataHistory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    note = json['note'];
    amount = json['amount'];
    transactionDate = json['transaction_date'];
    transactionType = json['transaction_type'];
    deleteStatus = json['delete_status'];
    deleteReason = json['delete_reason'];
    transactionCategoryId = json['transaction_category_id'];
    transactionName = json['transaction_name'];
    idKios = json['id_kios'];
    kios = json['kios'];
    idCabang = json['id_cabang'];
    cabang = json['cabang'];
    idKasir = json['id_kasir'];
    namaKasir = json['nama_kasir'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['note'] = note;
    data['amount'] = amount;
    data['transaction_date'] = transactionDate;
    data['transaction_type'] = transactionType;
    data['delete_status'] = deleteStatus;
    data['delete_reason'] = deleteReason;
    data['transaction_category_id'] = transactionCategoryId;
    data['transaction_name'] = transactionName;
    data['id_kios'] = idKios;
    data['kios'] = kios;
    data['id_cabang'] = idCabang;
    data['cabang'] = cabang;
    data['id_kasir'] = idKasir;
    data['nama_kasir'] = namaKasir;
    return data;
  }
}
