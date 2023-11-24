import 'package:apptacticalstore/domain/models/productos_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:animate_do/animate_do.dart';

class FavoriteProducts extends StatefulWidget {
  static const name = 'favorite_product';
  final List<ProductosModel> _favoriteProducts;
  const FavoriteProducts(this._favoriteProducts, {Key? key}) : super(key: key);

  @override
  State<FavoriteProducts> createState() =>
      _FavoriteProductsState(this._favoriteProducts);
}

class _FavoriteProductsState extends State<FavoriteProducts> {
  _FavoriteProductsState(this._favoriteProducts);
  List<ProductosModel> _favoriteProducts;

  String formatCurrency(String value) {
    double precio = double.parse(value);
    return NumberFormat.currency(
      locale: 'es_CO',
      symbol: '',
      decimalDigits: 0,
    ).format(precio);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favoritos'),
        backgroundColor: Colors.grey,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _favoriteProducts.length,
              itemBuilder: (context, index) {
                final product = _favoriteProducts[index];
                final imageUrl = product.image;
                return Card(
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      side: BorderSide(color: Colors.grey)),
                  elevation: 5.0,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Stack(
                          fit: StackFit.loose,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Swing(
                                  duration: const Duration(seconds: 1),
                                  child: SizedBox(
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
                                ),
                                Column(
                                  children: [
                                    ElasticInLeft(
                                      child: Text(
                                        product.name,
                                        style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    FadeInDownBig(
                                      child: Text(
                                        '\$ ${formatCurrency(product.price.toString())}',
                                        style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )
                                  ],
                                )
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
