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
        title: Text('Coruja Buraqueira'),
        backgroundColor: Colors.lightGreen[800],
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Text('A coruja-buraqueira é uma ave strigiforme da família Strigidae. Também conhecida pelos nomes de caburé, caburé-de-cupim, caburé-do-campo, coruja-barata, coruja-do-campo, coruja-mineira, corujinha-buraqueira, corujinha-do-buraco, corujinha-do-campo, guedé, urucuera, urucureia, urucuriá, coruja-cupinzeira (algumas cidades de Goiás) e capotinha. Com o nome científico cunicularia (“pequeno mineiro”), recebe esse nome por cavar buracos no solo. Vive cerca de 9 anos em habitat selvagem. Costuma viver em campos, pastos, restingas, desertos, planícies, praias e aeroportos.'),
                          Container(
                width: 200,
                color: Colors.lightBlue,
                margin: EdgeInsets.all(20),
                padding: EdgeInsets.all(10),
                child: Image.network(
                  'https://agron.com.br/wp-content/uploads/2025/05/Como-a-coruja-buraqueira-vive-em-grupo-2.webp',
                ),
              ),
            SizedBox(height: 50),
            
            ElevatedButton(
              onPressed: () {
                // código para ir
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SegundaPagina(),
                  ),
                );
              },
              child: const Text('Próxima'),
            ),
          ],
        ),
      ),
    );
  }
}

class SegundaPagina extends StatelessWidget {
  const SegundaPagina({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightGreen[400],
      appBar: AppBar(
        title: Text('Rolinha-do-Planalto'),
        backgroundColor: Colors.lightGreen[800],
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Text('A rolinha-do-planalto (Columbina cyanopis) é uma ave Columbiforme da família Columbidae. Também conhecida como rolinha de janeiro, rolinha-brasileira ou pombinha-olho-azul. Descoberta em 1823, a ave só foi vista novamente em 1904 e, depois, em 1941. Desde então sua presença nunca mais foi registrada, a não ser por um trabalho de 1988 publicado por SILVA & ONIKI, que listam a espécie em estudo na região da Estação Ecológica da Serra das Araras - MT.'),
            Container(
                width: 200,
                color: Colors.lightBlue,
                margin: EdgeInsets.all(20),
                padding: EdgeInsets.all(10),
                child: Image.network(
                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTpdHf2MIVXL7Hk5XVZXFJCdH6_LeAuyzxA5Q&s',
                ),
              ),
            SizedBox(height: 50),
            ElevatedButton(
              onPressed: () {
                // código para voltar
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