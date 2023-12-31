import 'dart:async';

import 'package:apptacticalstore/config/services/firebase_database_service.dart';
import 'package:apptacticalstore/domain/models/productos_model.dart';
import 'package:apptacticalstore/presentations/screens/products/edit_products.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class AdminProducts extends StatefulWidget {
  static const name = 'admin_products';
  const AdminProducts({super.key});

  @override
  State<AdminProducts> createState() => _AdminProductsState();
}

class _AdminProductsState extends State<AdminProducts> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Administrador de productos'),
          leading: IconButton(
              onPressed: () {
                context.go('/home-page');
              },
              icon: const Icon(
                Icons.arrow_back,
              )),
          backgroundColor: const Color.fromARGB(255, 121, 119, 119)),
      body: _CardsProducts(),
    );
  }
}

class _CardsProducts extends StatefulWidget {
  @override
  State<_CardsProducts> createState() => __CardsProductsState();
}

class __CardsProductsState extends State<_CardsProducts> {
  bool productoEliminado = false;
  List<ProductosModel> _productosModel = List<ProductosModel>.empty();

  Future<void> _loadProductsFromFirestore() async {
    final products = await fetchProductsData();
    setState(() {
      _productosModel = products;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadProductsFromFirestore();
  }

  String formatCurrency(String value) {
    double precio = double.parse(value);
    return NumberFormat.currency(
      locale: 'es_CO',
      symbol: '',
      decimalDigits: 0,
    ).format(precio);
  }

  Future<bool> _showDeleteConfirmationDialog(BuildContext context) async {
    Completer<bool> completer = Completer<bool>();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('ELIMINAR PRODUCTO',
              style: TextStyle(
                color: Colors.red,
              )),
          content:
              const Text('¿Estás seguro de que deseas eliminar este producto?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
                completer.complete(false);
              },
            ),
            TextButton(
              child: const Text('Eliminar'),
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el diálogo
                completer.complete(true);
              },
            ),
          ],
        );
      },
    );
    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _productosModel.length,
              itemBuilder: (context, index) {
                final product = _productosModel[index];
                final imageUrl = product.image;
                return Card(
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      side: BorderSide(color: Colors.grey)),
                  elevation: 5.0,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Stack(
                          fit: StackFit.loose,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                SizedBox(
                                  width: 110,
                                  height: 110,
                                  child: CachedNetworkImage(
                                    imageUrl: imageUrl,
                                    fit: BoxFit.contain,
                                    placeholder: (_, __) {
                                      return const Center(
                                        child: CupertinoActivityIndicator(
                                          radius: 15,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                SizedBox(
                                  height: 110,
                                  child: Padding(
                                    padding: const EdgeInsets.all(25.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          product.name,
                                          textAlign: TextAlign.center,
                                          style:
                                              const TextStyle(fontSize: 20.0),
                                        ),
                                        Text(
                                          formatCurrency(
                                              product.price.toString()),
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 110,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      IconButton(
                                          onPressed: () async {
                                            // Llamar a la función de mostrar el diálogo de confirmación
                                            bool confirmDelete =
                                                await _showDeleteConfirmationDialog(
                                                    context);

                                            // Si el usuario confirma la eliminación, entonces eliminar el producto
                                            if (confirmDelete == true) {
                                              await deleteProduct(
                                                  product.docId, product.image);
                                              _loadProductsFromFirestore();
                                            }
                                          },
                                          icon: const Icon(Icons.delete)),
                                      IconButton(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    EditProducts(
                                                        docId: product.docId),
                                              ),
                                            );
                                          },
                                          icon:
                                              const Icon(Icons.edit_document)),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }),
        ],
      ),
    );
  }
}
