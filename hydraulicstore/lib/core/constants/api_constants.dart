class ApiConstants {
  // Ganti dengan IP address komputer kamu
  // Cek IP dengan command: ipconfig
  static const String baseUrl = 'http://192.168.0.123:8080/v1';

  // Auth endpoints
  static const String verifyToken = '/auth/verify-token';

  // Product endpoints
  static const String products = '/products';

  // Timeout
  static const int connectTimeout = 15000;
  static const int receiveTimeout = 15000;
}