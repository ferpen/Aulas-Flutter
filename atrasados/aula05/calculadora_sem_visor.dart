import 'package:flutter/material.dart';

void main() {
  runApp(const CalculadoraApp());
}

class CalculadoraApp extends StatelessWidget {
  const CalculadoraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        scaffoldBackgroundColor: Colors.indigo.shade50,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.indigo,
          elevation: 4,
          titleTextStyle: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      home: CalculadoraPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class CalculadoraPage extends StatefulWidget {
  @override
  _CalculadoraPageState createState() => _CalculadoraPageState();
}

class _CalculadoraPageState extends State<CalculadoraPage> {
  int? operador1;
  int? operador2;
  bool somaApertado = false;
  int? resultado;

  void _pressionar(String valor) {
    setState(() {
      if (valor == "+") {
        somaApertado = true;
      } else if (valor == "=") {
        if (operador1 != null && operador2 != null) {
          resultado = operador1! + operador2!;
        }

        print("Operador 1: $operador1");
        print("Operador 2: $operador2");
        print("Soma apertado: $somaApertado");
        print("Resultado: $resultado");
        print("------------------");

        operador1 = null;
        operador2 = null;
        somaApertado = false;
        resultado = null;
      } else {
        int numero = int.parse(valor);

        if (!somaApertado) {
          operador1 =
              (operador1 == null) ? numero : int.parse("$operador1$numero");
        } else {
          operador2 =
              (operador2 == null) ? numero : int.parse("$operador2$numero");
        }
      }

      print("Operador 1: $operador1");
      print("Operador 2: $operador2");
      print("Soma apertado: $somaApertado");
      print("Resultado: $resultado");
      print("------------------");
    });
  }
  
  Color _getButtonColor(String text) {
    if (text == "+" || text == "=") {
      return Colors.indigo.shade800;
    }
    return Colors.indigo.shade400;
  }

  Widget _buildButton(String text) {
    return ElevatedButton(
      onPressed: () => _pressionar(text),
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: _getButtonColor(text),
        minimumSize: const Size(80, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        elevation: 3,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      ),
      child: Text(text, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Calculadora Simples")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [_buildButton("7"), _buildButton("8"), _buildButton("9")],
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [_buildButton("4"), _buildButton("5"), _buildButton("6")],
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [_buildButton("1"), _buildButton("2"), _buildButton("3")],
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [_buildButton("0"), _buildButton("="), _buildButton("+")],
          ),
        ],
      ),
    );
  }
}