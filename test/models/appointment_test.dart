import 'package:flutter_test/flutter_test.dart';
import 'package:barberapp/data/models/appointment.dart';

void main() {
  group('Appointment', () {
    final base = Appointment(
      id: '1',
      clienteId: 'c1',
      barbeiroId: 'b1',
      serviceId: 's1',
      inicio: DateTime(2026, 6, 10, 9, 0),
      fim: DateTime(2026, 6, 10, 9, 30),
      valor: 45,
    );

    test('calcula duração', () {
      expect(base.duracao, const Duration(minutes: 30));
    });

    test('detecta sobreposição', () {
      final sobreposto = Appointment(
        id: '2', clienteId: 'c2', barbeiroId: 'b1', serviceId: 's1',
        inicio: DateTime(2026, 6, 10, 9, 15),
        fim: DateTime(2026, 6, 10, 9, 45),
        valor: 45,
      );
      expect(base.overlaps(sobreposto), isTrue);
    });

    test('não sobrepõe horários adjacentes', () {
      final adjacente = Appointment(
        id: '3', clienteId: 'c3', barbeiroId: 'b1', serviceId: 's1',
        inicio: DateTime(2026, 6, 10, 9, 30),
        fim: DateTime(2026, 6, 10, 10, 0),
        valor: 45,
      );
      expect(base.overlaps(adjacente), isFalse);
    });

    test('serializa e desserializa (roundtrip)', () {
      final json = base.toJson();
      final back = Appointment.fromJson(json);
      expect(back.id, base.id);
      expect(back.valor, base.valor);
      expect(back.status, base.status);
    });

    test('status default é aguardandoPagamento', () {
      expect(base.status, AppointmentStatus.aguardandoPagamento);
    });
  });
}
