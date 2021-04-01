import 'package:flutter/material.dart';
import 'package:instagram/screens/auth_screen.dart';
import 'constants/material_white.dart';
import 'home_page.dart';

void main(){
 runApp(MyApp());
}

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AuthScreen(),
      // home: HomePage(),
      theme: ThemeData(primarySwatch: white),
    );
  }
}