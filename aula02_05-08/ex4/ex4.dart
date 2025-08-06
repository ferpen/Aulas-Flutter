void main() {
  Aluno novo = new Aluno("Fulano de Tal", "123456");
  print(novo.nome);
  novo.lancaNota(6.3);
  novo.lancaNota(5.2);
  novo.lancaNota(9.4);
  print(novo.notas);

}

class Aluno {
  String? nome;
  String? matricula;
  List<double> notas = [];
  Aluno(String n, String m) {
    nome = n;
    matricula = m;
  }
  void lancaNota(double nova) {
    notas.add(nova);
  }
}
