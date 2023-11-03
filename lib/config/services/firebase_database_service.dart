import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore dataBase = FirebaseFirestore.instance;

Future<void> saveProduct(String name, String price, String imageUrl) async {
  try {
    await dataBase
        .collection('productos')
        .add({'name': name, 'price': price, 'imageUrl': imageUrl});
  } catch (e) {
    print('Error al enviar informacion bd ... $e');
  }
}


