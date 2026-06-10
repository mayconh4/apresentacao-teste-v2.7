import '../../../data/models/appointment.dart';

/// Janela de trabalho diária de um barbeiro.
class WorkingHours {
  final int abreHora;
  final int abreMin;
  final int fechaHora;
  final int fechaMin;
  final int? almocoInicioHora;
  final int? almocoFimHora;

  const WorkingHours({
    required this.abreHora,
    this.abreMin = 0,
    required this.fechaHora,
    this.fechaMin = 0,
    this.almocoInicioHora,
    this.almocoFimHora,
  });
}

/// Geração de horários livres — núcleo do "agendar em 3 cliques".
class AvailabilityService {
  /// Retorna os horários de início disponíveis em [dia] para um serviço de
  /// [duracaoMin], com passo de [passoMin], descontando o almoço e os
  /// agendamentos já existentes (não cancelados).
  List<DateTime> slotsLivres({
    required DateTime dia,
    required WorkingHours horario,
    required int duracaoMin,
    required List<Appointment> agendamentos,
    int passoMin = 30,
  }) {
    final abertura = DateTime(
        dia.year, dia.month, dia.day, horario.abreHora, horario.abreMin);
    final fechamento = DateTime(
        dia.year, dia.month, dia.day, horario.fechaHora, horario.fechaMin);

    final ocupados = agendamentos
        .where((a) => a.status != AppointmentStatus.cancelado)
        .toList();

    final slots = <DateTime>[];
    var cursor = abertura;
    final passo = Duration(minutes: passoMin);
    final duracao = Duration(minutes: duracaoMin);

    while (!cursor.add(duracao).isAfter(fechamento)) {
      final fim = cursor.add(duracao);
      if (!_conflita(cursor, fim, horario, ocupados, dia)) {
        slots.add(cursor);
      }
      cursor = cursor.add(passo);
    }
    return slots;
  }

  bool _conflita(DateTime inicio, DateTime fim, WorkingHours h,
      List<Appointment> ocupados, DateTime dia) {
    // Almoço
    if (h.almocoInicioHora != null && h.almocoFimHora != null) {
      final almocoIni =
          DateTime(dia.year, dia.month, dia.day, h.almocoInicioHora!);
      final almocoFim =
          DateTime(dia.year, dia.month, dia.day, h.almocoFimHora!);
      if (inicio.isBefore(almocoFim) && almocoIni.isBefore(fim)) return true;
    }
    // Agendamentos existentes
    for (final a in ocupados) {
      if (inicio.isBefore(a.fim) && a.inicio.isBefore(fim)) return true;
    }
    return false;
  }
}
