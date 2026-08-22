/// Application environments for Solitaire Al-Arab.
///
/// Exact Firebase project IDs and store application IDs are configured
/// outside source when available. Do not hard-code production secrets.
enum AppEnvironment {
  dev,
  test,
  staging,
  prod;

  bool get isProduction => this == AppEnvironment.prod;

  String get label => name.toUpperCase();

  /// PLACEHOLDER — replace with the approved organization reverse-domain
  /// once available. Do not treat these as final store identifiers.
  String get applicationIdPlaceholder {
    const base = 'com.arabsolitaire.app'; // PLACEHOLDER_ORG_ID
    return switch (this) {
      AppEnvironment.dev => '$base.dev',
      AppEnvironment.test => '$base.test',
      AppEnvironment.staging => '$base.staging',
      AppEnvironment.prod => base,
    };
  }
}
