import 'package:flutter/material.dart';
import '../../data/product_repository_impl.dart';

enum ProductStatus { initial, loading, loaded, error }

class ProductProvider extends ChangeNotifier {
  final ProductRepositoryImpl _productRepo = ProductRepositoryImpl();

  ProductStatus _status = ProductStatus.initial;
  List<Map<String, dynamic>> _products = [];
  String _errorMessage = '';

  ProductStatus get status => _status;
  List<Map<String, dynamic>> get products => _products;
  String get errorMessage => _errorMessage;

  Future<void> fetchProducts({String category = ''}) async {
    _status = ProductStatus.loading;
    notifyListeners();

    try {
      _products = await _productRepo.getProducts(category: category);
      _status = ProductStatus.loaded;
      notifyListeners();
    } catch (e) {
      _status = ProductStatus.error;
      _errorMessage = 'Gagal memuat produk. Coba lagi.';
      notifyListeners();
    }
  }
}