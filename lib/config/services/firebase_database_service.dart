import 'package:apptacticalstore/domain/models/productos_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore dataBase = FirebaseFirestore.instance;

Future<void> saveProduct(String name, double price, String imageUrl) async {
  try {
    await dataBase
        .collection('productos')
        .add({'name': name, 'price': price, 'imageUrl': imageUrl});
  } catch (e) {
    print('Error al enviar informacion bd ... $e');
  }
}

Future<List<ProductosModel>> fetchProductsData() async {
  final List<ProductosModel> products = [];

  QuerySnapshot querySnapshot = await dataBase.collection('productos').get();

  querySnapshot.docs.forEach((doc) {
    final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    final String name = data['name'];
    final double price = data['price'];
    final String imageUrl = data['imageUrl'];

    final product = ProductosModel(name: name, image: imageUrl, price: price);
    products.add(product);
  });

  return products;
}

