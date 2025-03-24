class FinancialHistoryModel {
  String? status;
  String? message;
  int? income;
  int? expense;
  List<DataHistory>? data;

  FinancialHistoryModel(
      {this.status, this.message, this.income, this.expense, this.data});

  FinancialHistoryModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    income = json['income'];
    expense = json['expense'];
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
    data['income'] = income;
    data['expense'] = expense;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DataHistory {
  int? id;
  int? categoryId;
  String? categoryName;
  String? categoryType;
  String? note;
  int? amount;
  String? transactionDate;

  DataHistory(
      {this.id,
      this.categoryId,
      this.categoryName,
      this.categoryType,
      this.note,
      this.amount,
      this.transactionDate});

  DataHistory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryId = json['category_id'];
    categoryName = json['category_name'];
    categoryType = json['category_type'];
    note = json['note'];
    amount = json['amount'];
    transactionDate = json['transaction_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['category_id'] = categoryId;
    data['category_name'] = categoryName;
    data['category_type'] = categoryType;
    data['note'] = note;
    data['amount'] = amount;
    data['transaction_date'] = transactionDate;
    return data;
  }
}
