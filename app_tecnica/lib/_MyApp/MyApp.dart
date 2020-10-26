import 'package:app_tecnica/_MyHome/_MyHome.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        //primarySwatch: Colors.blue,
        primaryColor: Colors.grey,
        primaryColorDark: Colors.black,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            //backgroundBlendMode: BlendMode.modulate,
            //borderRadius: BorderRadius.circular(50.0),
            image: DecorationImage(
                image: AssetImage('assets/grisweb.jpg'), fit: BoxFit.fitWidth)),
        child: MyHomePage(),
      ),
    );
  }
}
