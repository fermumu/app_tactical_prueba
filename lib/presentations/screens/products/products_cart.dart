import 'package:cached_network_image/cached_network_image.dart';
import 'package:fancy_flutter_dialog/fancy_flutter_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:apptacticalstore/domain/models/productos_model.dart';
import 'package:apptacticalstore/presentations/components/validate_button.dart';
import 'package:url_launcher/url_launcher.dart';

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
            'Total : \$${formatCurrency(valorTotal(_productosCart))} ',
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14.0,
                color: Colors.black),
          )
        ],
      ),
    );
  }

  String formatCurrency(String value) {
    double precio = double.parse(value);
    return NumberFormat.currency(
      locale: 'es_CO',
      symbol: '',
      decimalDigits: 0,
    ).format(precio);
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
        title: const Text(
          'Detalle de productos',
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black),
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
                                  child: SizedBox(
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
                                const SizedBox(
                                  width: 5,
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
                                          width: 125,
                                          height: 40,
                                          decoration: const BoxDecoration(
                                              color: Color.fromARGB(
                                                  224, 33, 32, 32),
                                              boxShadow: [
                                                BoxShadow(
                                                  blurRadius: 8.0,
                                                  color: Color.fromARGB(
                                                      255, 87, 96, 103),
                                                  offset: Offset(0.0, 1.0),
                                                )
                                              ],
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(50.0))),
                                          margin:
                                              const EdgeInsets.only(top: 20),
                                          padding: const EdgeInsets.all(2),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const SizedBox(
                                                height: 5.0,
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
                                                    fontSize: 20,
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
                                  width: 10,
                                ),
                                Text(
                                  formatCurrency(product.price.toString()),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.0,
                                      color: Colors.black),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                      const Divider(
                        color: Color.fromARGB(255, 39, 96, 176),
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
                child: ValidateButton(
                  buttonText: 'Enviar pedido',
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return FancyAlertDialog(
                          title: "TU PEDIDO ESTA LISTO",
                          backgroundColor:
                              const Color.fromARGB(255, 6, 160, 160),
                          message: "¿Deseas continuar con el proceso de pago?",
                          negativeBtnText: "Cancelar",
                          positiveBtnBackground: const Color(0xFFFF4081),
                          positiveBtnText: "Pagar",
                          negativeBtnBackground: const Color(0xFFA9A7A8),
                          onPositiveClicked: () {
                            // Positive button clicked action
                            msgListaPedido();
                          },
                          onNegativeClicked: () {
                            // Negative button clicked action
                            Navigator.of(context).pop();
                          },
                        );
                      },
                    );
                  },
                ),
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
      if (_productosCart[index].quantity > 0) {
        _productosCart[index].quantity--;
      }
    });
  }

  void msgListaPedido() async {
    String pedido = "";
    String fecha = DateTime.now().toString();
    pedido = pedido + "FECHA:" + fecha.toString();
    pedido = pedido + "\n";
    pedido = pedido + "MEGA DESCUENTOS A DOMICILIO";
    pedido = pedido + "\n";
    pedido = pedido + "CLIENTE: FLUTTER - DART";
    pedido = pedido + "\n";
    pedido = pedido + "_____________";

    for (int i = 0; i < _productosCart.length; i++) {
      pedido = '$pedido' +
          "\n" +
          "Producto : " +
          _productosCart[i].name +
          "\n" +
          "Cantidad: " +
          _productosCart[i].quantity.toString() +
          "\n" +
          "Precio : " +
          _productosCart[i].price.toString() +
          "\n" +
          "\_________________________\n";
    }
    pedido = pedido + "TOTAL:" + valorTotal(_productosCart);

    await launchUrl(Uri.parse('https://wa.me/${573185936956}?text=$pedido'));
  }
}
