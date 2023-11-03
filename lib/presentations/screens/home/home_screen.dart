import 'package:apptacticalstore/presentations/screens/products/products_cart.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
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
  List<ProductosModel> _listProductosCart = [];

  @override
  void initState() {
    super.initState();
    _productosDb();
  }

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
                  } else {
                    // Puedes mostrar un mensaje al usuario de que no está autenticado
                    // o redirigirlo a la pantalla de inicio de sesión si lo prefieres.
                  }
                },
              ),
            ],
          ),
        ),
      ),
      body: _vitrinProductos(),
    );
  }

  GridView _vitrinProductos() {
    return GridView.builder(
      padding: const EdgeInsets.all(4.0),
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      itemCount: _productosModel.length,
      itemBuilder: (context, index) {
        final String image = _productosModel[index].image;
        var itemList = _productosModel[index];
        return Card(
          elevation: 4.0,
          child: Stack(
            fit: StackFit.loose,
            alignment: Alignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Image.asset(
                      'assets/images_products/$image',
                      fit: BoxFit.contain,
                    ),
                  ),
                  Text(
                    itemList.name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 20.0),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(
                        height: 25,
                      ),
                      const Text('precio'),
                      Text(itemList.price.toString(),
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      Padding(
                        padding: const EdgeInsets.only(
                          right: 8.0,
                          bottom: 8.0,
                        ),
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: GestureDetector(
                            child: (!_listProductosCart.contains(itemList))
                                ? const Icon(
                                    Icons.shopping_cart,
                                    color: Colors.green,
                                    size: 30,
                                  )
                                : const Icon(
                                    Icons.shopping_cart,
                                    color: Colors.red,
                                    size: 30,
                                  ),
                            onTap: () {
                              setState(() {
                                if (!_listProductosCart.contains(itemList))
                                  _listProductosCart.add(itemList);
                                else
                                  _listProductosCart.remove(itemList);
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
        );
      },
    );
  }

  void _productosDb() {
    var list = <ProductosModel>[
      ProductosModel(
          name: 'Alpha 22', image: 'alpha22Negro.jpg', price: 120.000),
      ProductosModel(
          name: 'Alpha 22', image: 'alpha22Verde.jpg', price: 120.000),
      ProductosModel(
          name: 'Alpha 22', image: 'alpha22Gris.jpg', price: 120.000),
      ProductosModel(
          name: 'Alpha 22', image: 'alpha22Coyote.jpg', price: 120.000),
      ProductosModel(name: 'Alpha 22', image: 'A22GG.jpg', price: 120.000),
      ProductosModel(name: 'Alpha 22', image: 'A22GN.jpg', price: 120.000),
      ProductosModel(name: 'Alpha 22', image: 'A22GV.jpg', price: 120.000),
    ];
    setState(() {
      _productosModel = list;
    });
  }
}
