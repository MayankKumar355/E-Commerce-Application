class BrandModel {
  String? id;
  String? name;
  String? image;
  bool? isFeatured;
  int? productCount;

  BrandModel({
    this.id,
    this.name,
    this.image,
    this.isFeatured,
    this.productCount,
  });

  factory BrandModel.fromJson(Map<String, dynamic> json) {
    return BrandModel(
      id: json['id'] ?? json['_id'],
      name: json['name'],
      image: json['image'],
      isFeatured: json['isFeatured'] ?? false,
      productCount: json['productCount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'isFeatured': isFeatured,
      'productCount': productCount,
    };
  }
}
