import 'package:flutter_test/flutter_test.dart';
import 'package:barberapp/data/models/appointment.dart';
import 'package:barberapp/data/models/finance_entry.dart';
import 'package:barberapp/features/barber_dashboard/domain/finance_calculator.dart';

Appointment ag(double v, AppointmentStatus s) => Appointment(
      id: 'a', clienteId: 'c', barbeiroId: 'b', serviceId: 's',
      inicio: DateTime(2026, 6, 10, 9), fim: DateTime(2026, 6, 10, 10),
      valor: v, status: s,
    );

void main() {
  final calc = FinanceCalculator();
  final ags = [
    ag(45, AppointmentStatus.pago),
    ag(60, AppointmentStatus.pago),
    ag(30, AppointmentStatus.aguardandoPagamento),
    ag(50, AppointmentStatus.cancelado),
  ];

  test('faturamento soma apenas pagos', () {
    expect(calc.faturamento(ags), 105);
  });

  test('conta cortes pagos', () {
    expect(calc.cortes(ags), 2);
  });

  test('comissão = faturamento × pct', () {
    expect(calc.comissao(ags, 0.4), closeTo(42.0, 0.0001));
  });

  test('lucro = entradas - saídas', () {
    final entries = [
      FinanceEntry(id: '1', tipo: EntryType.entrada, categoria: 'cortes', valor: 540, data: DateTime(2026, 6, 10)),
      FinanceEntry(id: '2', tipo: EntryType.saida, categoria: 'aluguel', valor: 200, data: DateTime(2026, 6, 10)),
    ];
    expect(calc.lucro(entries), 340);
  });

  test('progresso da meta é limitado a 1.0', () {
    expect(calc.progressoMeta(7850, 10000), closeTo(0.785, 0.0001));
    expect(calc.progressoMeta(12000, 10000), 1.0);
    expect(calc.progressoMeta(100, 0), 0);
  });
}
