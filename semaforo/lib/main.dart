import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Semáforo Flutter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const SemaforoPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class SemaforoPage extends StatefulWidget {
  const SemaforoPage({super.key});

  @override
  State<SemaforoPage> createState() => _SemaforoPageState();
}

class _SemaforoPageState extends State<SemaforoPage> {
  // Estados do semáforo
  bool vermelhoAceso = true;
  bool amareloAceso = false;
  bool verdeAceso = false;
  
  // Controle automático
  bool modoAutomatico = false;
  late int tempoRestante;
  late String statusAtual;
  
  @override
  void initState() {
    super.initState();
    tempoRestante = 10;
    statusAtual = 'PARE';
  }
  
  void mudarVermelho() {
    setState(() {
      vermelhoAceso = true;
      amareloAceso = false;
      verdeAceso = false;
      statusAtual = 'PARE';
      tempoRestante = 10;
    });
  }
  
  void mudarAmarelo() {
    setState(() {
      vermelhoAceso = false;
      amareloAceso = true;
      verdeAceso = false;
      statusAtual = 'ATENÇÃO';
      tempoRestante = 3;
    });
  }
  
  void mudarVerde() {
    setState(() {
      vermelhoAceso = false;
      amareloAceso = false;
      verdeAceso = true;
      statusAtual = 'SIGA';
      tempoRestante = 15;
    });
  }
  
  void alternarModoAutomatico() {
    setState(() {
      modoAutomatico = !modoAutomatico;
    });
    
    if (modoAutomatico) {
      iniciarCicloAutomatico();
    }
  }
  
  void iniciarCicloAutomatico() async {
    while (modoAutomatico) {
      // Vermelho
      mudarVermelho();
      for (int i = tempoRestante; i > 0 && modoAutomatico; i--) {
        await Future.delayed(const Duration(seconds: 1));
        if (mounted && modoAutomatico) {
          setState(() {
            tempoRestante = i - 1;
          });
        }
      }
      
      if (!modoAutomatico) break;
      
      // Amarelo
      mudarAmarelo();
      for (int i = tempoRestante; i > 0 && modoAutomatico; i--) {
        await Future.delayed(const Duration(seconds: 1));
        if (mounted && modoAutomatico) {
          setState(() {
            tempoRestante = i - 1;
          });
        }
      }
      
      if (!modoAutomatico) break;
      
      // Verde
      mudarVerde();
      for (int i = tempoRestante; i > 0 && modoAutomatico; i--) {
        await Future.delayed(const Duration(seconds: 1));
        if (mounted && modoAutomatico) {
          setState(() {
            tempoRestante = i - 1;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Semáforo'),
        centerTitle: true,
        backgroundColor: Colors.grey[900],
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.grey[900]!, Colors.grey[800]!],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Estrutura do semáforo
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.grey[850],
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Luz Vermelha
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: vermelhoAceso 
                            ? Colors.red 
                            : Colors.red.withOpacity(0.3),
                        boxShadow: vermelhoAceso
                            ? [
                                BoxShadow(
                                  color: Colors.red.withOpacity(0.8),
                                  blurRadius: 20,
                                  spreadRadius: 5,
                                )
                              ]
                            : [],
                        border: Border.all(
                          color: Colors.grey[600]!,
                          width: 3,
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    
                    // Luz Amarela
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: amareloAceso 
                            ? Colors.yellow 
                            : Colors.yellow.withOpacity(0.3),
                        boxShadow: amareloAceso
                            ? [
                                BoxShadow(
                                  color: Colors.yellow.withOpacity(0.8),
                                  blurRadius: 20,
                                  spreadRadius: 5,
                                )
                              ]
                            : [],
                        border: Border.all(
                          color: Colors.grey[600]!,
                          width: 3,
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    
                    // Luz Verde
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: verdeAceso 
                            ? Colors.green 
                            : Colors.green.withOpacity(0.3),
                        boxShadow: verdeAceso
                            ? [
                                BoxShadow(
                                  color: Colors.green.withOpacity(0.8),
                                  blurRadius: 20,
                                  spreadRadius: 5,
                                )
                              ]
                            : [],
                        border: Border.all(
                          color: Colors.grey[600]!,
                          width: 3,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 30),
              
              // Status do semáforo
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 15,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey[850],
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.grey[700]!),
                ),
                child: Column(
                  children: [
                    Text(
                      statusAtual,
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: vermelhoAceso
                            ? Colors.red
                            : amareloAceso
                                ? Colors.yellow
                                : Colors.green,
                      ),
                    ),
                    if (modoAutomatico)
                      Text(
                        'Próxima mudança em: $tempoRestante s',
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white70,
                        ),
                      ),
                  ],
                ),
              ),
              
              const SizedBox(height: 30),
              
              // Controles
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  ElevatedButton(
                    onPressed: modoAutomatico ? null : mudarVermelho,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 15,
                      ),
                    ),
                    child: const Text('Vermelho'),
                  ),
                  ElevatedButton(
                    onPressed: modoAutomatico ? null : mudarAmarelo,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.yellow,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 15,
                      ),
                    ),
                    child: const Text('Amarelo'),
                  ),
                  ElevatedButton(
                    onPressed: modoAutomatico ? null : mudarVerde,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 15,
                      ),
                    ),
                    child: const Text('Verde'),
                  ),
                  ElevatedButton(
                    onPressed: alternarModoAutomatico,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: modoAutomatico ? Colors.orange : Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 15,
                      ),
                    ),
                    child: Text(
                      modoAutomatico ? 'Modo Manual' : 'Modo Automático',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}