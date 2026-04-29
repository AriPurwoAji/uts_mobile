import 'package:flutter/material.dart';
import '../data/cart_repository.dart';
import '../domain/cart_model.dart';

class CartProvider extends ChangeNotifier {
  final CartRepository _repository;
  CartProvider(this._repository);

  CartModel? _cart;
  bool _isLoading = false;
  String? _error;
  String? _successMessage;

  CartModel? get cart => _cart;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get successMessage => _successMessage;
  int get itemCount => _cart?.itemCount ?? 0;

  Future<void> fetchCart() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _cart = await _repository.getCart();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addToCart(int productId, int quantity) async {
    _isLoading = true;
    _error = null;
    _successMessage = null;
    notifyListeners();

    try {
      _cart = await _repository.addItem(productId, quantity);
      _successMessage = 'Produk ditambahkan ke cart';
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> removeFromCart(int itemId) async {
    try {
      await _repository.removeItem(itemId);
      await fetchCart(); // refresh cart
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }
}