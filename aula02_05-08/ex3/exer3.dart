void main() {
  Aluno novo = new Aluno("Fulano de Tal", "123456");
  print(novo.nome);
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
