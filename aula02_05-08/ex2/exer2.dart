void main() {
  Aluno novo = new Aluno(Fulano de Tal,123456);
  print(novo.nome);
}
class Aluno{
  String nome;
  String matricula;
  Listint notas;
  Aluno(String n,String m){
    nome = n;
    matricula = m;
  }
}