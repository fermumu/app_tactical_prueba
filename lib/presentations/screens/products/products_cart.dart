import 'package:apptacticalstore/domain/models/productos_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fancy_flutter_dialog/fancy_flutter_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProductsCart extends StatefulWidget {
  static const name = 'products-cart';
  final List<ProductosModel> _productosCart;

  const ProductsCart(this._productosCart, {Key? key}) : super(key: key);

  @override
  State<ProductsCart> createState() => _ProductsCartState(this._productosCart);
}

class _ProductsCartState extends State<ProductsCart> {
  _ProductsCartState(this._productosCart);
  final _scrollController = ScrollController();
  var _firstScroll = true;
  bool _enabled = false;

  List<ProductosModel> _productosCart;

  Container pagoTotal(List<ProductosModel> _productosCart) {
    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(left: 120),
      height: 70,
      width: 400,
      color: Colors.grey[400],
      child: Row(
        children: [
          Text(
            'Total : \$${valorTotal(_productosCart)} ',
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14.0,
                color: Colors.black),
          )
        ],
      ),
    );
  }

  String valorTotal(List<ProductosModel> listaProductos) {
    double total = 0.0;
    for (var i = 0; i < listaProductos.length; i++) {
      total = total + listaProductos[i].price * listaProductos[i].quantity;
    }
    return total.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: const [
          IconButton(
            onPressed: null,
            icon: Icon(Icons.store_outlined),
            color: Colors.white,
          )
        ],
        title: const Text(
          'Detalle',
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
            setState(() {
              _productosCart.length;
            });
          },
          icon: const Icon(Icons.arrow_back),
          color: Colors.white,
        ),
        backgroundColor: Colors.transparent,
      ),
      body: GestureDetector(
        onVerticalDragUpdate: (details) {
          if (_enabled && _firstScroll) {
            _scrollController
                .jumpTo(_scrollController.position.pixels - details.delta.dy);
          }
        },
        onVerticalDragEnd: (_) {
          if (_enabled) _firstScroll = false;
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _productosCart.length,
                itemBuilder: (context, index) {
                  final String imagen = _productosCart[index].image;
                  var item = _productosCart[index];
                  final product = _productosCart[index];
                  final imageUrl = product.image;
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 2.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    width: 100,
                                    height: 100,
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
                                ),
                                Column(
                                  children: [
                                    Text(
                                      product.name,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: Colors.black),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: 120,
                                          height: 40,
                                          decoration: BoxDecoration(
                                              color: Colors.red[600],
                                              boxShadow: [
                                                BoxShadow(
                                                  blurRadius: 6.0,
                                                  color: Colors.blue.shade400,
                                                  offset:
                                                      const Offset(0.0, 1.0),
                                                )
                                              ],
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(50.0))),
                                          margin:
                                              const EdgeInsets.only(top: 20),
                                          padding: const EdgeInsets.all(2),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const SizedBox(
                                                height: 8.0,
                                              ),
                                              IconButton(
                                                onPressed: () {
                                                  _removeProduct(index);
                                                  valorTotal(_productosCart);
                                                },
                                                icon: const Icon(Icons.remove),
                                                color: Colors.yellow,
                                              ),
                                              Text(
                                                '${_productosCart[index].quantity}',
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 22,
                                                    color: Colors.white),
                                              ),
                                              IconButton(
                                                onPressed: () {
                                                  _addProduct(index);
                                                  valorTotal(_productosCart);
                                                },
                                                icon: const Icon(Icons.add),
                                                color: Colors.yellow,
                                              ),
                                              const SizedBox(
                                                height: 8.0,
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  width: 38,
                                ),
                                Text(
                                  product.price.toString(),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24.0,
                                      color: Colors.black),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                      const Divider(
                        color: Colors.purple,
                      )
                    ],
                  );
                },
              ),
              const SizedBox(
                width: 10.0,
              ),
              pagoTotal(_productosCart),
              const SizedBox(
                width: 20.0,
              ),
              Container(
                height: 100,
                width: 200,
                padding: const EdgeInsets.only(top: 50),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20)))),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return FancyAlertDialog(
                            title: "¿ACEPTAS REALIZAR EL PAGO?",
                            backgroundColor: const Color(0xFF303F9F),
                            message: "Do you really want to Exit ?",
                            negativeBtnText: "Cancel",
                            positiveBtnBackground: const Color(0xFFFF4081),
                            positiveBtnText: "Rate",
                            negativeBtnBackground: const Color(0xFFA9A7A8),
                            onPositiveClicked: () {
                              // Positive button clicked action
                              print("Rate");
                            },
                            onNegativeClicked: () {
                              // Negative button clicked action
                              print("Cancel");
                            },
                          );
                        },
                      );
                    },
                    child: const Text('PAGAR')),
              )
            ],
          ),
        ),
      ),
    );
  }

  _addProduct(int index) {
    setState(() {
      _productosCart[index].quantity++;
    });
  }

  _removeProduct(int index) {
    setState(() {
      _productosCart[index].quantity--;
    });
  }
}
