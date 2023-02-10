import 'package:flutter/material.dart';
import '../widgets/bottom_navigation_bar.dart';
import 'users_screen.dart';
import 'charts_screen.dart';
import 'products_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 2;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: [
        UsersScreen(),
        ChartsScreen(),
        ProductsScreen(),
      ][_selectedIndex],
      bottomNavigationBar: BottomNavigationBarWidget(
        key: Key("bottom_navigation_bar"),
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
