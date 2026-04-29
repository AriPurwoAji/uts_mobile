class ApiConstants {
  // Ganti sesuai IP lokal kamu saat development
  // Emulator Android pakai: 10.0.2.2
  // Device fisik pakai: IP laptop kamu (cek ipconfig/ifconfig)
  static const String baseUrl = 'http://10.0.2.2:8080/v1';

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