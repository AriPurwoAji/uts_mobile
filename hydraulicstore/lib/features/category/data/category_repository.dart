import 'package:dio/dio.dart';
import '../../../core/constants/api_constants.dart';
import '../domain/category_model.dart';

class CategoryRepository {
  final Dio dio;
  CategoryRepository(this.dio);

  Future<List<CategoryModel>> getCategories() async {
    try {
      final response = await dio.get(ApiConstants.categories);
      final List data = response.data['data'];
      return data.map((e) => CategoryModel.fromJson(e)).toList();
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Gagal memuat kategori');
    }
  }
}