import 'package:cached_network_image/cached_network_image.dart';
import 'package:cafeteria/pages/home_page/clases/imagen.dart';
import 'package:cafeteria/pages/home_page/detalles.dart';
import 'package:cafeteria/pages/shopping_car/clases/item_carrito.dart';
import 'package:flutter/material.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:provider/provider.dart';
import 'package:stepper_touch/stepper_touch.dart';
import '../../providers/provider_test.dart';
import '../../providers/carrito_provider.dart';

class ShoppingCart extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ShoppingCartState();
  }
}

class ShoppingCartState extends State<ShoppingCart> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

        final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();


  String formatearPrecio(String precio) {
    FlutterMoneyFormatter precioFormateado;

    precioFormateado = new FlutterMoneyFormatter(
        amount: double.parse(precio),
        settings: MoneyFormatterSettings(
            symbol: 'Q',
            thousandSeparator: ',',
            decimalSeparator: '.',
            symbolAndNumberSeparator: '',
            fractionDigits: 2,
            compactFormatType: CompactFormatType.short));

    String precioDevuelto = precioFormateado.output.symbolOnLeft;
    return precioDevuelto;
  }

  Widget build(BuildContext context) {
    // var testProvider = Provider.of<TestProvider>(context);
    var carProvider = Provider.of<CarritoProvider>(context);
    carProvider.setIsAddCar(false);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('Carrito'),
              Text(
                'Total: ' + formatearPrecio(carProvider.total.toString()),
                style: TextStyle(fontSize: 16.0),
              )
            ],
          ),
        ),
      ),
      body: Container(
        color: Colors.black12,
        padding: EdgeInsets.all(10.0),
        child: Container(
          padding: EdgeInsets.all(5.0),
          child: RefreshIndicator(
            onRefresh: carProvider.obtenerCarrito,
            child: FutureBuilder<List<ItemCarrito>>(
              key: _refreshIndicatorKey,
              future: carProvider.obtenerCarrito(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.data.length == 0) {
                  return Center(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 300,
                        child: Image.asset('assets/empycart.png'),
                      ),
                      Text(
                        'Carrito vacio',
                        style: TextStyle(
                            fontSize: 20.0,
                            fontFamily: 'RobotoMono',
                            color: Colors.black),
                      )
                    ],
                  ));
                }

                return ListView(
                    children: snapshot.data
                        .map((item) => Card(
                              color: Colors.indigo,
                              child: Container(
                                padding:
                                    EdgeInsets.only(top: 10.0, bottom: 10.0),
                                child: ListTile(
                                  contentPadding: EdgeInsets.only(left: 5.0),
                                    title: Text(
                                      item.producto,
                                      style: TextStyle(
                                        fontSize: 14.0,
                                        color: Colors.white
                                        ),
                                    ),
                                    leading: Hero(
                                      tag: item.id.toString(),
                                      child: CachedNetworkImage(
                                        imageUrl: 'https://fakeimg.pl/200x200/',
                                        placeholder: (context, url) =>
                                            CircularProgressIndicator(),
                                        errorWidget: (context, url, error) =>
                                            new Icon(Icons.error),
                                      ),
                                    ),
                                    trailing: IconButton(
                                      icon: Icon(Icons.delete),
                                      color: Colors.white,
                                      onPressed: (){
                                        carProvider.eliminarItemCarrito(item.id);
                                        _scaffoldKey.currentState
                                              .showSnackBar(SnackBar(
                                            content: Text(
                                                'Platillo eliminado ✗',
                                                style: TextStyle(
                                                    fontSize: 14.0,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            duration:
                                                Duration(milliseconds: 1500),
                                            backgroundColor: Colors.red,
                                          ));
                                      },
                                    ),
                                    subtitle: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          'precio: ' +
                                              formatearPrecio(
                                                  item.precio.toString()),
                                          style: TextStyle(
                                            fontSize: 12.0,
                                            color: Colors.white),
                                        ),
                                        Text(
                                          'cantidad: ' +
                                              item.cantidad.toString(),
                                          style: TextStyle(
                                            fontSize: 12.0,
                                            color: Colors.white),
                                        ),
                                        Text(
                                          'sub-total: ' +
                                              formatearPrecio(
                                                  item.subTotal.toString()),
                                          style: TextStyle(
                                            fontSize: 12.0,
                                            color: Colors.white
                                            ),
                                        ),
                                      ],
                                    ),
                                    onTap: () async{
                                      final resultRoute = await Navigator.push(
                                        context,
                                        PageRouteBuilder(
                                            transitionDuration:
                                                Duration(milliseconds: 1200),
                                            pageBuilder: (_, __, ___) =>
                                                DetalleProducto(
                                                  imagen: Imagen(id: item.id.toString(), author: item.producto, 
                                                  download_url: item.urlImagen, height: 0, width: int.parse(item.precio.toStringAsFixed(0)), url: '', ),
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
                              ),
                            ))
                        .toList());
              },
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.save),
        label: Text('Pedir'),
        onPressed: (){
          
        },
      ),
    );
  }
}
