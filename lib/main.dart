import 'package:flutter/material.dart';
import './screens/products_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ProductsScreen(),
      theme: ThemeData(
        // Define the default brightness and colors.
        brightness: Brightness.dark,
        primaryColor: Colors.lightBlue[800],

        textTheme: const TextTheme(
          bodyMedium: TextStyle(
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
