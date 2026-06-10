/// Serviço oferecido (corte, barba, etc.) com preço e duração.
class Service {
  final String id;
  final String nome;
  final double preco;
  final int duracaoMin;
  final bool ativo;

  const Service({
    required this.id,
    required this.nome,
    required this.preco,
    required this.duracaoMin,
    this.ativo = true,
  });

  factory Service.fromJson(Map<String, dynamic> json) => Service(
        id: json['id'] as String,
        nome: json['nome'] as String,
        preco: (json['preco'] as num).toDouble(),
        duracaoMin: json['duracao_min'] as int,
        ativo: json['ativo'] as bool? ?? true,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'nome': nome,
        'preco': preco,
        'duracao_min': duracaoMin,
        'ativo': ativo,
      };
}
