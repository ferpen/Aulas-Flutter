void main() {
  int atual = DateTime.now().month;
  int informado = 4;
  if (atual > informado) {
    print('${atual} é maior que ${informado}');
  } else {
    print('${atual} é menor que ${informado}');
  }
}
