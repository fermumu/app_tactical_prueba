import 'dart:io';
import 'package:apptacticalstore/config/services/firebase_database_service.dart';
import 'package:apptacticalstore/presentations/components/validate_button.dart';
import 'package:apptacticalstore/presentations/screens/products/admin_products.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditProducts extends StatefulWidget {
  static const name = 'edit-products';
  final String docId;
  const EditProducts({super.key, required this.docId});

  @override
  State<EditProducts> createState() => _EditProductsState();
}

class _EditProductsState extends State<EditProducts> {
  TextEditingController editProductName = TextEditingController();
  TextEditingController editProductPrice = TextEditingController();
  String? selectedImage;
  final ImagePicker _imagePicker = ImagePicker();
  bool _sendingData = false;
  String? docId;

  //Selleciona imagen de galeria
  void _selectedImage() async {
    final XFile? pickedImage =
        await _imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        selectedImage = pickedImage.path;
      });
    }
  }

  Future<void> _showConfirmationEditProduct(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(234, 23, 130, 130),
          title: const Text('!!!Pefecto¡¡¡'),
          content: const Text('El producto fue editado con exito'),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'Ok',
                style: TextStyle(color: Color.fromARGB(255, 118, 238, 32)),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AdminProducts(),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    String docId = widget.docId;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar productos'),
        backgroundColor: const Color.fromARGB(255, 169, 222, 138),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AdminProducts(),
              ),
            );
          },
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: _selectedImage,
                child: Container(
                  width: 250,
                  height: 250,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey[200],
                  ),
                  child: selectedImage != null
                      ? ClipOval(
                          child: Image.file(
                            File(selectedImage!),
                            fit: BoxFit.cover,
                            width: 250,
                            height: 250,
                          ),
                        )
                      : const Icon(
                          Icons.add_a_photo,
                          size: 50,
                        ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    TextFormField(
                      controller: editProductName,
                      decoration: const InputDecoration(
                        labelText: 'Nombre del producto',
                      ),
                    ),
                    TextFormField(
                      controller: editProductPrice,
                      decoration: const InputDecoration(
                        labelText: 'Precio',
                      ),
                    ),
                  ],
                ),
              ),
              _sendingData
                  ? const Column(
                      children: [
                        CupertinoActivityIndicator(),
                      ],
                    )
                  : ValidateButton(
                      buttonText: 'Cargar',
                      onPressed: () async {
                        final double price =
                            double.tryParse(editProductPrice.text) ?? 0.0;
                        if (selectedImage != null) {
                          setState(() {
                            _sendingData = true;
                          });

                          await updateProduct(
                              docId: docId,
                              name: editProductName.text,
                              price: price,
                              imagePath: selectedImage!);

                          setState(() {
                            _sendingData = false;
                          });

                          _showConfirmationEditProduct(context);
                        }
                      })
            ],
          ),
        ),
      ),
    );
  }
}
