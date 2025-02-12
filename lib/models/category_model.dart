class CategoryModel {
  final int id;
  final String name;
  final String type;

  CategoryModel({
    required this.id,
    required this.name,
    required this.type,
  });

  Map<String, dynamic> toMapInsert() {
    return {
      'name': name,
      'type': type,
    };
  }

  Map<String, dynamic> toMapUpdate() {
    return {
      'id': id,
      'name': name,
      'type': type,
    };
  }

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      id: map['id'],
      name: map['name'],
      type: map['type'],
    );
  }
}
