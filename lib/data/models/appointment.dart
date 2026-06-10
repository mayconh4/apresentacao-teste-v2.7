/// Status de um agendamento, mapeado às cores da agenda.
enum AppointmentStatus {
  aguardandoPagamento, // amarelo
  pago, // verde
  cancelado, // vermelho
  concluido;

  static AppointmentStatus fromString(String v) => AppointmentStatus.values
      .firstWhere((e) => e.name == v, orElse: () => AppointmentStatus.aguardandoPagamento);
}

/// Agendamento de um cliente com um barbeiro para um serviço.
class Appointment {
  final String id;
  final String clienteId;
  final String barbeiroId;
  final String serviceId;
  final DateTime inicio;
  final DateTime fim;
  final double valor;
  final AppointmentStatus status;

  const Appointment({
    required this.id,
    required this.clienteId,
    required this.barbeiroId,
    required this.serviceId,
    required this.inicio,
    required this.fim,
    required this.valor,
    this.status = AppointmentStatus.aguardandoPagamento,
  });

  Duration get duracao => fim.difference(inicio);

  /// Dois agendamentos se sobrepõem no tempo (mesmo barbeiro).
  bool overlaps(Appointment other) =>
      inicio.isBefore(other.fim) && other.inicio.isBefore(fim);

  factory Appointment.fromJson(Map<String, dynamic> json) => Appointment(
        id: json['id'] as String,
        clienteId: json['cliente_id'] as String,
        barbeiroId: json['barbeiro_id'] as String,
        serviceId: json['service_id'] as String,
        inicio: DateTime.parse(json['inicio'] as String),
        fim: DateTime.parse(json['fim'] as String),
        valor: (json['valor'] as num).toDouble(),
        status: AppointmentStatus.fromString(json['status'] as String? ?? ''),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'cliente_id': clienteId,
        'barbeiro_id': barbeiroId,
        'service_id': serviceId,
        'inicio': inicio.toIso8601String(),
        'fim': fim.toIso8601String(),
        'valor': valor,
        'status': status.name,
      };
}
