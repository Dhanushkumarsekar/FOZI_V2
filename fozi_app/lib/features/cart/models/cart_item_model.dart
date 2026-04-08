import '../../product/models/product_model.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem({
    required this.product,
    required this.quantity,
  });

  double get total => product.price * quantity;

  Map<String, dynamic> toJson() {
    return {
      'id': product.id,
      'name': product.name,
      'description': product.description,
      'image': product.image,
      'price': product.price,
      'quantity': quantity,
    };
  }

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      product: Product(
        id: json['id'],
        name: json['name'],
        description: json['description'],
        image: json['image'],
        price: (json['price'] as num).toDouble(),
      ),
      quantity: json['quantity'],
    );
  }
}
