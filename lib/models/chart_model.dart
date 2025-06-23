class ChartModel {
  String? status;
  String? message;
  List<DataListChart>? data;

  ChartModel({this.status, this.message, this.data});

  ChartModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <DataListChart>[];
      json['data'].forEach((v) {
        data!.add(DataListChart.fromJson(v));
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

class DataListChart {
  int? month;
  int? income;
  int? expense;

  DataListChart({this.month, this.income, this.expense});

  DataListChart.fromJson(Map<String, dynamic> json) {
    month = json['month'];
    income = json['income'];
    expense = json['expense'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['month'] = month;
    data['income'] = income;
    data['expense'] = expense;
    return data;
  }
}
