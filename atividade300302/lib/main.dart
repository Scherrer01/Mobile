import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: ListaCompras(),
  ));
}

class ListaCompras extends StatefulWidget {
  @override
  _ListaComprasState createState() => _ListaComprasState();
}

class _ListaComprasState extends State<ListaCompras> {
  List<String> itens = [];
  List<bool> comprado = [];
  TextEditingController controller = TextEditingController();

  void adicionarItem() {
    if (controller.text.isNotEmpty) {
      setState(() {
        itens.add(controller.text);
        comprado.add(false);
        controller.clear();
      });
      salvarDados();
    }
  }
                                            
  void alternarComprado(int index) {
    setState(() {
      comprado[index] = !comprado[index];
    });
    salvarDados();
  }

  void removerItem(int index) {
    setState(() {
      itens.removeAt(index);
      comprado.removeAt(index);
    });
    salvarDados();
  }

  void limparLista() {
    setState(() {
      itens.clear();
      comprado.clear();
    });
    salvarDados();
  }

  void salvarDados() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList("itens", itens);
    prefs.setStringList(
      "comprado",
      comprado.map((e) => e.toString()).toList(),
    );
  }

  void carregarDados() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      itens = prefs.getStringList("itens") ?? [];
      List<String> listaBool = prefs.getStringList("comprado") ?? [];
      comprado = listaBool.map((e) => e == "true").toList();
    });
  }

  int get quantidadeComprados {
    return comprado.where((e) => e == true).length;
  }

  @override
  void initState() {
    super.initState();
    carregarDados();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de Compras"),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            icon: Icon(Icons.delete_sweep),
            onPressed: limparLista,
            tooltip: "Limpar lista",
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: InputDecoration(
                      labelText: "Digite um item",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: adicionarItem,
                  child: Text("Adicionar"),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Total: ${itens.length} itens",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  "Comprados: $quantidadeComprados",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ),
          Divider(),
          Expanded(
            child: itens.isEmpty
                ? Center(
                    child: Text(
                      "Nenhum item na lista",
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    itemCount: itens.length,
                    itemBuilder: (context, index) {
                      return Card(
                        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        color: comprado[index] ? Colors.green[50] : Colors.white,
                        child: ListTile(
                          leading: Checkbox(
                            value: comprado[index],
                            onChanged: (value) => alternarComprado(index),
                            activeColor: Colors.green,
                          ),
                          title: Text(
                            itens[index],
                            style: TextStyle(
                              fontSize: 16,
                              decoration: comprado[index]
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                              color: comprado[index] ? Colors.grey : Colors.black,
                            ),
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () => removerItem(index),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: itens.isNotEmpty && quantidadeComprados == itens.length
          ? FloatingActionButton.extended(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Parabéns! Todos os itens foram comprados! 🎉"),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              icon: Icon(Icons.celebration),
              label: Text("Lista Completa!"),
              backgroundColor: Colors.green,
            )
          : null,
    );
  }
}