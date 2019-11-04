import 'package:cafeteria/pages/home_page/clases/imagen.dart';
import 'package:cafeteria/pages/shopping_car/clases/item_carrito.dart';
import 'package:flutter/foundation.dart';

class CarritoProvider with ChangeNotifier {
  double _total = 0.0;
  List<ItemCarrito> _listaCarrito = new List<ItemCarrito>();
  bool _isAddCar = false;

  bool get isAddCar => _isAddCar;

  void setIsAddCar(bool value){
    _isAddCar = value;
    // notifyListeners();
  }

  // set agregarACarrito(Imagen imagen){
  //   _listaCarrito.add(imagen);
  //   _total += imagen.width.toDouble();
  //   notifyListeners();
  // }

  void agregarACarrito(List item) {
    _total = 0.0;
    ItemCarrito itemCarrito = new ItemCarrito(
        id: int.parse(item[0]),
        producto: item[1],
        urlImagen: item[2],
        precio: item[3],
        cantidad: item[4],
        subTotal: item[5]);

    int index = 0;
    for (final itemPedido in _listaCarrito) {
      if (itemPedido.id == itemCarrito.id) {
        // print('esta en el carrito, index= ' + index.toString());
        _listaCarrito[index] = itemCarrito;
        // _total += itemCarrito.subTotal;
        for (final itemPedido2 in _listaCarrito) {
          _total += itemPedido2.subTotal;
          // print('el total es:' + _total.toString());
        }
        notifyListeners();
        return;
      }

      index++;
    }

    // print('paso la validacion');
    _listaCarrito.add(itemCarrito);

    for (final itemPedido in _listaCarrito) {
      _total += itemPedido.subTotal;
    }

    notifyListeners();
  }

  void eliminarItemCarrito(int id){
    _listaCarrito.removeWhere((item) => item.id == id);
    _total = 0.0;
    for (final itemPedido in _listaCarrito) {
      _total += itemPedido.subTotal;
    }
    notifyListeners();
  }

  List<ItemCarrito> get listaCarrito => _listaCarrito;

  double get total => _total;

  Future<List<ItemCarrito>> obtenerCarrito() async {
    return _listaCarrito;
  }

  void actualizarCantidadItemCarrito(
      ItemCarrito itemCarritoBuscar, int cantidadNueva) {
    _total = 0.0;
    for (final items in _listaCarrito) {
      int index = 0;
      if (items.id == itemCarritoBuscar.id) {
        _listaCarrito[index].cantidad = cantidadNueva;
        _listaCarrito[index].subTotal =
            cantidadNueva * itemCarritoBuscar.precio;
        index++;
      }
      _total += items.subTotal;
    }
  }

  void reconstruir() {
    notifyListeners();
  }
}
