import 'package:flutter/material.dart';

void main() {
  runApp(const PetAgeApp());
}

const double altura = 80.0;
const Color fundo = Color(0xFF2B2155);
const Color selecionada = Color(0xFF7E57C2); 
enum Animal { gato, cachorro }

class PetAgeApp extends StatefulWidget {
  const PetAgeApp({super.key});

  @override
  State<PetAgeApp> createState() => _PetAgeAppState();
}

class _PetAgeAppState extends State<PetAgeApp> {
  Animal animalSelecionado = Animal.gato;
  int idade = 1;
  double peso = 5.0;

  void selecionarAnimal(Animal animal) {
    setState(() {
      animalSelecionado = animal;
      idade = 1; 
      peso = 5.0; 
    });
  }

  String calcularIdadeFisiologica() {
    if (animalSelecionado == Animal.gato) {
      const gatos = [
        10,
        15,
        24,
        28,
        32,
        36,
        40,
        44,
        48,
        52,
        56,
        60,
        64,
        68,
        72,
        76,
        80,
        84,
        88,
        92,
        96,
        100
      ];
      if (idade >= 1 && idade <= gatos.length) {
        return gatos[idade - 1].toString();
      }
    } else {
      const cachorro = {
        'pequeno': [
          15,
          24,
          28,
          32,
          36,
          40,
          44,
          48,
          52,
          56,
          60,
          64,
          68,
          72,
          76,
          80,
          84,
          88,
          92,
          96
        ],
        'medio': [
          15,
          24,
          28,
          33,
          37,
          42,
          47,
          52,
          56,
          60,
          65,
          69,
          74,
          78,
          83,
          87,
          92,
          96,
          101,
          105
        ],
        'grande': [
          15,
          24,
          28,
          35,
          40,
          45,
          50,
          55,
          61,
          66,
          72,
          77,
          82,
          88,
          93,
          99,
          104,
          109,
          115,
          120
        ],
        'gigante': [
          15,
          24,
          32,
          37,
          42,
          49,
          56,
          64,
          71,
          78,
          86,
          93,
          101,
          108,
          115,
          123
        ]
      };

      String porte = '';
      if (peso <= 9.07) {
        porte = 'pequeno';
      } else if (peso <= 22.7) {
        porte = 'medio';
      } else if (peso <= 40.8) {
        porte = 'grande';
      } else {
        porte = 'gigante';
      }

      List<int> lista = cachorro[porte]!;
      if (idade - 1 >= 0 && idade - 1 < lista.length) {
        return lista[idade - 1].toString();
      } else {
        return '-';
      }
    }

    return '-';
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.deepPurple,
        scaffoldBackgroundColor: fundo,
        appBarTheme: const AppBarTheme(
          backgroundColor: fundo,
          elevation: 0,
        ),
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.deepPurple,
        ).copyWith(
          secondary: Colors.pinkAccent,
        ),
        sliderTheme: SliderThemeData(
          activeTrackColor: Colors.pinkAccent,
          inactiveTrackColor: Colors.pinkAccent.withOpacity(0.3),
          thumbColor: Colors.pinkAccent,
          overlayColor: Colors.pinkAccent.withOpacity(0.2),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text('Idade Fisiológica de Pets')),
        body: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => selecionarAnimal(Animal.gato),
                      child: Caixa(
                        cor: animalSelecionado == Animal.gato
                            ? selecionada
                            : fundo,
                        filho: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.cat_production, size: 80.0, color: Colors.pinkAccent),
                            const SizedBox(height: 15),
                            const Text('GATO', style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold))
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => selecionarAnimal(Animal.cachorro),
                      child: Caixa(
                        cor: animalSelecionado == Animal.cachorro
                            ? selecionada
                            : fundo,
                        filho: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.dog_production, size: 80.0, color: Colors.lightBlueAccent),
                            const SizedBox(height: 15),
                            const Text('CACHORRO', style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold))
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (animalSelecionado == Animal.cachorro)
              Expanded(
                child: Caixa(
                  cor: fundo,
                  filho: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Peso do Cachorro (kg)',
                          style: TextStyle(fontSize: 18.0, color: Colors.grey)),
                      Text('${peso.toStringAsFixed(1)} kg',
                          style: const TextStyle(
                              fontSize: 32, color: Colors.white, fontWeight: FontWeight.bold)),
                      Slider(
                        value: peso,
                        min: 1,
                        max: 60,
                        divisions: 590,
                        label: '${peso.toStringAsFixed(1)} kg',
                        onChanged: (double novoPeso) {
                          setState(() {
                            peso = novoPeso;
                          });
                        },
                      )
                    ],
                  ),
                ),
              ),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Caixa(
                      cor: fundo,
                      filho: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Idade Atual (anos)',
                              style: TextStyle(color: Colors.grey, fontSize: 18.0)),
                          Text('$idade',
                              style: const TextStyle(
                                  fontSize: 48.0, color: Colors.white, fontWeight: FontWeight.w900)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FloatingActionButton(
                                heroTag: "btn_add",
                                onPressed: () {
                                  setState(() {
                                    if (idade < (animalSelecionado == Animal.gato ? 21 : 20)) idade++;
                                  });
                                },
                                mini: true,
                                backgroundColor: selecionada,
                                child: const Icon(Icons.add, color: Colors.white),
                              ),
                              const SizedBox(width: 15),
                              FloatingActionButton(
                                heroTag: "btn_remove",
                                onPressed: () {
                                  setState(() {
                                    if (idade > 1) idade--;
                                  });
                                },
                                mini: true,
                                backgroundColor: selecionada,
                                child: const Icon(Icons.remove, color: Colors.white),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Caixa(
                      cor: selecionada, // Destaque para o resultado
                      filho: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Idade Fisiológica',
                              style: TextStyle(color: Colors.white70, fontSize: 18.0)),
                          const SizedBox(height: 10),
                          Text(
                            calcularIdadeFisiologica(),
                            style: const TextStyle(
                                fontSize: 60.0, color: Colors.pinkAccent, fontWeight: FontWeight.w900),
                          ),
                          const Text('anos humanos',
                              style: TextStyle(color: Colors.white70, fontSize: 16.0)),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              color: Colors.deepPurple,
              width: double.infinity,
              height: altura,
              alignment: Alignment.center,
              child: const Text(
                'Tabela de Conversão de Idades Pet',
                style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Caixa extends StatelessWidget {
  final Color cor;
  final Widget? filho;

  const Caixa({super.key, required this.cor, this.filho});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(12.0),
      color: cor,
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: filho,
    );
  }
}