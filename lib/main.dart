import 'package:flutter/material.dart';
import './screens/cart_screen.dart';
import './screens/products_screen.dart';
import './screens/user_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => const ProductsScreen(),
        '/user': (context) => const UserScreen(),
        '/cart': (context) => const CartScreen(),
      },
      theme: ThemeData(
        // Define the default brightness and colors.
        brightness: Brightness.dark,
        primaryColor: Colors.lightBlue[800],

        textTheme: const TextTheme(
          bodyMedium: TextStyle(
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
