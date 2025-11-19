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
    return MaterialApp(debugShowCheckedModeBanner: false, home: WeatherPage());
  }
}

class WeatherPage extends StatefulWidget {
  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final TextEditingController _controller = TextEditingController();

  String? temperature;
  String? humidity;
  String? wind;
  String? errorMessage;

  Future<Map<String, dynamic>?> _getCoordinates(String city) async {
    final url =
        "https://geocoding-api.open-meteo.com/v1/search?name=$city&count=1&language=en&format=json";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data["results"] != null && data["results"].isNotEmpty) {
        final result = data["results"][0];
        return {"lat": result["latitude"], "lon": result["longitude"]};
      }
    }
    return null;
  }

  Future<Map<String, dynamic>?> _getWeather(double lat, double lon) async {
    final url =
        "https://api.open-meteo.com/v1/forecast?latitude=$lat&longitude=$lon&current_weather=true&hourly=relativehumidity_2m";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      final temperature = data["current_weather"]["temperature"];
      final wind = data["current_weather"]["windspeed"];
      final humidity = data["hourly"]["relativehumidity_2m"][0];

      return {"temperature": temperature, "humidity": humidity, "wind": wind};
    }
    return null;
  }

  Future<void> _searchWeather() async {
    setState(() {
      errorMessage = null;
      temperature = humidity = wind = null;
    });

    final city = _controller.text.trim();
    if (city.isEmpty) {
      setState(() => errorMessage = "Digite o nome de uma cidade.");
      return;
    }

    final coords = await _getCoordinates(city);

    if (coords == null) {
      setState(() => errorMessage = "Cidade não encontrada.");
      return;
    }

    final weather = await _getWeather(coords["lat"], coords["lon"]);

    if (weather == null) {
      setState(() => errorMessage = "Não foi possível obter as informações.");
      return;
    }

    setState(() {
      temperature = weather["temperature"].toString();
      humidity = weather["humidity"].toString();
      wind = weather["wind"].toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Busca de Clima"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: "Nome da cidade",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: _searchWeather,
              child: const Text("Buscar"),
            ),

            const SizedBox(height: 30),

            if (errorMessage != null)
              Text(
                errorMessage!,
                style: const TextStyle(color: Colors.red, fontSize: 18),
              ),

            if (temperature != null) ...[
              Text(
                "Temperatura: $temperature °C",
                style: const TextStyle(fontSize: 20),
              ),
              Text(
                "Umidade: $humidity %",
                style: const TextStyle(fontSize: 20),
              ),
              Text(
                "Velocidade do vento: $wind km/h",
                style: const TextStyle(fontSize: 20),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
