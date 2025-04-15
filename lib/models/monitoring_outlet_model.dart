class MonitoringOutletModel {
  String? status;
  String? message;
  int? income;
  int? expense;
  List<DataTransaction>? data;

  MonitoringOutletModel(
      {this.status, this.message, this.income, this.expense, this.data});

  MonitoringOutletModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    income = json['income'];
    expense = json['expense'];
    if (json['data'] != null) {
      data = <DataTransaction>[];
      json['data'].forEach((v) {
        data!.add(DataTransaction.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    data['income'] = income;
    data['expense'] = expense;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DataTransaction {
  int? id;
  int? numerator;
  String? transactionDate;
  String? kios;
  int? grandTotal;
  bool? deleteStatus;
  int? discount;
  int? total;
  List<DataTransactionDetails>? details;

  DataTransaction(
      {this.id,
      this.numerator,
      this.transactionDate,
      this.kios,
      this.grandTotal,
      this.deleteStatus,
      this.discount,
      this.total,
      this.details});

  DataTransaction.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    numerator = json['numerator'];
    transactionDate = json['transaction_date'];
    kios = json['kios'];
    grandTotal = json['grand_total'];
    deleteStatus = json['delete_status'];
    discount = json['discount'];
    total = json['total'];
    if (json['details'] != null) {
      details = <DataTransactionDetails>[];
      json['details'].forEach((v) {
        details!.add(DataTransactionDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['numerator'] = numerator;
    data['transaction_date'] = transactionDate;
    data['kios'] = kios;
    data['grand_total'] = grandTotal;
    data['delete_status'] = deleteStatus;
    data['discount'] = discount;
    data['total'] = total;
    if (details != null) {
      data['details'] = details!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DataTransactionDetails {
  String? productName;
  int? quantity;
  int? unitPrice;
  int? totalPrice;

  DataTransactionDetails(
      {this.productName, this.quantity, this.unitPrice, this.totalPrice});

  DataTransactionDetails.fromJson(Map<String, dynamic> json) {
    productName = json['product_name'];
    quantity = json['quantity'];
    unitPrice = json['unit_price'];
    totalPrice = json['total_price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['product_name'] = productName;
    data['quantity'] = quantity;
    data['unit_price'] = unitPrice;
    data['total_price'] = totalPrice;
    return data;
  }
}
