import 'package:flutter_test/flutter_test.dart';
import 'package:barberapp/data/models/appointment.dart';
import 'package:barberapp/features/booking/domain/availability.dart';

void main() {
  final svc = AvailabilityService();
  final dia = DateTime(2026, 6, 10);
  const horario = WorkingHours(
    abreHora: 8, fechaHora: 12,
    almocoInicioHora: 10, almocoFimHora: 11,
  );

  test('gera slots respeitando passo e fechamento', () {
    final slots = svc.slotsLivres(
      dia: dia, horario: horario, duracaoMin: 30, agendamentos: [],
    );
    // 8:00,8:30,9:00,9:30 | almoço 10-11 | 11:00,11:30  => 6 slots
    expect(slots.length, 6);
    expect(slots.first, DateTime(2026, 6, 10, 8, 0));
    expect(slots.last, DateTime(2026, 6, 10, 11, 30));
  });

  test('exclui horário do almoço', () {
    final slots = svc.slotsLivres(
      dia: dia, horario: horario, duracaoMin: 30, agendamentos: [],
    );
    expect(slots.any((s) => s.hour == 10), isFalse);
  });

  test('remove slots ocupados por agendamento existente', () {
    final ocupado = Appointment(
      id: 'x', clienteId: 'c', barbeiroId: 'b1', serviceId: 's1',
      inicio: DateTime(2026, 6, 10, 9, 0),
      fim: DateTime(2026, 6, 10, 9, 30),
      valor: 45,
    );
    final slots = svc.slotsLivres(
      dia: dia, horario: horario, duracaoMin: 30, agendamentos: [ocupado],
    );
    expect(slots.any((s) => s.hour == 9 && s.minute == 0), isFalse);
  });

  test('agendamento cancelado não bloqueia slot', () {
    final cancelado = Appointment(
      id: 'x', clienteId: 'c', barbeiroId: 'b1', serviceId: 's1',
      inicio: DateTime(2026, 6, 10, 9, 0),
      fim: DateTime(2026, 6, 10, 9, 30),
      valor: 45, status: AppointmentStatus.cancelado,
    );
    final slots = svc.slotsLivres(
      dia: dia, horario: horario, duracaoMin: 30, agendamentos: [cancelado],
    );
    expect(slots.any((s) => s.hour == 9 && s.minute == 0), isTrue);
  });
}
