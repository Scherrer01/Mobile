import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(>);
}

class SorteadorPage extends StatefulWidget {
  @override
  _SorteadorPageState createState() => _SorteadorPageState();
}

class _SorteadorPageState extends State<SorteadorPage> {
  // Variável para armazenar o número sorteado
  int numero = 0;
  
  // Função para sortear número
  void sortear() {
    setState(() {
      numero = Random().nextInt(10) + 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sorteador de Números"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Número sorteado:"),
            Text(
              numero == 0 ? "?" : numero.toString(),
              style: TextStyle(fontSize: 50),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: sortear,
              child: Text("SORTEAR"),
            ),
          ],
        ),
      ),
    );
  }
}