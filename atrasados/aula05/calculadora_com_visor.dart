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
        brightness: Brightness.dark,
        primarySwatch: Colors.blueGrey,
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blueGrey,
          elevation: 0,
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
  bool novoCalculo = false;

  void _pressionar(String valor) {
    setState(() {
      if (valor == "+") {
        somaApertado = true;
      } else if (valor == "=") {
        if (operador1 != null && operador2 != null) {
          resultado = operador1! + operador2!;
          novoCalculo = true;
        }

        print("Operador 1: $operador1");
        print("Operador 2: $operador2");
        print("Soma apertado: $somaApertado");
        print("Resultado: $resultado");
        print("------------------");

        operador1 = null;
        operador2 = null;
        somaApertado = false;
      } else {
        int numero = int.parse(valor);

        if (novoCalculo) {
          resultado = null;
          novoCalculo = false;
        }

        if (!somaApertado) {
          operador1 =
              (operador1 == null) ? numero : int.parse("$operador1$numero");
        } else {
          operador2 =
              (operador2 == null) ? numero : int.parse("$operador2$numero");
        }
      }
    });
  }

  Color _getButtonColor(String text) {
    if (text == "=" || text == "+") {
      return Colors.blueGrey.shade700;
    }
    return Colors.blueGrey.shade900;
  }

  Widget _buildButton(String text) {
    return ElevatedButton(
      onPressed: () => _pressionar(text),
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: _getButtonColor(text),
        minimumSize: const Size(70, 70),
        shape: const CircleBorder(),
        elevation: 5,
        padding: const EdgeInsets.all(18),
      ),
      child: Text(text, style: const TextStyle(fontSize: 26)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Calculadora Dark"),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            alignment: Alignment.centerRight,
            color: Colors.black,
            child: Text(
              resultado?.toString() ??
                  (somaApertado
                      ? (operador2?.toString() ?? operador1?.toString() ?? "0")
                      : (operador1?.toString() ?? "0")),
              style: const TextStyle(
                fontSize: 64,
                fontWeight: FontWeight.w300,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 20),
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
            children: [
              SizedBox(
                width: 70, 
                height: 70,
                child: _buildButton("0"),
              ),
              _buildButton("="),
              _buildButton("+"),
            ],
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}