
class ProductosModel {
  final String name;
  final String image;
  final String? color;
  final double price;
  int quantity;

  ProductosModel(
      {required this.name,
      required this.image,
      this.color,
      required this.price,
      this.quantity = 1});
}
