class CompraModel {
  String id;
  String name;

  CompraModel({required this.id, required this.name});

  CompraModel.fromMap(Map<String, dynamic> map)
      : id = map["id"],
        name = map["name"];

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
    };
  }
}
