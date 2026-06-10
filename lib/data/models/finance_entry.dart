enum EntryType { entrada, saida }

/// Lançamento financeiro (entrada ou saída).
class FinanceEntry {
  final String id;
  final EntryType tipo;
  final String categoria;
  final double valor;
  final DateTime data;

  const FinanceEntry({
    required this.id,
    required this.tipo,
    required this.categoria,
    required this.valor,
    required this.data,
  });
}
