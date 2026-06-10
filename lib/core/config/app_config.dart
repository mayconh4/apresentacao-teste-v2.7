/// Configuração de ambiente. Valores reais vêm de --dart-define / .env,
/// nunca commitados no repositório.
class AppConfig {
  static const supabaseUrl =
      String.fromEnvironment('SUPABASE_URL', defaultValue: '');
  static const supabaseAnonKey =
      String.fromEnvironment('SUPABASE_ANON_KEY', defaultValue: '');
  static const asaasApiBase =
      String.fromEnvironment('ASAAS_API_BASE', defaultValue: '');

  static bool get configurado =>
      supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty;
}
