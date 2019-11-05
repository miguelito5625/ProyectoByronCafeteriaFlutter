import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
// import './providers/provider_test.dart';
import './providers/carrito_provider.dart';
import './pages/home_page/home_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return ChangeNotifierProvider(
      builder: (context)=>CarritoProvider(),
      child: MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        // primaryTextTheme: Typography(platform: TargetPlatform.android).white, 
        // textTheme: Typography(platform: TargetPlatform.android).white,
      ),
      home: MyHomePage(title: 'Cafetería'),
    ),
    );
  }
}


