// https://app.quicktype.io

import 'package:teslo_app/features/auth/infraestructure/models/user_response.dart';

class ProductResponse {
    final String id;
    final String title;
    final double price;
    final String description;
    final String slug;
    final int stock;
    final List<String> sizes;
    final String gender;
    final List<String> tags;
    final List<String> images;
    final UserResponse? user;

    ProductResponse({
        required this.id,
        required this.title,
        required this.price,
        required this.description,
        required this.slug,
        required this.stock,
        required this.sizes,
        required this.gender,
        required this.tags,
        required this.images,
        this.user,
    });

    factory ProductResponse.fromJson(Map<String, dynamic> json) => ProductResponse(
        id: json["id"],
        title: json["title"],
        price:double.parse(json["price"].toString()),
        description: json["description"],
        slug: json["slug"],
        stock: json["stock"],
        sizes: List<String>.from(json["sizes"].map((size) => size)),
        gender: json["gender"],
        tags: List<String>.from(json["tags"].map((tag) => tag)),
        images: List<String>.from(json["images"].map((img) => img)),
        user: json['user'] == null ? null : UserResponse.fromJson(json["user"]),
    );
}
