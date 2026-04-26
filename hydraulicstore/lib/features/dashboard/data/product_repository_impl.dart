import '../../../core/services/dio_clients.dart';
import '../../../core/constants/api_constants.dart';

class ProductRepositoryImpl {
  Future<List<Map<String, dynamic>>> getProducts({
    int page = 1,
    int limit = 10,
    String category = '',
  }) async {
    final response = await DioClient.instance.get(
      ApiConstants.products,
      queryParameters: {
        'page': page,
        'limit': limit,
        if (category.isNotEmpty) 'category': category,
      },
    );

    final List data = response.data['data'];
    return data.map((e) => e as Map<String, dynamic>).toList();
  }
}