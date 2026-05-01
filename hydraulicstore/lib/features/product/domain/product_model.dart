class ProductModel {
  final int id;
  final String name;
  final String description;
  final double price;
  final int stock;
  final int categoryId;
  final String brand;
  final String partNumber;
  final String imageUrl;
  final bool isActive;
  final String flowRate;
  final String maxPressure;
  final String mountType;
  final String condition;
  final String shaftType;
  final String portingType;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.stock,
    required this.categoryId,
    required this.brand,
    required this.partNumber,
    required this.imageUrl,
    required this.isActive,
    required this.flowRate,
    required this.maxPressure,
    required this.mountType,
    required this.condition,
    required this.shaftType,
    required this.portingType,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
  id:          (json['id'] ?? 0) as int,        
  name:        json['name'] ?? '',
  description: json['description'] ?? '',
  price:       (json['price'] ?? 0).toDouble(),
  stock:       (json['stock'] ?? 0) as int,    
  categoryId:  (json['category_id'] ?? 0) as int,
  brand:       json['brand'] ?? '',
  partNumber:  json['part_number'] ?? '',
  imageUrl:    json['image_url'] ?? '',
  isActive:    json['is_active'] ?? true,
  flowRate:    json['flow_rate'] ?? '',
  maxPressure: json['max_pressure'] ?? '',
  mountType:   json['mount_type'] ?? '',
  condition:   json['condition'] ?? 'New',
  shaftType:   json['shaft_type'] ?? '',
  portingType: json['porting_type'] ?? '',
);

  // Format harga ke Rupiah
  String get formattedPrice {
    return '\$${price.toStringAsFixed(0)}';
  }
}