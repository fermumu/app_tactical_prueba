import 'dart:io';

import 'package:apptacticalstore/config/services/firebase_database_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:apptacticalstore/presentations/components/validate_button.dart';

class CreateProducts extends StatefulWidget {
  static const name = 'crear-producto';
  const CreateProducts({super.key});

  @override
  State<CreateProducts> createState() => _CreateProductsState();
}

class _CreateProductsState extends State<CreateProducts> {
  TextEditingController productName = TextEditingController();
  TextEditingController productPrice = TextEditingController();
  String? selectedImage;
  final ImagePicker _imagePicker = ImagePicker();

  void _selectedImage() async {
    final XFile? pickedImage =
        await _imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        selectedImage = pickedImage.path;
      });
    }
  }

  Future<void> _showConfirmationSaveProduct(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Cargado'),
          content: const Text('Tu producto fue cargado con exito'),
          actions: <Widget>[
            TextButton(
              child: const Text('Ok'),
              onPressed: () {
                context.go('/home-page');
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear producto'),
        backgroundColor: Colors.grey[800],
        leading: IconButton(
            onPressed: () {
              context.go('/home-page');
            },
            icon: const Icon(Icons.arrow_back)),
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
                      controller: productName,
                      decoration: const InputDecoration(
                        labelText: 'Nombre del producto',
                      ),
                    ),
                    TextFormField(
                      controller: productPrice,
                      decoration: const InputDecoration(
                        labelText: 'Precio',
                      ),
                    ),
                  ],
                ),
              ),
              ValidateButton(
                  buttonText: 'ENVIAR',
                  onPressed: () async {
                    await saveProduct(
                            productName.text, productPrice.text, selectedImage!)
                        .then((_) => {_showConfirmationSaveProduct(context)});
                  })
            ],
          ),
        ),
      ),
    );
  }
}
