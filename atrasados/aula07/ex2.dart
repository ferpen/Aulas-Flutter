import 'package:flutter/material.dart';
import 'dart:math'; 

void main() {
  runApp(const MaterialApp(title: 'Cálculos do Círculo', home: CircleCalculator()));
}

class CircleCalculator extends StatefulWidget {
  const CircleCalculator({super.key});

  @override
  _CircleCalculatorState createState() => _CircleCalculatorState();
}

class _CircleCalculatorState extends State<CircleCalculator> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController raioController = TextEditingController();
  double? raio;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cálculos do Círculo'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold),
          tabs: const [
            Tab(text: 'Raio'),
            Tab(text: 'Diâmetro'),
            Tab(text: 'Circunferência'),
            Tab(text: 'Área'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: raioController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Digite o Raio',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      raio = double.tryParse(raioController.text);
                    });
                    if (raio == null || raio! <= 0) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Por favor, insira um valor válido!')),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('Definir Raio', style: TextStyle(fontSize: 18)),
                ),
              ],
            ),
          ),
          _buildResultTab('Diâmetro', raio != null ? 'Diâmetro: ${2 * raio!}' : 'Informe o raio na aba Raio', context),
          _buildResultTab('Circunferência', raio != null ? 'Circunferência: ${2 * pi * raio!}' : 'Informe o raio na aba Raio', context),
          _buildResultTab('Área', raio != null ? 'Área: ${pi * raio! * raio!}' : 'Informe o raio na aba Raio', context),
        ],
      ),
    );
  }
}

Widget _buildResultTab(String title, String resultText, BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(24.0),
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.teal.shade800),
          ),
          const SizedBox(height: 20),
          Text(
            resultText,
            style: TextStyle(
              fontSize: 24, 
              fontWeight: FontWeight.w600, 
              color: resultText.startsWith('Informe') ? Colors.redAccent : Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  );
}