import 'package:flutter/material.dart';
import 'dart:math'; 

void main() {
  runApp(const MaterialApp(title: 'Cálculo da Área do Círculo', home: FirstRoute()));
}

class FirstRoute extends StatelessWidget {
  const FirstRoute({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController raioController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Raio'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: raioController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Digite o Raio do Círculo',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                double? raio = double.tryParse(raioController.text);
                if (raio != null && raio > 0) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SecondRoute(raio: raio),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Por favor, insira um valor válido e positivo!')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Calcular Área', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}

class SecondRoute extends StatelessWidget {
  final double raio;

  const SecondRoute({super.key, required this.raio});

  @override
  Widget build(BuildContext context) {
    
    double area = pi * raio * raio;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Resultado'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.circle, size: 80, color: Colors.teal),
            const SizedBox(height: 30),
            Text(
              'Raio: ${raio.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            Text(
              'Área do Círculo:',
              style: TextStyle(fontSize: 22, color: Colors.grey.shade600),
            ),
            Text(
              '${area.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.teal),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); 
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey.shade400,
                foregroundColor: Colors.black87,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Voltar', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}