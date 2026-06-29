import '../productAttributeModal/productAttributeModal.dart';
import '../productVariationModal/productVariationModal.dart';

class ProductModel {
  final String id;
  final String title;
  final int stock;
  final String sku;
  final double price;
  final double salePrice;
  final String thumbnail;
  final bool isFeatured;
  final String? brand;
  final String? brandName;
  final String description;
  final String categoryId;
  final List<String> images;
  final String productType;
  final List<ProductAttributeModel>? productAttributes;
  final List<ProductVariationModel>? productVariations;

  ProductModel({
    required this.id,
    required this.title,
    required this.stock,
    required this.sku,
    required this.price,
    required this.salePrice,
    required this.thumbnail,
    required this.isFeatured,
    this.brand,
    this.brandName,
    required this.description,
    required this.categoryId,
    required this.images,
    required this.productType,
    this.productAttributes,
    this.productVariations,
  });

  int get discountPercentage {
    if (price <= 0 || salePrice <= 0) return 0;
    final discount = ((price - salePrice) / price) * 100;
    return discount.round();
  }

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id']?.toString() ?? json['_id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      stock: json['stock'] is int ? json['stock'] : (int.tryParse(json['stock']?.toString() ?? '0') ?? 0),
      sku: json['sku']?.toString() ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      salePrice: (json['salePrice'] as num?)?.toDouble() ?? 0.0,
      thumbnail: json['thumbnail']?.toString() ?? '',
      isFeatured: json['isFeatured'] is bool ? json['isFeatured'] : false,

      // सुरक्षित ब्रांड पार्सिंग
      brand: json['brand'] is Map<String, dynamic>
          ? json['brand']['_id']?.toString()
          : json['brand']?.toString(),

      brandName: json['brand'] is Map<String, dynamic>
          ? json['brand']['name']?.toString() ?? 'Brand'
          : (json['brandName']?.toString() ?? 'Brand'),

      description: json['description']?.toString() ?? '',
      categoryId: json['categoryId']?.toString() ?? '',
      images: json['images'] is List ? List<String>.from(json['images'].map((x) => x.toString())) : [],
      productType: json['productType']?.toString() ?? 'single',

      productAttributes: json['productAttributes'] != null && json['productAttributes'] is List
          ? List<ProductAttributeModel>.from(json['productAttributes'].map((x) => ProductAttributeModel.fromJson(x)))
          : [],
      productVariations: json['productVariations'] != null && json['productVariations'] is List
          ? List<ProductVariationModel>.from(json['productVariations'].map((x) => ProductVariationModel.fromJson(x)))
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'stock': stock,
      'sku': sku,
      'price': price,
      'salePrice': salePrice,
      'thumbnail': thumbnail,
      'isFeatured': isFeatured,
      'brand': brand,
      'brandName': brandName,
      'description': description,
      'categoryId': categoryId,
      'images': images,
      'productType': productType,
      'productAttributes': productAttributes?.map((x) => x.toJson()).toList(),
      'productVariations': productVariations?.map((x) => x.toJson()).toList(),
    };
  }
}