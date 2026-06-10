import 'package:flutter_test/flutter_test.dart';
import 'package:barberapp/data/models/service.dart';

void main() {
  test('Service roundtrip JSON', () {
    const s = Service(id: 's1', nome: 'Corte + Barba', preco: 60, duracaoMin: 45);
    final back = Service.fromJson(s.toJson());
    expect(back.nome, 'Corte + Barba');
    expect(back.preco, 60);
    expect(back.duracaoMin, 45);
    expect(back.ativo, isTrue);
  });
}
