import 'package:login/screens/cart.screen.dart';
import 'package:login/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:login/screens/product_list_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

// import '../services/auth_service.dart';
// import 'login_screen.dart';
// import 'product_list_screen.dart';

class HomeScreen extends StatelessWidget {
  final dynamic userData;
  final GoogleSignIn googleSignIn = GoogleSignIn();

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
            icon: Icon(Icons.logout),
            onPressed: () async {
              final googleSignIn = GoogleSignIn();
              await googleSignIn.signOut(); // Cierra sesión en Google
              await FirebaseAuth.instance
                  .signOut(); // Cierra sesión en Firebase

              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => LoginScreen()),
                (route) => false,
              );
            },
          ),
        ],
      ),

      body: ProductListScreen(),
    );
  }
}
