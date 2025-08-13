import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(debugShowCheckedModeBanner: false, home: PrimeiraPagina()),
  );
}

class PrimeiraPagina extends StatelessWidget {
  const PrimeiraPagina({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightGreen[400],
      appBar: AppBar(
        title: Text('Sobre Mim'),
        backgroundColor: Colors.lightGreen[800],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircleAvatar(radius: 50),
            SizedBox(height: 10),
            Text(
              'Gustavo Oliveira',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text('20 anos', style: TextStyle(fontSize: 18)),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const FilmesPagina()),
                );
              },
              child: const Text('Filmes'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LivrosPagina()),
                );
              },
              child: const Text('Livros'),
            ),
          ],
        ),
      ),
    );
  }
}

class FilmesPagina extends StatelessWidget {
  const FilmesPagina({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightGreen[400],
      appBar: AppBar(
        title: Text('Meus Filmes Favoritos'),
        backgroundColor: Colors.lightGreen[800],
      ),
      body: Center(
        child: ListView(
          children: <Widget>[
            ListTile(title: Text('1. O Senhor dos Anéis')),
            ListTile(title: Text('2. Star Wars')),
            ListTile(title: Text('3. Matrix')),
            ListTile(title: Text('4. Interstellar')),
            ListTile(title: Text('5. Vingadores')),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Voltar'),
            ),
          ],
        ),
      ),
    );
  }
}

class LivrosPagina extends StatelessWidget {
  const LivrosPagina({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightGreen[400],
      appBar: AppBar(
        title: Text('Meus Livros Favoritos'),
        backgroundColor: Colors.lightGreen[800],
      ),
      body: Center(
        child: ListView(
          children: <Widget>[
            ListTile(title: Text('1. Dom Quixote')),
            ListTile(title: Text('2. A revoluçãio dos bixos')),
            ListTile(title: Text('3. Harry Potter')),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Voltar'),
            ),
          ],
        ),
      ),
    );
  }
}
