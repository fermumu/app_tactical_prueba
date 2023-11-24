import 'package:apptacticalstore/presentations/components/header_page.dart';
import 'package:apptacticalstore/presentations/screens/products/favorite_products.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:apptacticalstore/config/services/firebase_database_service.dart';
import 'package:apptacticalstore/presentations/screens/products/products_cart.dart';
import 'package:apptacticalstore/presentations/components/logo2.dart';
import 'package:apptacticalstore/domain/models/productos_model.dart';

class HomeScreen extends StatefulWidget {
  static const name = 'home-page';
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<void> _showLogoutConfirmationDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Cerrar sesión'),
          content: const Text('¿Estás seguro de que deseas cerrar sesión?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Cerrar sesión'),
              onPressed: () {
                context.go('/');
              },
            ),
          ],
        );
      },
    );
  }

  bool isUserLoggedIn() {
    return FirebaseAuth.instance.currentUser != null;
  }

  List<ProductosModel> _productosModel = List<ProductosModel>.empty();
  final List<ProductosModel> _listProductosCart = [];
  final List<ProductosModel> _listProductosFavoritos = [];

  @override
  void initState() {
    super.initState();
    _loadProductsFromFirestore();
  }

  Future<void> _loadProductsFromFirestore() async {
    final products = await fetchProductsData();
    setState(() {
      _productosModel = products;
    });
  }

  String formatCurrency(String value) {
    double precio = double.parse(value);
    return NumberFormat.currency(
      locale: 'es_CO',
      symbol: '',
      decimalDigits: 0,
    ).format(precio);
  }

  final List<String> imagesUrlList = [
    'assets/images_promo/PRO.jpg',
    'assets/images_promo/pru.jpg',
    'assets/images_company/logo2.jpg',
  ];

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          Padding(
            padding: const EdgeInsets.only(
              right: 16.0,
              top: 8.0,
            ),
            child: GestureDetector(
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  const Icon(
                    Icons.shopping_cart,
                    size: 30,
                  ),
                  if (_listProductosCart.length > 0)
                    Padding(
                      padding: const EdgeInsets.only(left: 2.0),
                      child: CircleAvatar(
                        radius: 8.0,
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        child: Text(
                          _listProductosCart.length.toString(),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 12.0),
                        ),
                      ),
                    ),
                ],
              ),
              onTap: () {
                if (_listProductosCart.isNotEmpty) {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ProductsCart(_listProductosCart),
                  ));
                }
              },
            ),
          )
        ],
      ),
      drawer: SizedBox(
        width: 250,
        child: Drawer(
          backgroundColor: Colors.grey.shade800,
          child: ListView(
            children: [
              DrawerHeader(
                decoration: const BoxDecoration(color: Colors.white),
                child: imageLogo2(height: 10, width: 10),
              ),
              ListTile(
                trailing: const Icon(
                  Icons.add_business,
                  color: Colors.white,
                ),
                title: const Text(
                  'Crear nuevo producto',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                onTap: () {
                  context.go('/crear-producto');
                },
              ),

              ListTile(
                trailing: const Icon(
                  Icons.settings,
                  color: Colors.white,
                ),
                title: const Text(
                  'Adminitrar productos',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                onTap: () {
                  context.go('/admin_products');
                },
              ),
              //todo DESARROLLAR PANTALLA DE FAVORITOS
              ListTile(
                trailing: const Icon(
                  Icons.favorite_border_outlined,
                  color: Colors.white,
                ),
                title: const Text(
                  'Favoritos',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          FavoriteProducts(_listProductosFavoritos),
                    ),
                  );
                },
              ),

              ListTile(
                trailing: const Icon(
                  Icons.shopping_cart_checkout_outlined,
                  color: Colors.white,
                ),
                title: const Text(
                  'Carro de compras',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductsCart(_listProductosCart),
                    ),
                  );
                },
              ),
              ListTile(
                trailing: const Icon(
                  Icons.logout,
                  color: Colors.white,
                ),
                title: const Text(
                  'Cerrar sesion',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                onTap: () {
                  if (isUserLoggedIn()) {
                    _showLogoutConfirmationDialog(context);
                  } else {}
                },
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                const WaveClip(),
                Container(
                  padding: const EdgeInsets.only(left: 10, top: 15),
                  height: 180,
                  child: ListView.builder(
                    itemCount: imagesUrlList.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return Row(
                        children: [
                          Container(
                            height: 300,
                            padding: const EdgeInsets.only(left: 5, bottom: 20),
                            child: Card(
                              shadowColor: Colors.green,
                              elevation: 10.0,
                              clipBehavior: Clip.antiAlias,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              child: AspectRatio(
                                aspectRatio: 2,
                                child: Image.asset(
                                  imagesUrlList[index],
                                ),
                              ),
                            ),
                          )
                        ],
                      );
                    },
                  ),
                )
              ],
            ),
            Container(
              height: 5,
              color: Colors.grey,
            ),
            const SizedBox(
              height: 5,
            ),
            Container(
                color: Colors.grey.shade300,
                height: MediaQuery.of(context).size.height / 1.5,
                child: GridView.builder(
                    padding: const EdgeInsets.all(4.0),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2),
                    itemCount: _productosModel.length,
                    itemBuilder: (context, index) {
                      final product = _productosModel[index];
                      final imageUrl = product.image;
                      return Card(
                          elevation: 4.0,
                          child: Column(
                            children: [
                              Stack(
                                fit: StackFit.loose,
                                alignment: Alignment.center,
                                children: [
                                  Positioned(
                                      top: -6,
                                      right: -6,
                                      child: IconButton(
                                        icon: (!_listProductosFavoritos
                                                .contains(product))
                                            ? const Icon(Icons.favorite_border,
                                                color: Colors.grey)
                                            : const Icon(Icons.favorite,
                                                color: Colors.red),
                                        onPressed: () {
                                          setState(() {
                                            if (!_listProductosFavoritos
                                                .contains(product)) {
                                              _listProductosFavoritos
                                                  .add(product);
                                            } else {
                                              _listProductosFavoritos
                                                  .remove(product);
                                            }
                                          });
                                        },
                                      )),
                                  Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      SizedBox(
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
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 5),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              product.name,
                                              style: const TextStyle(
                                                  fontSize: 20.0),
                                            ),
                                            const Row(
                                              children: [
                                                Icon(
                                                  Icons.star,
                                                  color: Colors.yellow,
                                                ),
                                                Text(
                                                  '4.2',
                                                  style: TextStyle(
                                                      color: Colors.grey),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                              '\$ ${formatCurrency(product.price.toString())}',
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                          const SizedBox(
                                            width: 60,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              right: 8.0,
                                              bottom: 8.0,
                                            ),
                                            child: Align(
                                              alignment: Alignment.bottomRight,
                                              child: GestureDetector(
                                                child: (!_listProductosCart
                                                        .contains(product))
                                                    ? const Icon(
                                                        Icons.shopping_cart,
                                                        color: Colors.green,
                                                        size: 20,
                                                      )
                                                    : const Icon(
                                                        Icons.shopping_cart,
                                                        color: Colors.red,
                                                        size: 20,
                                                      ),
                                                onTap: () {
                                                  setState(() {
                                                    if (!_listProductosCart
                                                        .contains(product)) {
                                                      _listProductosCart
                                                          .add(product);
                                                    } else {
                                                      _listProductosCart
                                                          .remove(product);
                                                    }
                                                  });
                                                },
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ],
                          ));
                    }))
          ],
        ),
      )),
    );
  }
}
