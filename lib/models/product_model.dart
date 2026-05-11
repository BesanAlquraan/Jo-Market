class ProductModel {

  final String id;
  final String name;
  final String price;
  final String image;
  final String description;
  final String category;
  final bool isFavorite;

  ProductModel({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
    required this.description,
    required this.category,
    required this.isFavorite,
  });

  factory ProductModel.fromJson(
      Map<String, dynamic> json,
      String id,
      ) {

    return ProductModel(
      id: id,
      name: json["name"],
      price: json["price"],
      image: json["image"],
      description: json["description"],
      category: json["category"],
      isFavorite: json["isFavorite"] ?? false,
    );
  }
}