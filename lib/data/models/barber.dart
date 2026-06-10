/// Barbeiro, com especialidades e percentual de comissão.
class Barber {
  final String id;
  final String nome;
  final String? fotoUrl;
  final List<String> especialidades;
  final double comissaoPct; // 0.0 a 1.0
  final bool ativo;

  const Barber({
    required this.id,
    required this.nome,
    this.fotoUrl,
    this.especialidades = const [],
    this.comissaoPct = 0.0,
    this.ativo = true,
  });

  factory Barber.fromJson(Map<String, dynamic> json) => Barber(
        id: json['id'] as String,
        nome: json['nome'] as String,
        fotoUrl: json['foto_url'] as String?,
        especialidades:
            (json['especialidades'] as List?)?.cast<String>() ?? const [],
        comissaoPct: (json['comissao_pct'] as num?)?.toDouble() ?? 0.0,
        ativo: json['ativo'] as bool? ?? true,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'nome': nome,
        'foto_url': fotoUrl,
        'especialidades': especialidades,
        'comissao_pct': comissaoPct,
        'ativo': ativo,
      };
}
