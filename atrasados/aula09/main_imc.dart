import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

const double alturaConstante = 80.0;
const Color fundo = Color(0xFF2B2155);
const Color selecionada = Color(0xFF7E57C2);
const Color corPrimaria = Colors.teal;

enum Genero { masculino, feminino }

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  double altura = 170.0;
  double peso = 70.0;
  double resultado = 24.22;
  Genero generoSelecionado = Genero.masculino;

  @override
  void initState() {
    super.initState();
    calcularIMC();
  }

  void calcularIMC() {
    setState(() {
      resultado = peso / ((altura / 100) * (altura / 100));
    });
  }

  void selecionarGenero(Genero genero) {
    setState(() {
      generoSelecionado = genero;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: corPrimaria,
        scaffoldBackgroundColor: fundo,
        appBarTheme: const AppBarTheme(
          backgroundColor: fundo,
          elevation: 0,
          titleTextStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.teal,
        ).copyWith(
          secondary: Colors.pinkAccent,
        ),
        sliderTheme: SliderThemeData(
          activeTrackColor: Colors.pinkAccent,
          inactiveTrackColor: Colors.pinkAccent.withOpacity(0.3),
          thumbColor: corPrimaria,
          overlayColor: corPrimaria.withOpacity(0.2),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text('Calculadora de IMC')),
        body: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => selecionarGenero(Genero.masculino),
                      child: Caixa(
                        cor: generoSelecionado == Genero.masculino
                            ? selecionada
                            : fundo,
                        filho: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.male,
                                size: 80,
                                color: generoSelecionado == Genero.masculino
                                    ? corPrimaria
                                    : Colors.white),
                            const SizedBox(height: 15.0),
                            const Text(
                              'HOMEM',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => selecionarGenero(Genero.feminino),
                      child: Caixa(
                        cor: generoSelecionado == Genero.feminino
                            ? selecionada
                            : fundo,
                        filho: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.female,
                                size: 80,
                                color: generoSelecionado == Genero.feminino
                                    ? corPrimaria
                                    : Colors.white),
                            const SizedBox(height: 15.0),
                            const Text(
                              'MULHER',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Caixa(
                cor: fundo,
                filho: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'ALTURA',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          altura.toStringAsFixed(0),
                          style: const TextStyle(
                              fontSize: 50, fontWeight: FontWeight.w900),
                        ),
                        const Text(
                          'cm',
                          style: TextStyle(fontSize: 20, color: Colors.grey),
                        ),
                      ],
                    ),
                    Slider(
                      value: altura,
                      min: 100,
                      max: 220,
                      divisions: 120,
                      label: altura.toStringAsFixed(0),
                      onChanged: (double newValue) {
                        setState(() {
                          altura = newValue;
                        });
                        calcularIMC();
                      },
                    ),
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
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            'PESO (kg)',
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                          Text(
                            peso.toStringAsFixed(1),
                            style: const TextStyle(
                                fontSize: 40, fontWeight: FontWeight.w900),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FloatingActionButton(
                                heroTag: "btn_remove_peso",
                                mini: true,
                                backgroundColor: selecionada,
                                onPressed: () {
                                  setState(() {
                                    if (peso > 10) peso -= 0.5;
                                  });
                                  calcularIMC();
                                },
                                child: const Icon(Icons.remove, color: Colors.white),
                              ),
                              const SizedBox(width: 10),
                              FloatingActionButton(
                                heroTag: "btn_add_peso",
                                mini: true,
                                backgroundColor: selecionada,
                                onPressed: () {
                                  setState(() {
                                    peso += 0.5;
                                  });
                                  calcularIMC();
                                },
                                child: const Icon(Icons.add, color: Colors.white),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Caixa(
                      cor: selecionada,
                      filho: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            'SEU IMC É',
                            style: TextStyle(fontSize: 18, color: Colors.white70),
                          ),
                          Text(
                            resultado.toStringAsFixed(1),
                            style: const TextStyle(
                                fontSize: 40, fontWeight: FontWeight.w900, color: Colors.pinkAccent),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              color: corPrimaria,
              width: double.infinity,
              height: alturaConstante,
              alignment: Alignment.center,
              child: const Text(
                'CALCULAR',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
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
    return Container(
      margin: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        color: cor,
      ),
      child: filho,
    );
  }
}