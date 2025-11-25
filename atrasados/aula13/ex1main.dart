import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

void main() {
  runApp(const MainApp());
}

class Localizacao {
  double latitude = 0.0;
  double longitude = 0.0;

  Future<void> pegaLocalizacaoAtual() async {
    LocationPermission permissao = await Geolocator.checkPermission();

    if (permissao == LocationPermission.denied) {
      permissao = await Geolocator.requestPermission();
      if (permissao == LocationPermission.denied) {
        print('Permissão de localização negada.');
        return;
      }
    }

    if (permissao == LocationPermission.deniedForever) {
      print('Permissão de localização negada permanentemente.');
      return;
    }

    Position posicao = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.low,
    );
    
    latitude = posicao.latitude;
    longitude = posicao.longitude;
  }
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  Localizacao localizacao = Localizacao();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getPosicao();
  }

  Future<void> getPosicao() async {
    setState(() {
      isLoading = true;
    });
    
    await localizacao.pegaLocalizacaoAtual();
    
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.teal,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.teal,
          foregroundColor: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text('Localização Atual')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (isLoading)
                  const Column(
                    children: [
                      CircularProgressIndicator(color: Colors.teal),
                      SizedBox(height: 20),
                      Text('Aguardando localização...', style: TextStyle(fontSize: 18, color: Colors.grey)),
                    ],
                  )
                else ...[
                  const Icon(Icons.location_on, size: 80, color: Colors.teal),
                  const SizedBox(height: 30),
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Latitude:', style: TextStyle(fontSize: 16, color: Colors.grey.shade600)),
                          Text(localizacao.latitude.toStringAsFixed(6),
                              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                          const Divider(),
                          Text('Longitude:', style: TextStyle(fontSize: 16, color: Colors.grey.shade600)),
                          Text(localizacao.longitude.toStringAsFixed(6),
                              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () async {
                    await getPosicao();
                  },
                  child: const Text('Atualizar Localização', style: TextStyle(fontSize: 18)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}