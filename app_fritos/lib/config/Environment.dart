class Environment {
  // Leemos la variable que pasaremos al compilar, si no existe, usa el localhost por defecto
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:3000/api',
  );
}