import 'package:flutter/material.dart';
import 'package:dailynotes/screens/product_list.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
   return MaterialApp(
     home:ProductList(),
   );
  }
  // This widget is the root of your application.
}