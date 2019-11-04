import 'dart:convert';

import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cafeteria/api/api.dart';
import 'package:cafeteria/pages/home_page/clases/imagen.dart';
import 'package:cafeteria/pages/home_page/detalles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/carrito_provider.dart';
import '../shopping_car/cart.dart';
import 'package:http/http.dart' as http;

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  Future<List<Imagen>> _obtenerImagenes() async {
    // var response = await http.get(baseUrl + "/list");
    // print("La respuesta es:" + response.statusCode.toString());
    // if (response.statusCode == 200) {
    //   final items = json.decode(response.body) as List;
    //   // print(items);
    //   // var list = items['viajes'] as List;
    //   var imagenes = new List<Imagen>();
    //   imagenes = items.map((model) => Imagen.fromJson(model)).toList();

    //   // print("esto es:");
    //   // print(imagenes);

    //   return Api.obtenerImagenes();
    // } else {
    //   throw Exception('Fallo de conexion');
    // }
    return Api.obtenerImagenes();
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var carritoProvider = Provider.of<CarritoProvider>(context);
    // print(carritoProvider.isAddCar);
    // if (carritoProvider.isAddCar) {
    //   _scaffoldKey.currentState.showSnackBar(SnackBar(
    //     content: Text('Carrito actualizado ✅',
    //         style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold)),
    //     duration: Duration(milliseconds: 1500),
    //     backgroundColor: Colors.green,
    //   ));
    //   carritoProvider.setIsAddCar(false);
    // }
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          Container(
              height: 5.0,
              padding: EdgeInsets.only(right: 20.0, top: 12.0),
              child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ShoppingCart()),
                    );
                  },
                  child: Badge(
                    child: Icon(Icons.shopping_cart),
                    badgeContent:
                        Text(carritoProvider.listaCarrito.length.toString()),
                    // Text('0'),
                    badgeColor: Colors.red,
                    animationType: BadgeAnimationType.scale,
                    animationDuration: Duration(milliseconds: 200),
                  )))
        ],
      ),
      body: Column(
        // color: Colors.black12,
        // padding: EdgeInsets.all(5.0),
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 15.0),
                child: Text(
                  'Menú del día',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 28.00,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.7,
            child: Container(
              padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
              child: RefreshIndicator(
                onRefresh: Api.obtenerImagenes,
                child: FutureBuilder<List<Imagen>>(
                  key: _refreshIndicatorKey,
                  future: Api.obtenerImagenes(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                          child: SizedBox(
                        height: 300,
                        child: Image(image: AssetImage('assets/loading.gif')),
                      ));
                    }
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: Container(
                        padding: EdgeInsets.all(15.0),
                        child: ListView(
                            children: snapshot.data
                                .map((imagen) => Container(
                                      padding: EdgeInsets.all(5.0),
                                      child: ListTile(
                                        contentPadding:
                                            EdgeInsets.only(right: 5.0),
                                        title: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              imagen.author,
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                        trailing: Text(
                                          'Q10.00',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        leading: Hero(
                                            tag: imagen.id.toString(),
                                            child: CircleAvatar(
                                              radius: 30.0,
                                              child: ClipOval(
                                                child: CachedNetworkImage(
                                                  imageUrl:
                                                      'https://fakeimg.pl/200x200/',
                                                  placeholder: (context, url) =>
                                                      Image(
                                                    image: AssetImage(
                                                        'assets/loading.gif'),
                                                  ),
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          new Icon(Icons.error),
                                                ),
                                              ),
                                            )),
                                        subtitle: Text(
                                          'id de la imagen es: ' +
                                              imagen.id.toString(),
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 11.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        onTap: () async {
                                          // carritoProvider.agregarACarrito(imagen);

                                          final resultRoute = await Navigator.push(
                                              context,
                                              PageRouteBuilder(
                                                  transitionDuration: Duration(
                                                      milliseconds: 900),
                                                  pageBuilder: (_, __, ___) =>
                                                      DetalleProducto(
                                                        imagen: imagen,
                                                      )));

                                          print(resultRoute);

                                          if(resultRoute == 'carrito-ok'){
                                            _scaffoldKey.currentState
                                              .showSnackBar(SnackBar(
                                            content: Text(
                                                'Carrito actualizado ✅',
                                                style: TextStyle(
                                                    fontSize: 14.0,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            duration:
                                                Duration(milliseconds: 1500),
                                            backgroundColor: Colors.green,
                                          ));
                                          }

                                        },
                                      ),
                                    ))
                                .toList()),
                      ),
                    );
                  },
                ),
              ),
            ),
          )
        ],
      ),
      backgroundColor: Colors.indigo,
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     // testProvider.incrementar();
      //   },
      //   tooltip: 'Increment',
      //   child: Icon(Icons.add),
      // ),
    );
  }
}
