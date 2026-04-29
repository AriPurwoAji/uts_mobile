import 'package:flutter/material.dart';
import '../data/product_repository.dart';
import '../domain/product_model.dart';

class ProductProvider extends ChangeNotifier {
  final ProductRepository _repository;
  ProductProvider(this._repository);

  List<ProductModel> _products = [];
  ProductModel? _selectedProduct;
  bool _isLoading = false;
  String? _error;

  List<ProductModel> get products => _products;
  ProductModel? get selectedProduct => _selectedProduct;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Featured = 4 produk pertama
  List<ProductModel> get featuredProducts => _products.take(4).toList();

  Future<void> fetchProducts({String? category}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _products = await _repository.getProducts(category: category);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchProductById(int id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _selectedProduct = await _repository.getProductById(id);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}