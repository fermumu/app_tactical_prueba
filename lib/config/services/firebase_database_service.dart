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

    final product = ProductosModel(docId: docId,name: name, image: imageUrl, price: price);
    products.add(product);
  });

  return products;
}

Future<void> updateProduct(String docId, String name, double price, String imagePath) async {
  try {
    // 1. Obtener el documento existente
    DocumentSnapshot docSnapshot = await dataBase.collection('productos').doc(docId).get();

    // 2. Verificar la existencia de campos
    if (docSnapshot.exists) {
      // 3. Actualizar los campos existentes y manejar la imagen si es necesario
      final Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;

      String currentImageUrl = data.containsKey('imageUrl') ? data['imageUrl'] : '';
      final String currentName = data.containsKey('name') ? data['name'] : '';
      final double currentPrice = data.containsKey('price') ? (data['price'] as num).toDouble() : 0.0;

      if (imagePath != null) {
        // Subir la nueva imagen y obtener la URL
        File imageFile = File(imagePath);
        final imageFileName = 'product_images/${basename(imageFile.path)}';
        final imageReference = storage.ref().child(imageFileName);
        final uploadTask = imageReference.putFile(imageFile);
        final TaskSnapshot storageTaskSnapshot = await uploadTask;
        currentImageUrl = await storageTaskSnapshot.ref.getDownloadURL();
      }

      // 4. Actualizar los datos en Firestore con la nueva información
      await dataBase.collection('productos').doc(docId).update({
        'name': name.isNotEmpty ? name : currentName,
        'price': price > 0 ? price : currentPrice,
        'imageUrl': currentImageUrl,
      });
    } else {
      print('El documento con ID $docId no existe.');
    }
  } catch (e) {
    print('Error al actualizar información en Firestore: $e');
  }
}




// Future<void> updateProduct(
//     String productId, String name, String price, String imagePath) async {
//   try {
//     // 1. Verificar si hay una nueva imagen para subir
//     if (imagePath != null && imagePath.isNotEmpty) {
//       File imageFile = File(imagePath);

//       // 2. Subir la nueva imagen a Firebase Storage y obtener la URL
//       final imageFileName = 'product_images/${basename(imageFile.path)}';
//       final imageReference = storage.ref().child(imageFileName);
//       final uploadTask = imageReference.putFile(imageFile);
//       final TaskSnapshot storageTaskSnapshot = await uploadTask;
//       final imageUrl = await storageTaskSnapshot.ref.getDownloadURL();

//       // 3. Actualizar los datos en Firestore, incluyendo la nueva URL de la imagen
//       await dataBase.collection('productos').doc(productId).update({
//         'name': name,
//         'price': price,
//         'imageUrl': imageUrl,
//       });
//     } else {
//       // Si no hay una nueva imagen, actualizar solo los otros campos
//       await dataBase.collection('productos').doc(productId).update({
//         'name': name,
//         'price': price,
//       });
//     }
//   } catch (e) {
//     print('Error al actualizar información en Firestore: $e');
//   }
// }
