import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:app_lista_compras/lista_compra/model/compra_model.dart';

class ListinService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> adicionarListin({required CompraModel compra}) async {
    return firestore.collection("listins").doc(compra.id).set(compra.toMap());
  }

  Future<List<CompraModel>> lerListins() async {
    List<CompraModel> temp = [];

    QuerySnapshot<Map<String, dynamic>> snapshot =
        await firestore.collection("listins").get();

    for (var doc in snapshot.docs) {
      temp.add(CompraModel.fromMap(doc.data()));
    }

    return temp;
  }

  Future<void> removerListin({required String listinId}) async {
    // Obtém a referência da coleção de produtos vinculada à lista
    final CollectionReference produtosRef = firestore
        .collection('listins')
        .doc(listinId)
        .collection('produtos');

    try {
      // Obtém todos os produtos vinculados à lista
      final QuerySnapshot produtosSnapshot = await produtosRef.get();

      // Itera sobre cada produto e o exclui
      for (final produtoDoc in produtosSnapshot.docs) {
        await produtoDoc.reference.delete();
      }

      // Após excluir todos os produtos, exclui a lista
      await firestore.collection('listins').doc(listinId).delete();
    } catch (e) {
      throw Exception('Erro ao excluir a lista e os produtos vinculados: $e');
    }
  }
}
