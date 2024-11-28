import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/produto_model.dart';
import '../util/enum.dart';

class ProdutoService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Adiciona ou atualiza um produto em uma lista específica
  Future<void> adicionarProduto({
    required String listinId,
    required Produto produto,
  }) async {
    try {
      await _firestore
          .collection("listins")
          .doc(listinId)
          .collection("produtos")
          .doc(produto.id)
          .set(produto.toMap());
    } catch (e) {
      throw Exception('Erro ao adicionar o produto: $e');
    }
  }

  /// Lê todos os produtos de uma lista para o usuário atual
  Future<List<Produto>> lerProdutos({
  required String listinId,
  required OrdemProduto ordem,
  required bool isDecrescente,
}) async {
  List<Produto> temp = [];

  QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
      .collection("listins")
      .doc(listinId)
      .collection("produtos")
      .orderBy(ordem.name, descending: isDecrescente)
      .get();

  for (var doc in snapshot.docs) {
    Produto produto = Produto.fromMap(doc.data());
    temp.add(produto);
  }

  return temp;
}

  /// Alterna o status "comprado" de um produto
  Future<void> alternarComprado({
    required Produto produto,
    required String listinId,
  }) async {
    try {
      produto.isComprado = !produto.isComprado;
      await _firestore
          .collection("listins")
          .doc(listinId)
          .collection("produtos")
          .doc(produto.id)
          .update({"isComprado": produto.isComprado});
    } catch (e) {
      throw Exception('Erro ao alternar status do produto: $e');
    }
  }

  /// Remove um produto de uma lista específica
  Future<void> removerProduto({
    required String listinId,
    required Produto produto,
  }) async {
    try {
      await _firestore
          .collection("listins")
          .doc(listinId)
          .collection("produtos")
          .doc(produto.id)
          .delete();
    } catch (e) {
      throw Exception('Erro ao remover o produto: $e');
    }
  }

  /// Conecta um stream à coleção de produtos para escutar alterações em tempo real
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>> conectarStream({
    required String listinId,
    required OrdemProduto ordem,
    required bool isDecrescente,
    required void Function(QuerySnapshot<Map<String, dynamic>> snapshot) onChange,
  }) {
    return _firestore
        .collection("listins")
        .doc(listinId)
        .collection("produtos")
        .orderBy(ordem.name, descending: isDecrescente)
        .snapshots()
        .listen(onChange);
  }
}
