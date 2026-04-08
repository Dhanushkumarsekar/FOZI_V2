// class Product {
//   final String id;
//   final String name;
//   final double price;
//   final String image;
//   final String description;

//   const Product({
//     required this.id,
//     required this.name,
//     required this.price,
//     required this.image,
//     required this.description,
//   });

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'name': name,
//       'price': price,
//       'image': image,
//       'description': description,
//     };
//   }

//   factory Product.fromJson(Map<String, dynamic> json) {
//     return Product(
//       id: json['id'],
//       name: json['name'],
//       price: (json['price'] as num).toDouble(),
//       image: json['image'],
//       description: json['description'],
//     );
//   }
// }



// class Product {
//   final String id;
//   final String name;
//   final String description;
//   final String image;
//   final double price;
//   final bool isOffer;
//   final double rating;
//   final bool isCombo;

//   const Product({
//     required this.id,
//     required this.name,
//     required this.description,
//     required this.image,
//     required this.price,
//     this.isOffer = false,
//     this.rating = 4.5,
//     this.isCombo = false,
//   });
// }




class Product {

  final String id;
  final String name;
  final String description; // ✅ ADD THIS
  final String image;
  final double price;

  const Product({
    required this.id,
    required this.name,
    required this.description, // ✅ ADD
    required this.image,
    required this.price,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['_id'],
      name: json['name'],
      description: json['description'] ?? "", // ✅ FIX
      image: json['image'],
      price: (json['price'] as num).toDouble(),
    );
  }
}
