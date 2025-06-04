import 'package:login/screens/cart.screen.dart';
import 'package:login/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:login/screens/product_list_screen.dart';

// import 'package:firebase_auth/firebase_auth.dart';
// import '../services/auth_service.dart';
// import 'login_screen.dart';
// import 'product_list_screen.dart';

class HomeScreen extends StatelessWidget {
  final dynamic userData;

  HomeScreen({this.userData});

  @override
  Widget build(BuildContext context) {
    final name = userData?['name'] ?? 'Usuario';
    return Scaffold(
      appBar: AppBar(
        title: Text('Bienvenido $name'),

        actions: [
         
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => CartScreen()),
              );
            },
          ),
           IconButton(
            icon: Icon(Icons.login),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => LoginScreen()),
              );
            },
          ),
        ],
      ),
      body: ProductListScreen(),
    );
  }
}
