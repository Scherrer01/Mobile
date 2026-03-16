import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sensor de Temperatura',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const TemperaturaPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class TemperaturaPage extends StatefulWidget {
  const TemperaturaPage({super.key});

  @override
  State<TemperaturaPage> createState() => _TemperaturaPageState();
}

class _TemperaturaPageState extends State<TemperaturaPage> {
  double temperatura = 25.0;

  Color getCorTemperatura() {
    if (temperatura >= 30) return Colors.red;
    if (temperatura <= 15) return Colors.blue;
    return Colors.green;
  }

  String getMensagem() {
    if (temperatura >= 30) return "Muito quente! 🥵";
    if (temperatura <= 15) return "Muito frio! 🥶";
    return "Temperatura agradável 😊";
  }

  void aumentar() {
    setState(() {
      temperatura += 1;
    });
  }

  void diminuir() {
    setState(() {
      temperatura -= 1;
    });
  }

  void resetar() {
    setState(() {
      temperatura = 25.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sensor de Temperatura'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Display da temperatura
              Container(
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: getCorTemperatura().withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: getCorTemperatura(), width: 3),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.thermostat,
                      size: 80,
                      color: getCorTemperatura(),
                    ),
                    Text(
                      '${temperatura.toStringAsFixed(0)}°C',
                      style: TextStyle(
                        fontSize: 60,
                        fontWeight: FontWeight.bold,
                        color: getCorTemperatura(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      getMensagem(),
                      style: TextStyle(
                        fontSize: 20,
                        color: getCorTemperatura(),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 40),
              
              // Botões de controle
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: diminuir,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(20),
                    ),
                    child: const Icon(Icons.remove, size: 30, color: Colors.white),
                  ),
                  ElevatedButton(
                    onPressed: resetar,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(20),
                    ),
                    child: const Icon(Icons.refresh, size: 30, color: Colors.white),
                  ),
                  ElevatedButton(
                    onPressed: aumentar,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(20),
                    ),
                    child: const Icon(Icons.add, size: 30, color: Colors.white),
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