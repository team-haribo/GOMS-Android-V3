enum AppEnv {
  dev('.env.dev'),
  prod('.env.prod');

  const AppEnv(this.fileName);

  final String fileName;

  static AppEnv fromValue(String? value) {
    return switch (value?.toLowerCase().trim()) {
      'prod' || 'production' => AppEnv.prod,
      _ => AppEnv.dev,
    };
  }
}
