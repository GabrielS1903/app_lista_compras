import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:app_lista_compras/lista_compra/service/compra_service.dart';
import 'package:app_lista_compras/lista_produto/screen/produto_screen.dart';
import 'package:uuid/uuid.dart';
import '../model/compra_model.dart';

class CompraScreen extends StatefulWidget {
  const CompraScreen({super.key});

  @override
  State<CompraScreen> createState() => _CompraScreenState();
}

class _CompraScreenState extends State<CompraScreen> {
  List<CompraModel> listListins = [];
  ListinService listinService = ListinService();

  @override
  void initState() {
    refresh();
    super.initState();
  }

  void logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacementNamed(context, '/login');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Erro ao fazer logout: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lista de Compras"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => logout(context),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showFormModal();
        },
        child: const Icon(Icons.add),
      ),
      body: (listListins.isEmpty)
          ? const Center(
              child: Text(
                "Nenhuma lista encontrada.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
            )
          : RefreshIndicator(
              onRefresh: () {
                return refresh();
              },
              child: ListView(
                children: List.generate(
                  listListins.length,
                  (index) {
                    CompraModel model = listListins[index];
                    return Dismissible(
                      key: ValueKey<CompraModel>(model),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 8.0),
                        child: const Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                      ),
                      onDismissed: (direction) {
                        remove(model);
                      },
                      child: ListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ProdutoScreen(listin: model),
                            ),
                          );
                        },
                        onLongPress: () {
                          showFormModal(model: model);
                        },
                        leading: const Icon(Icons.list_alt_rounded),
                        title: Text(model.name),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            confirmDelete(model);
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
    );
  }

  void confirmDelete(CompraModel model) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Excluir Lista"),
        content: Text(
            "Tem certeza que deseja excluir a lista '${model.name}' e todos os produtos vinculados a ela?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar"),
          ),
          ElevatedButton(
            onPressed: () async {
              await listinService.removerListin(listinId: model.id);
              Navigator.pop(context); // Fecha o diálogo
              refresh(); // Atualiza a lista
            },
            child: const Text("Excluir"),
          ),
        ],
      ),
    );
  }

  showFormModal({CompraModel? model}) {
    String labelTitle = "Adicionar Lista";
    String labelConfirmationButton = "Salvar";
    String labelSkipButton = "Cancelar";

    TextEditingController nameController = TextEditingController();

    if (model != null) {
      labelTitle = "Editando ${model.name}";
      nameController.text = model.name;
    }

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.all(32.0),
          child: ListView(
            children: [
              Text(labelTitle, style: Theme.of(context).textTheme.headlineMedium),
              TextFormField(
                controller: nameController,
                decoration:
                    const InputDecoration(label: Text("Nome da Lista de Compras")),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(labelSkipButton),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () {
                      CompraModel compra = CompraModel(
                        id: const Uuid().v1(),
                        name: nameController.text,
                      );

                      if (model != null) {
                        compra.id = model.id;
                      }

                      listinService.adicionarListin(compra: compra);

                      refresh();

                      Navigator.pop(context);
                    },
                    child: Text(labelConfirmationButton),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  refresh() async {
    List<CompraModel> listaListins = await listinService.lerListins();
    setState(() {
      listListins = listaListins;
    });
  }

  void remove(CompraModel model) async {
    await listinService.removerListin(listinId: model.id);
    refresh();
  }
}
