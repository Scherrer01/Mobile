import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: JogoApp(),
  ));
}

class JogoApp extends StatefulWidget {
  @override
  _JogoAppState createState() => _JogoAppState();
}

class _JogoAppState extends State<JogoApp> {
  IconData iconeComputador = Icons.computer;
  String resultado = "Escolha uma opção";
  int pontosJogador = 0;
  int pontosComputador = 0;
  List opcoes = ["pedra","papel","tesoura"];

  void jogar(String escolhaUsuario){
    var numero = Random().nextInt(3);
    var escolhaComputador = opcoes[numero];
    
    setState(() {
      // Mostrar escolha do computador
      if(escolhaComputador == "pedra"){
        iconeComputador = Icons.landscape;
      }
      if(escolhaComputador == "papel"){
        iconeComputador = Icons.pan_tool;
      }
      if(escolhaComputador == "tesoura"){
        iconeComputador = Icons.content_cut;
      }
      
      // Lógica do jogo
      if(escolhaUsuario == escolhaComputador){
        resultado = "Empate";
      }
      else if(
        (escolhaUsuario == "pedra" && escolhaComputador == "tesoura") ||
        (escolhaUsuario == "papel" && escolhaComputador == "pedra") ||
        (escolhaUsuario == "tesoura" && escolhaComputador == "papel")
      ){
        pontosJogador++;
        resultado = "Você venceu!";
        
        // Verifica se jogador ganhou o campeonato
        if(pontosJogador >= 5){
          resultado = "🏆 Você ganhou o campeonato! 🏆";
          pontosJogador = 0;
          pontosComputador = 0;
        }
      }
      else{
        pontosComputador++;
        resultado = "Computador venceu!";
        
        // Verifica se computador ganhou o campeonato
        if(pontosComputador >= 5){
          resultado = "💻 Computador ganhou o campeonato! 💻";
          pontosJogador = 0;
          pontosComputador = 0;
        }
      }
    });
  }

  void resetarPlacar(){
    setState(() {
      pontosJogador = 0;
      pontosComputador = 0;
      resultado = "Placar resetado!";
      iconeComputador = Icons.computer;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pedra Papel Tesoura"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Computador",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Icon(
              iconeComputador,
              size: 100,
              color: Colors.blue,
            ),
            SizedBox(height: 20),
            Text(
              resultado,
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              "Você: $pontosJogador  |  PC: $pontosComputador",
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 30),
            Text(
              "Escolha sua jogada:",
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Pedra
                Column(
                  children: [
                    IconButton(
                      icon: Icon(Icons.landscape, size: 50),
                      color: Colors.grey,
                      onPressed: () => jogar("pedra"),
                    ),
                    Text("Pedra"),
                  ],
                ),
                SizedBox(width: 20),
                // Papel
                Column(
                  children: [
                    IconButton(
                      icon: Icon(Icons.pan_tool, size: 50),
                      color: Colors.brown,
                      onPressed: () => jogar("papel"),
                    ),
                    Text("Papel"),
                  ],
                ),
                SizedBox(width: 20),
                // Tesoura
                Column(
                  children: [
                    IconButton(
                      icon: Icon(Icons.content_cut, size: 50),
                      color: Colors.red,
                      onPressed: () => jogar("tesoura"),
                    ),
                    Text("Tesoura"),
                  ],
                ),
              ],
            ),
            SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: resetarPlacar,
              icon: Icon(Icons.refresh),
              label: Text("Resetar Placar"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}