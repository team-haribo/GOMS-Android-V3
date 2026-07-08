enum AppEnv {
  dev('assets/env/dev.env'),
  prod('assets/env/prod.env');

  const AppEnv(this.fileName);

  final String fileName;

  static AppEnv fromValue(String? value) {
    return switch (value?.toLowerCase().trim()) {
      'prod' || 'production' => AppEnv.prod,
      _ => AppEnv.dev,
    };
  }
}
