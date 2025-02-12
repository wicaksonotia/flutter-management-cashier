class TransactionModel {
  final int id;
  final String type;
  final String categoryName;
  final int transactionDate;
  final int amount;

  TransactionModel({
    required this.id,
    required this.type,
    required this.categoryName,
    required this.transactionDate,
    required this.amount,
  });

  Map<String, dynamic> toMapInsert() {
    return {
      'type': type,
      'category_name': categoryName,
      'transaction_date': transactionDate,
      'amount': amount,
    };
  }

  Map<String, dynamic> toMapUpdate() {
    return {
      'id': id,
      'type': type,
      'category_name': categoryName,
      'transaction_date': transactionDate,
      'amount': amount,
    };
  }

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      id: map['id'],
      type: map['type'],
      categoryName: map['category_name'],
      transactionDate: map['transaction_date'],
      amount: map['amount'],
    );
  }
}
