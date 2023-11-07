class Categories {
  String id;
  String category;
  String image;
  DateTime createdAt;
  Categories({
    required this.id,
    required this.category,
    required this.image,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category': category,
      'image': image,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Categories.fromJson(Map<String, dynamic> json) {
    return Categories(
      id: json['id'] as String,
      category: json['category'] as String,
      image: json['image'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}
