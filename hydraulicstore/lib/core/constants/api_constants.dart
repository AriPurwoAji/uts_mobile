class ApiConstants {
  static const String baseUrl = 'http://10.123.151.24:8080/v1';

  // ➕ Tambahkan dua baris ini
  static const int connectTimeout = 5000;
  static const int receiveTimeout = 5000;

  // Auth
  static const String verifyToken = '/auth/verify-token';

  // Categories
  static const String categories = '/categories';

  // Products
  static const String products = '/products';
  static String productById(int id) => '/products/$id';

  // Cart
  static const String cart = '/cart';
  static const String cartItems = '/cart/items';
  static String cartItemById(int id) => '/cart/items/$id';

  // Orders
  static const String orders = '/orders';
}