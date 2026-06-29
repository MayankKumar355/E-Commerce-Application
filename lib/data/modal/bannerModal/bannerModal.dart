class BannerModel {
  final String id;
  final String imageUrl;
  final String targetScreen;
  final bool isActive;

  BannerModel({
    required this.id,
    required this.imageUrl,
    required this.targetScreen,
    required this.isActive,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    // MongoDB ka _id text format me lane ke liye safe string convert
    String parsedId = '';
    if (json['_id'] != null) {
      if (json['_id'] is Map) {
        parsedId = json['_id']['\$oid']?.toString() ?? '';
      } else {
        parsedId = json['_id'].toString();
      }
    }

    // URL safe checking (Website link ko actual sample image me badalna)
    String imgUrl = json['imageUrl'] ?? '';
    if (imgUrl == "https://unsplash.com" || imgUrl.isEmpty) {
      imgUrl = "https://picsum.photos{parsedId.hashCode}";
    }

    return BannerModel(
      id: parsedId,
      imageUrl: imgUrl,
      targetScreen: json['targetScreen']?.toString() ?? 'Clothes',
      isActive: json['isActive'] is bool ? json['isActive'] : true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'imageUrl': imageUrl,
      'targetScreen': targetScreen,
      'isActive': isActive,
    };
  }
}
