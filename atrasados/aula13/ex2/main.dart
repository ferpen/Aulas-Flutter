import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MainApp());
}

class Localizacao {
  double? latitude;
  double? longitude;

  Future<void> pegaLocalizacaoAtual() async {
    LocationPermission permissao = await Geolocator.checkPermission();

    if (permissao == LocationPermission.denied) {
      permissao = await Geolocator.requestPermission();
      if (permissao == LocationPermission.denied) {
        throw Exception('Permissão de localização negada.');
      }
    }

    if (permissao == LocationPermission.deniedForever) {
      throw Exception('Permissão de localização negada permanentemente.');
    }

    Position posicao = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    latitude = posicao.latitude;
    longitude = posicao.longitude;
  }
}

class Clima {
  final double temperatura;
  final double umidade;
  final double velocidadeVento;

  Clima({
    required this.temperatura,
    required this.umidade,
    required this.velocidadeVento,
  });

  factory Clima.fromJson(Map<String, dynamic> json) {
    return Clima(
      temperatura: json['current']['temperature_2m'].toDouble(),
      umidade: json['current']['relative_humidity_2m'].toDouble(),
      velocidadeVento: json['current']['wind_speed_10m'].toDouble(),
    );
  }
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final Localizacao localizacao = Localizacao();
  Clima? clima;
  bool carregando = true;
  String erro = '';

  @override
  void initState() {
    super.initState();
    obterDadosClima();
  }

  Future<void> obterDadosClima() async {
    setState(() {
      carregando = true;
      erro = '';
    });

    try {
      await localizacao.pegaLocalizacaoAtual();

      final url =
          'https://api.open-meteo.com/v1/forecast?latitude=${localizacao.latitude}&longitude=${localizacao.longitude}&current=temperature_2m,relative_humidity_2m,wind_speed_10m';

      final resposta = await http.get(Uri.parse(url));

      if (resposta.statusCode == 200) {
        final dados = json.decode(resposta.body);
        clima = Clima.fromJson(dados);
      } else {
        erro = 'Erro ao obter dados do clima: ${resposta.statusCode}';
      }
    } catch (e) {
      erro = 'Erro: $e';
    }

    setState(() {
      carregando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFF1A237E),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1A237E),
          elevation: 0,
          titleTextStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.blue,
        ).copyWith(
          secondary: Colors.lightBlueAccent,
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text('Clima Atual')),
        body: Center(
          child: carregando
              ? const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: Colors.lightBlueAccent),
                    SizedBox(height: 15),
                    Text('Buscando dados do clima...', style: TextStyle(color: Colors.white70)),
                  ],
                )
              : erro.isNotEmpty
                  ? Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Text(erro, style: const TextStyle(color: Colors.red, fontSize: 18), textAlign: TextAlign.center),
                    )
                  : clima == null
                      ? const Text('Sem dados disponíveis', style: TextStyle(fontSize: 20))
                      : Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Card(
                                elevation: 8,
                                color: const Color(0xFF3949AB), 
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Column(
                                    children: [
                                      const Text(
                                        'TEMPERATURA',
                                        style: TextStyle(fontSize: 18, color: Colors.white70),
                                      ),
                                      Text(
                                        '${clima!.temperatura.toStringAsFixed(1)} °C',
                                        style: const TextStyle(
                                          fontSize: 60,
                                          fontWeight: FontWeight.w900,
                                          color: Colors.lightBlueAccent,
                                        ),
                                      ),
                                      const Divider(color: Colors.white24, height: 30),
                                      _buildClimaDetail(Icons.water_drop, 'Umidade', '${clima!.umidade.toStringAsFixed(0)}%'),
                                      const SizedBox(height: 10),
                                      _buildClimaDetail(Icons.air, 'Vento', '${clima!.velocidadeVento.toStringAsFixed(1)} m/s'),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                'Lat: ${localizacao.latitude?.toStringAsFixed(3) ?? '-'}, Lon: ${localizacao.longitude?.toStringAsFixed(3) ?? '-'}',
                                style: const TextStyle(fontSize: 14, color: Colors.white54),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: obterDadosClima,
          backgroundColor: Colors.lightBlueAccent,
          child: const Icon(Icons.refresh, color: Colors.black),
        ),
      ),
    );
  }

  Widget _buildClimaDetail(IconData icon, String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon, color: Colors.white70),
            const SizedBox(width: 8),
            Text(label, style: const TextStyle(fontSize: 18, color: Colors.white70)),
          ],
        ),
        Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
      ],
    );
  }
}