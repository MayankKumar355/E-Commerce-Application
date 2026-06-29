class CartModal {
  String productId;
  int quantity;
  String? title;
  String? image;
  double? price;
  String? brandName;
  // इसे List से बदलकर Map किया ताकि कोड में .variationId और .id काम कर सके
  Map<String, dynamic>? selectedVariation;

  CartModal({
    required this.productId,
    required this.quantity,
    this.title,
    this.image,
    this.price,
    this.brandName,
    this.selectedVariation,
  });

  factory CartModal.fromJson(Map<String, dynamic> json) {
    return CartModal(
      productId: json['productId'] ?? '',
      quantity: json['quantity'] ?? 0,
      title: json['title'],
      image: json['image'],
      price: (json['price'] != null) ? (json['price'] as num).toDouble() : 0.0,
      brandName: json['brandName'],
      selectedVariation: json['selectedVariation'] != null
          ? Map<String, dynamic>.from(json['selectedVariation'])
          : null,
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'quantity': quantity,
      'title': title,
      'image': image,
      'price': price,
      'brandName': brandName,
      'selectedVariation': selectedVariation,
    };
  }
}
