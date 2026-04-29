class CategoryModel {
  final int id;
  final String name;
  final String slug;
  final String iconUrl;

  CategoryModel({
    required this.id,
    required this.name,
    required this.slug,
    required this.iconUrl,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
    id:      json['id'],
    name:    json['name'],
    slug:    json['slug'],
    iconUrl: json['icon_url'] ?? '',
  );
}