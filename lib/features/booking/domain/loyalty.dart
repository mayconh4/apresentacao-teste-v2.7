/// Regras do programa de fidelidade (10 cortes → 1 grátis) e dias sem corte.
class LoyaltyService {
  final int cortesPorRecompensa;
  const LoyaltyService({this.cortesPorRecompensa = 10});

  /// Quantas recompensas (cortes grátis) o cliente já ganhou.
  int recompensas(int cortesAcumulados) =>
      cortesAcumulados ~/ cortesPorRecompensa;

  /// Quantos cortes faltam para a próxima recompensa.
  int faltamParaRecompensa(int cortesAcumulados) {
    final resto = cortesAcumulados % cortesPorRecompensa;
    return resto == 0 ? cortesPorRecompensa : cortesPorRecompensa - resto;
  }

  /// Dispara lembrete de fidelização após [limiteDias] sem cortar.
  bool deveLembrar(DateTime ultimoCorte, DateTime agora, {int limiteDias = 20}) =>
      agora.difference(ultimoCorte).inDays >= limiteDias;
}
