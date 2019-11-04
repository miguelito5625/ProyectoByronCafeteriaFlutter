import 'dart:convert';

class Imagen {

  String id;
  String author;
  int width;
  int height;
  String url;
  String download_url;

  Imagen({this.id, this.author, this.width, this.height, this.url, this.download_url});

  Imagen.fromJson(Map json)
    : id = json['id'],
      author = json['author'],
      width = json['width'],
      height = json['height'],
      url = json['url'],
      download_url = json['download_url'];

      Map toJson(){
        return {
          'id': id,
          'author': author,
          'width': width,
          'height': height,
          'url': url,
          'download_url': download_url
        };
      }


}