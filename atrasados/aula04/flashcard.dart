import 'package:flutter/material.dart';

void main() {
  runApp(const FlashcardApp());
}

class FlashcardApp extends StatelessWidget {
  const FlashcardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        scaffoldBackgroundColor: Colors.grey[50],
        appBarTheme: AppBarTheme(
          color: Colors.grey[50], 
          elevation: 0, 
          titleTextStyle: TextStyle(
            color: Colors.indigo[900],
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(
            color: Colors.indigo[900],
          ),
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Verb Flashcards'),
        ),
        
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: <Widget>[
                
                const FlashcardWidget(
                  frase: 'He ran a marathon last month.',
                  tempoVerbal: 'Past', 
                  icone: Icons.history, 
                  corIcone: Colors.brown,
                  urlImagem: 'https://images.pexels.com/photos/1034662/pexels-photo-1034662.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1', 
                ),

                const FlashcardWidget(
                  frase: 'She runs every evening.',
                  tempoVerbal: 'Present', 
                  icone: Icons.wb_sunny, 
                  corIcone: Colors.orange,
                  urlImagem: 'https://admin.cnnbrasil.com.br/wp-content/uploads/sites/12/2025/03/corredora-holandesa-cai-prova-atletismo-e1741606396468.jpg?w=1200&h=675&crop=1', 
                ),


                const FlashcardWidget(
                  frase: 'They will run in the next race.',
                  tempoVerbal: 'Future', 
                  icone: Icons.event, 
                  corIcone: Colors.blue,
                  urlImagem: 'https://cdn.atletis.com.br/atletis-website/base/088/7f1/a5b/treinos-grupos-de-corrida.jpg', 
                ),
                
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class FlashcardWidget extends StatelessWidget {
  final String frase;
  final String tempoVerbal;
  final IconData icone;
  final Color corIcone;
  final String urlImagem;

  const FlashcardWidget({
    super.key,
    required this.frase,
    required this.tempoVerbal,
    required this.icone,
    required this.corIcone,
    required this.urlImagem,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      elevation: 10,
      clipBehavior: Clip.antiAlias, 
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15), 
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Image.network(
            urlImagem,
            height: 180, 
            fit: BoxFit.cover, 
          ),
          
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: corIcone.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Icon(icone, color: corIcone, size: 30),
                ),
                
                const SizedBox(width: 16),
                
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        frase,
                        style: const TextStyle(
                          fontSize: 18, 
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        tempoVerbal,
                        style: TextStyle(
                          fontSize: 14, 
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.bold,
                          color: Colors.indigo[400],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.only(right: 16.0, bottom: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                
                TextButton(
                  onPressed: () {
                    
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.indigo, 
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                  child: const Text(
                    'MARCAR COMO MEMORIZADO', 
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}