import 'dart:math';

void main() {
  Classe circulo = Classe(5.75);
  print("${circulo.getArea()}");
}

class Classe{
  double raio;
  Classe(this.raio);
  double getArea(){
    double area = pi*(raio*raio);
    return area;
  }
}
