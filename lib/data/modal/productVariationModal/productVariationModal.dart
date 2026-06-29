class ProductVariationModel {
  final String id;
  final String sku;
  final String image;
  final String description;
  final double price;
  final double salePrice;
  final int stock;
  final Map<String, dynamic> attributeValues;
  final String? name; // यहाँ नाम जोड़ दिया गया है

  ProductVariationModel({
    required this.id,
    required this.sku,
    required this.image,
    required this.description,
    required this.price,
    required this.salePrice,
    required this.stock,
    required this.attributeValues,
    this.name, // यहाँ भी सेट करें
  });

  factory ProductVariationModel.fromJson(Map<String, dynamic> json) {
    return ProductVariationModel(
      id: json['id']?.toString() ?? json['_id']?.toString() ?? '',
      sku: json['sku']?.toString() ?? '',
      image: json['image']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      salePrice: (json['salePrice'] as num?)?.toDouble() ?? 0.0,
      stock: json['stock'] is int ? json['stock'] : (int.tryParse(json['stock']?.toString() ?? '0') ?? 0),
      attributeValues: json['attributeValues'] is Map
          ? Map<String, dynamic>.from(json['attributeValues'])
          : {},
      name: json['name']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sku': sku,
      'image': image,
      'description': description,
      'price': price,
      'salePrice': salePrice,
      'stock': stock,
      'attributeValues': attributeValues,
      'name': name, // यहाँ भी जोड़ें
    };
  }
}