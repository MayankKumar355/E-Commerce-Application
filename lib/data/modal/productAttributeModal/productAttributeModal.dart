class ProductAttributeModel {
  final String name;
  final List<String> values;

  ProductAttributeModel({
    required this.name,
    required this.values,
  });

  factory ProductAttributeModel.fromJson(Map<String, dynamic> json) {
    return ProductAttributeModel(
      // ज़बरदस्ती स्ट्रिंग में बदलना (ताकि "name" टाइप एरर न आए)
      name: json['name']?.toString() ?? '',
      values: json['values'] is List
          ? List<String>.from(json['values'].map((x) => x.toString()))
          : [],
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'values': values,
  };
}
