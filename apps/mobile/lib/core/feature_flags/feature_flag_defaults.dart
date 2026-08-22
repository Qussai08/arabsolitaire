/// Local defaults for Remote Config — never block launch on fetch failure.
abstract final class FeatureFlagDefaults {
  static const Map<String, Object> values = {
    'bootstrap_banner_enabled': false,
    'maintenance_mode': false,
  };
}
