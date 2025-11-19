import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: CardGamePage());
  }
}

class CardGamePage extends StatefulWidget {
  @override
  State<CardGamePage> createState() => _CardGamePageState();
}

class _CardGamePageState extends State<CardGamePage> {
  Map<String, dynamic>? cardPlayer;
  Map<String, dynamic>? cardEnemy;

  String? chosenAttribute;
  String result = "";

  int playerWins = 0;
  int enemyWins = 0;

  final attributes = ["ki", "maxKi"];
  final random = Random();

  /// Converte o valor do atributo para double, tratando sufixos como "Million" ou "Googolplex"
  double parsePowerValue(String? value) {
    if (value == null || value.isEmpty) return 0;

    value = value.trim();
    List<String> parts = value.split(' ');

    if (parts.length == 1) {
      String numberOnly = parts[0].replaceAll('.', '');
      return double.tryParse(numberOnly) ?? 0;
    }

    String numberPart = parts[0].replaceAll('.', '').replaceAll(',', '.');
    double number = double.tryParse(numberPart) ?? 0;
    String suffix = parts.sublist(1).join(' ');

    const Map<String, double> suffixMultipliers = {
      "Thousand": 1e3,
      "Million": 1e6,
      "Billion": 1e9,
      "Trillion": 1e12,
      "Quadrillion": 1e15,
      "Quintillion": 1e18,
      "Sextillion": 1e21,
      "Septillion": 1e24,
      "Octillion": 1e27,
      "Nonillion": 1e30,
      "Decillion": 1e33,
      "Googol": 1e100,
    };

    if (suffix.toLowerCase() == "googolplex") return double.infinity;

    double multiplier = suffixMultipliers.entries
        .firstWhere(
          (e) => e.key.toLowerCase() == suffix.toLowerCase(),
          orElse: () => const MapEntry("", 1),
        )
        .value;

    return number * multiplier;
  }

  double parseNumber(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value.toDouble();
    if (value is String) return parsePowerValue(value);
    return 0;
  }

  /// Busca um personagem aleatório com imagem
  Future<Map<String, dynamic>> fetchRandomCard() async {
    while (true) {
      int randomId = random.nextInt(58) + 1;
      final url = "https://dragonball-api.com/api/characters/$randomId";
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final Map<String, dynamic> card = jsonDecode(response.body);
        if (card["image"] != null && card["image"].toString().isNotEmpty) {
          return card;
        }
      }
    }
  }

  Future<void> playRound() async {
    final p = await fetchRandomCard();
    final e = await fetchRandomCard();

    final attr = attributes[random.nextInt(attributes.length)];

    final playerValue = parseNumber(p[attr]);
    final enemyValue = parseNumber(e[attr]);

    String r = "";

    if (playerValue > enemyValue) {
      r = "Você venceu!";
      playerWins++;
    } else if (enemyValue > playerValue) {
      r = "Adversário venceu!";
      enemyWins++;
    } else {
      r = "Empate!";
    }

    setState(() {
      cardPlayer = p;
      cardEnemy = e;
      chosenAttribute = attr;
      result = r;
    });
  }

  Widget buildCard(Map<String, dynamic>? card, String? attr) {
    if (card == null) {
      return Container(
        width: 150,
        height: 250,
        color: Colors.grey[300],
        child: const Center(child: Text("Sem carta")),
      );
    }

    final imageUrl = card["image"];
    final attributeValue = attr != null ? card[attr] ?? "0" : "0";

    return Column(
      children: [
        Container(
          width: 150,
          height: 220,
          decoration: BoxDecoration(
            border: Border.all(width: 2),
            borderRadius: BorderRadius.circular(10),
            image: DecorationImage(
              image: NetworkImage(imageUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: 5),
        Text(
          "$attr: $attributeValue",
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    playRound();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Jogo de Cartas Dragon Ball"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              "Vitórias — Você: $playerWins   |   Adversário: $enemyWins",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    const Text("Adversário"),
                    const SizedBox(height: 10),
                    buildCard(cardEnemy, chosenAttribute),
                  ],
                ),
                Column(
                  children: [
                    const Text("Você"),
                    const SizedBox(height: 10),
                    buildCard(cardPlayer, chosenAttribute),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 25),
            if (chosenAttribute != null)
              Text(
                "Atributo escolhido: ${chosenAttribute!.toUpperCase()}",
                style: const TextStyle(fontSize: 22),
              ),
            const SizedBox(height: 20),
            Text(
              result,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: playRound,
              child: const Text("Jogar novamente"),
            ),
          ],
        ),
      ),
    );
  }
}
