class CompraModel {
  String id;
  String name;
  String? uid; // Vincula ao usuário

  CompraModel({required this.id, required this.name, this.uid});

  CompraModel.fromMap(Map<String, dynamic> map)
      : id = map["id"],
        name = map["name"],
        uid = map["uid"];

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "uid": uid,
    };
  }
}
