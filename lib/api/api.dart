import 'dart:async';
import 'dart:convert';
import 'package:cafeteria/pages/home_page/clases/imagen.dart';
import 'package:http/http.dart' as http;

const baseUrl = "https://picsum.photos/v2";

class Api {
  
  static Future listaImagenes(){
    var url = baseUrl + "/list";
    return http.get(url);
  }

  static Future<List<Imagen>> obtenerImagenes() async{
    var response = await http.get(baseUrl + "/list");
    print("La respuesta es:" + response.statusCode.toString());
    if (response.statusCode == 200) {
      final items = json.decode(response.body) as List;
      // print(items);
      // var list = items['viajes'] as List;
      var imagenes = new List<Imagen>();
      imagenes = items.map((model) => Imagen.fromJson(model)).toList();

      // print("esto es:");
      // print(imagenes);

      return imagenes;
    } else {
      throw Exception('Fallo de conexion');
    }
  }

}