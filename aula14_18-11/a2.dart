import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DictionaryPage(),
    );
  }
}

class DictionaryPage extends StatefulWidget {
  @override
  State<DictionaryPage> createState() => _DictionaryPageState();
}

class _DictionaryPageState extends State<DictionaryPage> {
  final TextEditingController _controller = TextEditingController();
  String? definition;
  String? error;

  Future<void> _searchDefinition() async {
    setState(() {
      definition = null;
      error = null;
    });

    final word = _controller.text.trim();
    if (word.isEmpty) {
      setState(() => error = "Digite uma palavra em inglês.");
      return;
    }

    final url = "https://api.dictionaryapi.dev/api/v2/entries/en/$word";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      try {
        final firstDefinition =
            data[0]["meanings"][0]["definitions"][0]["definition"];

        setState(() {
          definition = firstDefinition;
        });
      } catch (e) {
        setState(() => error = "Nenhuma definição encontrada.");
      }
    } else {
      setState(() => error = "Palavra não encontrada.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dicionário de Inglês"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: "Digite uma palavra",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: _searchDefinition,
              child: const Text("Buscar definição"),
            ),

            const SizedBox(height: 30),

            if (error != null)
              Text(
                error!,
                style: const TextStyle(color: Colors.red, fontSize: 18),
              ),

            if (definition != null)
              Text(
                "Definição:\n$definition",
                style: const TextStyle(fontSize: 20),
              ),
          ],
        ),
      ),
    );
  }
}
