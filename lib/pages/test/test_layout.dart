import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/carrito_provider.dart';

class TestLayout extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return TestLayoutState();
  }
}

class TestLayoutState extends State<TestLayout>{
  
  Widget build(BuildContext context){
    var carritoProvider = Provider.of<CarritoProvider>(context);
    return Scaffold(
      body: Column(
        children: <Widget>[
          SizedBox(
            height: MediaQuery.of(context).size.height*0.5,
            child: Container(
              color: Colors.indigo,
              child: Row(
                children: <Widget>[
                  SizedBox(
                    width: MediaQuery.of(context).size.width*0.25,
                    child: Container(
                      color: Colors.green,
                    ),
                  ),
                  SizedBox(
                     width: MediaQuery.of(context).size.width*0.25,
                    child: Container(
                      color: Colors.purple,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height*0.5,
            child: Container(
              color: Colors.red,
            ),
          ),
          
        ],
      ),
    );
  }
}