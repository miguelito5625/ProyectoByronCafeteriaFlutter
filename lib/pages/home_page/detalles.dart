import 'package:cached_network_image/cached_network_image.dart';
import 'package:cafeteria/pages/home_page/clases/imagen.dart';
import 'package:cafeteria/pages/home_page/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:provider/provider.dart';
import 'package:stepper_touch/stepper_touch.dart';
import '../../providers/carrito_provider.dart';

class DetalleProducto extends StatefulWidget {
  final Imagen imagen;
  const DetalleProducto({Key key, this.imagen}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return DetalleProductoState(imagen);
  }
}

class DetalleProductoState extends State<DetalleProducto> {
  int cantidadProducto = 1;
  Imagen imagen;
  DetalleProductoState(this.imagen);
  FlutterMoneyFormatter precioFormateado;

  List pedido = new List();

  @override
  void initState() {
    super.initState();

    precioFormateado = new FlutterMoneyFormatter(
        amount: imagen.width.toDouble(),
        settings: MoneyFormatterSettings(
            symbol: 'Q',
            thousandSeparator: ',',
            decimalSeparator: '.',
            symbolAndNumberSeparator: '',
            fractionDigits: 2,
            compactFormatType: CompactFormatType.short));

    pedido.add(imagen.id); // id pos 0
    pedido.add(imagen.author); // producto pos 1
    pedido.add(imagen.download_url); // url imagen pos 2
    pedido.add(imagen.width.toDouble()); // precio pos 3
    pedido.add(cantidadProducto); // cantidad pos 4
    pedido.add(imagen.width.toDouble() * cantidadProducto); //subtotal pos 5

    // for (final p in pedido) {
    //   print(p);
    // }
  }

  Widget build(BuildContext context) {
     var carritoProvider = Provider.of<CarritoProvider>(context);

     for(final item in carritoProvider.listaCarrito){
       
       if(item.id.toString() == imagen.id){
        //  print('Ya esta en le carrito');
         cantidadProducto = item.cantidad;
       }
     }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle producto'),
      ),
      body: Container(
          // The blue background emphasizes that it's a new route.
          color: Colors.white,
          padding: const EdgeInsets.all(10.0),
          alignment: Alignment.topLeft,
          child: ListView(
            children: <Widget>[
              SizedBox(
                height: 350,
                child: Hero(
                tag: widget.imagen.id,
                child: CachedNetworkImage(
                  imageUrl: 'https://fakeimg.pl/400x400/',
                  placeholder: (context, url) => Center(child: Image(image: AssetImage('assets/loading.gif')),),
                  errorWidget: (context, url, error) => new Icon(Icons.error),
                ),
              ),
              ),
              SizedBox(
                height: 5.0,
              ),
              Text(
                'Titulo',
                style: TextStyle(
                    fontSize: 25.0,
                    color: Colors.indigo,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 5.0,
              ),
              Text(
                'Descripcion',
                style: TextStyle(
                  fontSize: 19.0,
                  color: Colors.indigo,
                ),
              ),
              SizedBox(
                height: 5.0,
              ),
              Text(
                'Precio: ' + precioFormateado.output.symbolOnLeft,
                style: TextStyle(
                  fontSize: 19.0,
                  color: Colors.indigo,
                ),
              ),
              // SizedBox(
              //   height: 5.0,
              // ),
              Container(
                padding: EdgeInsets.all(1.0),
                child: Row(
                  children: <Widget>[
                    Text(
                      'Cantidad:     ',
                      style: TextStyle(
                        color: Colors.indigo,
                        fontSize:19.0
                        ),
                    ),
                    SizedBox(
                        width: 75.0,
                        height: 50.0,
                        child: StepperTouch(
                          initialValue: cantidadProducto,
                          onChanged: (int value) {
                            // setState(() {
                            //   cantidadProducto = value;
                            // });
                            cantidadProducto = value;
                            pedido[4] = cantidadProducto;
                            double subTotal = imagen.width.toDouble() * cantidadProducto;
                            pedido[5] = subTotal;
                            
                            for (final p in pedido) {
                              print(p);
                            }
                          },
                        ))
                  ],
                ),
              ),

              SizedBox(
                height: 15.0,
              ),
              Material(
                elevation: 5.0,
                borderRadius: BorderRadius.circular(30.0),
                color: Colors.indigo,
                child: MaterialButton(
                  minWidth: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                  onPressed: () {
                    carritoProvider.agregarACarrito(pedido);
                    carritoProvider.setIsAddCar(true);
                    Navigator.pop(context,
                    'carrito-ok');
                  },
                  child: Text(
                    "Pedir",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            ],
          )
          ),
    );
  }
}
