import 'package:dio/dio.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/services/dio_clients.dart';
import '../domain/cart_model.dart';

class CartRepository {
  final DioClient _dioClient;
  CartRepository(this._dioClient);

  Future<CartModel> getCart() async {
    try {
      final response = await Dio().get(ApiConstants.cart);
      return CartModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Gagal memuat cart');
    }
  }

  Future<CartModel> addItem(int productId, int quantity) async {
    try {
      final response = await Dio().post(
        ApiConstants.cartItems,
        data: {'product_id': productId, 'quantity': quantity},
      );
      return CartModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Gagal menambah item');
    }
  }

  Future<void> removeItem(int itemId) async {
    try {
      await Dio().delete(ApiConstants.cartItemById(itemId));
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Gagal menghapus item');
    }
  }
}