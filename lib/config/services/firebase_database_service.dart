import 'dart:io';
import 'package:path/path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:apptacticalstore/domain/models/productos_model.dart';
import 'package:firebase_storage/firebase_storage.dart';

FirebaseFirestore dataBase = FirebaseFirestore.instance;
final storage = FirebaseStorage.instance;

Future<void> saveProduct(String name, double price, String imagePath) async {
  try {
    // 1. Crea un objeto File desde la ruta de la imagen
    File imageFile = File(imagePath);

    // 2. Subir la imagen a Firebase Storage y obtener la URL
    final imageFileName =
        'product_images/${basename(imageFile.path)}'; // Nombre de archivo en Storage
    final imageReference = storage.ref().child(imageFileName);
    final uploadTask = imageReference.putFile(imageFile);
    final TaskSnapshot storageTaskSnapshot = await uploadTask;
    final imageUrl = await storageTaskSnapshot.ref.getDownloadURL();

    // 3. Guardar los datos en Firestore, incluyendo la URL de la imagen
    await dataBase.collection('productos').add({
      'name': name,
      'price': price,
      'imageUrl': imageUrl,
    });
  } catch (e) {
    print('Error al enviar información a Firestore: $e');
  }
}

Future<List<ProductosModel>> fetchProductsData() async {
  final List<ProductosModel> products = [];

  QuerySnapshot querySnapshot = await dataBase.collection('productos').get();

  querySnapshot.docs.forEach((doc) {
    final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    final String docId = doc.id;
    final String name = data['name'];
    final double price = data['price'];
    final String imageUrl = data['imageUrl'];

    final product =
        ProductosModel(docId: docId, name: name, image: imageUrl, price: price);
    products.add(product);
  });

  return products;
}

Future<void> updateProduct({
  required String docId,
  required String name,
  required double price,
  required String imagePath,
}) async {
  try {
    // Subir la nueva imagen y obtener la URL
    File imageFile = File(imagePath);
    final imageFileName = 'product_images/${basename(imageFile.path)}';
    final imageReference = storage.ref().child(imageFileName);
    final uploadTask = imageReference.putFile(imageFile);
    final TaskSnapshot storageTaskSnapshot = await uploadTask;
    final imageUrl = await storageTaskSnapshot.ref.getDownloadURL();

    // Actualizar los datos en Firestore con la nueva información
    await dataBase.collection('productos').doc(docId).update({
      'name': name,
      'price': price,
      'imageUrl': imageUrl,
    });
  } catch (e) {
    print('Error al actualizar información en Firestore: $e');
  }
}

Future<void> deleteProduct(String docId, String imagePath) async {
  try {
    // 1. Eliminar el documento de Firestore
    await dataBase.collection('productos').doc(docId).delete();

    // 2. Eliminar la imagen de Firebase Storage
    final imageFileName = 'product_images/${basename(imagePath)}';
    final imageReference = storage.ref().child(imageFileName);
    await imageReference.delete();
  } catch (e) {
    print('Error al eliminar producto: $e');
  }
}
