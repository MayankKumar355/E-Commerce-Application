class CategoryModel {
  final String id;
  final String dbId;
  final String name;
  final String image;
  final bool isFeatured;
  final String? parentId;

  CategoryModel({
    required this.id,
    required this.dbId,
    required this.name,
    required this.image,
    required this.isFeatured,
    this.parentId,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] ?? '',
      dbId: json['_id'] ?? '',
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      isFeatured: json['isFeatured'] ?? false,
      parentId: json['parentId'] != null
          ? (json['parentId'] is Map ? json['parentId']['_id']?.toString() : json['parentId']?.toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      '_id': dbId,
      'name': name,
      'image': image,
      'isFeatured': isFeatured,
      'parentId': parentId,
    };
  }
}
