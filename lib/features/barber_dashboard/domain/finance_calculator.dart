import '../../../data/models/appointment.dart';
import '../../../data/models/finance_entry.dart';

/// Cálculos do dashboard financeiro do barbeiro.
class FinanceCalculator {
  /// Faturamento (soma do valor) dos agendamentos pagos no período.
  double faturamento(List<Appointment> ags) => ags
      .where((a) => a.status == AppointmentStatus.pago)
      .fold(0.0, (s, a) => s + a.valor);

  /// Nº de cortes pagos.
  int cortes(List<Appointment> ags) =>
      ags.where((a) => a.status == AppointmentStatus.pago).length;

  /// Comissão a receber por um barbeiro: faturamento pago × percentual.
  double comissao(List<Appointment> ags, double pct) =>
      faturamento(ags) * pct;

  /// Lucro = entradas - saídas.
  double lucro(List<FinanceEntry> entries) => entries.fold(
      0.0,
      (s, e) => s + (e.tipo == EntryType.entrada ? e.valor : -e.valor));

  /// Progresso de uma meta (0.0 a 1.0, limitado a 1.0).
  double progressoMeta(double atual, double meta) {
    if (meta <= 0) return 0;
    final p = atual / meta;
    return p > 1.0 ? 1.0 : p;
  }
}
