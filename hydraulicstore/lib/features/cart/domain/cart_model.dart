class CartItemModel {
  final int id;
  final int cartId;
  final int productId;
  final String productName;
  final String productImage;
  final double price;
  final int quantity;

  CartItemModel({
    required this.id,
    required this.cartId,
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.price,
    required this.quantity,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) => CartItemModel(
    id:           json['id'],
    cartId:       json['cart_id'],
    productId:    json['product_id'],
    productName:  json['product']?['name'] ?? '',
    productImage: json['product']?['image_url'] ?? '',
    price:        (json['price'] ?? 0).toDouble(),
    quantity:     json['quantity'] ?? 1,
  );

  double get subtotal => price * quantity;
}

class CartModel {
  final int id;
  final int userId;
  final List<CartItemModel> items;

  CartModel({
    required this.id,
    required this.userId,
    required this.items,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) => CartModel(
    id:     json['id'],
    userId: json['user_id'],
    items:  (json['items'] as List? ?? [])
                .map((e) => CartItemModel.fromJson(e))
                .toList(),
  );

  double get total => items.fold(0, (sum, item) => sum + item.subtotal);
  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);
}