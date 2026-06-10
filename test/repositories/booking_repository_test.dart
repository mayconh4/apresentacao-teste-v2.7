import 'package:flutter_test/flutter_test.dart';
import 'package:barberapp/data/models/appointment.dart';
import 'package:barberapp/data/repositories/booking_repository.dart';

Appointment mk(String id, int h) => Appointment(
      id: id, clienteId: 'c', barbeiroId: 'b1', serviceId: 's',
      inicio: DateTime(2026, 6, 10, h), fim: DateTime(2026, 6, 10, h, 30),
      valor: 45,
    );

void main() {
  test('cria agendamento sem conflito', () async {
    final repo = InMemoryBookingRepository();
    await repo.criarAgendamento(mk('1', 9));
    final doDia = await repo.agendamentosDoDia('b1', DateTime(2026, 6, 10));
    expect(doDia.length, 1);
  });

  test('rejeita agendamento sobreposto', () async {
    final repo = InMemoryBookingRepository(agendamentos: [mk('1', 9)]);
    expect(
      () => repo.criarAgendamento(mk('2', 9)),
      throwsA(isA<StateError>()),
    );
  });

  test('filtra agendamentos por dia', () async {
    final repo = InMemoryBookingRepository(agendamentos: [
      mk('1', 9),
      Appointment(
        id: '2', clienteId: 'c', barbeiroId: 'b1', serviceId: 's',
        inicio: DateTime(2026, 6, 11, 9), fim: DateTime(2026, 6, 11, 9, 30),
        valor: 45),
    ]);
    final doDia = await repo.agendamentosDoDia('b1', DateTime(2026, 6, 10));
    expect(doDia.length, 1);
    expect(doDia.first.id, '1');
  });
}
