import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../model/compra_model.dart';

class ListinService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Adiciona ou atualiza uma lista de compras no Firestore
  Future<void> adicionarListin({
    required CompraModel compra,
  }) async {
    try {
      final String? uid = _auth.currentUser?.uid;
      if (uid == null) {
        throw Exception('Usuário não autenticado.');
      }

      await _firestore.collection("listins").doc(compra.id).set({
        ...compra.toMap(),
        "uid": uid, // Vincula a lista ao usuário
      });
    } catch (e) {
      throw Exception('Erro ao adicionar a lista: $e');
    }
  }

  /// Lê todas as listas de compras associadas ao usuário atual
  Future<List<CompraModel>> lerListins() async {
    try {
      final String? uid = _auth.currentUser?.uid;
      if (uid == null) {
        throw Exception('Usuário não autenticado.');
      }

      final snapshot = await _firestore
          .collection("listins")
          .where("uid", isEqualTo: uid)
          .get();

      return snapshot.docs.map((doc) => CompraModel.fromMap(doc.data())).toList();
    } catch (e) {
      throw Exception('Erro ao carregar as listas: $e');
    }
  }

  /// Remove uma lista de compras e todos os produtos associados
  Future<void> removerListin({required String listinId}) async {
    try {
      // Referência para os produtos dentro da lista
      final produtosRef = _firestore
          .collection("listins")
          .doc(listinId)
          .collection("produtos");

      // Excluir todos os produtos associados à lista
      final produtosSnapshot = await produtosRef.get();
      final batch = _firestore.batch();

      for (final produtoDoc in produtosSnapshot.docs) {
        batch.delete(produtoDoc.reference);
      }

      // Excluir a própria lista de compras
      batch.delete(_firestore.collection("listins").doc(listinId));

      // Executar as operações em batch
      await batch.commit();
    } catch (e) {
      throw Exception('Erro ao remover a lista: $e');
    }
  }
}
