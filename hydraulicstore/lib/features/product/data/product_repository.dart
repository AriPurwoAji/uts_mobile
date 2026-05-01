import 'package:dio/dio.dart';
import '../../../core/constants/api_constants.dart';
import '../domain/product_model.dart';

class ProductRepository {
  final Dio dio;
  ProductRepository(this.dio);

  Future<List<ProductModel>> getProducts({
    int page = 1,
    int limit = 10,
    String? category,
  }) async {
    try {
      final response = await dio.get(
        ApiConstants.products,
        queryParameters: {
          'page': page,
          'limit': limit,
          if (category != null) 'category': category,
        },
      );
      final List data = response.data['data'];
      return data.map((e) => ProductModel.fromJson(e)).toList();
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Gagal memuat produk');
    }
  }

  Future<ProductModel> getProductById(int id) async {
    try {
      final response = await dio.get(ApiConstants.productById(id));
      return ProductModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Produk tidak ditemukan');
    }
  }
}