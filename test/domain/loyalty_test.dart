import 'package:flutter_test/flutter_test.dart';
import 'package:barberapp/features/booking/domain/loyalty.dart';

void main() {
  const svc = LoyaltyService();

  test('recompensas a cada 10 cortes', () {
    expect(svc.recompensas(9), 0);
    expect(svc.recompensas(10), 1);
    expect(svc.recompensas(23), 2);
  });

  test('faltam para a próxima recompensa', () {
    expect(svc.faltamParaRecompensa(0), 10);
    expect(svc.faltamParaRecompensa(7), 3);
    expect(svc.faltamParaRecompensa(10), 10);
  });

  test('lembra após 20 dias sem corte', () {
    final ultimo = DateTime(2026, 5, 10);
    expect(svc.deveLembrar(ultimo, DateTime(2026, 5, 25)), isFalse); // 15 dias
    expect(svc.deveLembrar(ultimo, DateTime(2026, 6, 4)), isTrue); // 25 dias
  });
}
