import '../models/barber.dart';
import '../models/service.dart';
import '../models/appointment.dart';

/// Contrato de acesso a dados de agendamento.
/// Implementação real usará Supabase; aqui fica a interface + um stub em memória.
abstract class BookingRepository {
  Future<List<Barber>> listarBarbeiros();
  Future<List<Service>> listarServicos();
  Future<List<Appointment>> agendamentosDoDia(String barbeiroId, DateTime dia);
  Future<Appointment> criarAgendamento(Appointment a);
}

/// Stub em memória — usado em testes e desenvolvimento sem backend.
class InMemoryBookingRepository implements BookingRepository {
  final List<Barber> barbeiros;
  final List<Service> servicos;
  final List<Appointment> agendamentos;

  InMemoryBookingRepository({
    this.barbeiros = const [],
    this.servicos = const [],
    List<Appointment>? agendamentos,
  }) : agendamentos = agendamentos ?? [];

  @override
  Future<List<Barber>> listarBarbeiros() async => barbeiros;

  @override
  Future<List<Service>> listarServicos() async => servicos;

  @override
  Future<List<Appointment>> agendamentosDoDia(
          String barbeiroId, DateTime dia) async =>
      agendamentos
          .where((a) =>
              a.barbeiroId == barbeiroId &&
              a.inicio.year == dia.year &&
              a.inicio.month == dia.month &&
              a.inicio.day == dia.day)
          .toList();

  @override
  Future<Appointment> criarAgendamento(Appointment a) async {
    // Garante que não há sobreposição para o mesmo barbeiro.
    final conflito = agendamentos.any((x) =>
        x.barbeiroId == a.barbeiroId &&
        x.status != AppointmentStatus.cancelado &&
        x.overlaps(a));
    if (conflito) {
      throw StateError('Horário indisponível para este barbeiro.');
    }
    agendamentos.add(a);
    return a;
  }
}
