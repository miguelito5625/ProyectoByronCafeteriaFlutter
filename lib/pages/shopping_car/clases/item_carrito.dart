
class ItemCarrito{

  int id;
  String producto;
  String urlImagen;
  double precio;
  int cantidad;
  double subTotal;

  ItemCarrito({this.id, this.producto, this.urlImagen, this.precio, this.cantidad, this.subTotal});

  ItemCarrito.fromJson(Map json)
    : id = json['id'],
      producto = json['producto'],
      urlImagen = json['urlImagen'],
      cantidad = json['cantidad'],
      precio = json['precio'],
      subTotal = json['subTotal'];

      Map toJson(){
        return {
          'id': id,
          'producto': producto,
          'urlImagen': urlImagen,
          'cantidad': cantidad,
          'precio': precio,
          'subTotal': subTotal
        };
      }


}