class Produto {
  String id;
  String name;
  double? price;
  double? amount;
  bool isComprado;
  String? uid;

  Produto({
    required this.id,
    required this.name,
    required this.isComprado,
    this.price,
    this.amount,
    this.uid,
  });

  Produto.fromMap(Map<String, dynamic> map)
      : id = map["id"],
        name = map["name"],
        isComprado = map["isComprado"],
        price = map["price"],
        amount = map["amount"],
        uid = map["uid"];

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "isComprado": isComprado,
      "price": price,
      "amount": amount,
      "uid": uid,
    };
  }
}
