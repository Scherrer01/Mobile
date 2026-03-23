import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: ListaContatos(),
  ));
}

// ----------------Modelo do Contato------------------

class Contato {
  final String nome;
  final String telefone;
  final IconData icone;
  final Color cor;

  Contato({
    required this.nome,
    required this.telefone,
    required this.icone,
    required this.cor,
  });
}

// ----------------Tela 1 - Lista de Contatos------------------

class ListaContatos extends StatelessWidget {
  final List<Contato> contatos = [
    Contato(
      nome: "Ana Silva",
      telefone: "(11) 99999-1234",
      icone: Icons.person,
      cor: Colors.blue,
    ),
    Contato(
      nome: "Carlos Souza",
      telefone: "(11) 98888-5678",
      icone: Icons.person,
      cor: Colors.green,
    ),
    Contato(
      nome: "Mariana Oliveira",
      telefone: "(11) 97777-9012",
      icone: Icons.person,
      cor: Colors.orange,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de Contatos"),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: contatos.length,
        itemBuilder: (context, index) {
          final contato = contatos[index];
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            elevation: 4,
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: contato.cor,
                child: Icon(
                  contato.icone,
                  color: Colors.white,
                ),
              ),
              title: Text(
                contato.nome,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(contato.telefone),
              trailing: Icon(Icons.chevron_right),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetalheContato(
                      nome: contato.nome,
                      telefone: contato.telefone,
                      cor: contato.cor,
                      icone: contato.icone,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

// ----------------Tela 2 - Detalhes do Contato------------------

class DetalheContato extends StatelessWidget {
  final String nome;
  final String telefone;
  final Color cor;
  final IconData icone;

  const DetalheContato({
    super.key,
    required this.nome,
    required this.telefone,
    required this.cor,
    required this.icone,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detalhes do Contato"),
        backgroundColor: cor,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 80,
              backgroundColor: cor,
              child: Icon(
                icone,
                size: 80,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 40),
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.person, color: cor),
                      title: Text(
                        "Nome",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      subtitle: Text(
                        nome,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Divider(),
                    ListTile(
                      leading: Icon(Icons.phone, color: cor),
                      title: Text(
                        "Telefone",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      subtitle: Text(
                        telefone,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: () {
                // Desafio Extra: Mensagem "Ligando para..."
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text("Ligando..."),
                    content: Text("Ligando para $nome ☎️"),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text("OK"),
                      ),
                    ],
                  ),
                );
              },
              icon: Icon(Icons.call),
              label: Text("Ligar"),
              style: ElevatedButton.styleFrom(
                backgroundColor: cor,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}