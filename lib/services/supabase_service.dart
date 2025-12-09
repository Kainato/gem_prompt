class SupabaseService {
  static final SupabaseService _instance = SupabaseService._internal();

  SupabaseService._internal();

  /// Sempre acessar o client via este getter para garantir uso consistente
  /// ```dart
  /// SupabaseClient get _svcClient => Supabase.instance.client;
  /// ```
  factory SupabaseService() => _instance;
}
