import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final userController = TextEditingController();
  final passController = TextEditingController();
  String error = '';

  Future<void> loginWithCredentials() async {
    final response = await http.post(
      Uri.parse('https://server-borrar.onrender.com/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': userController.text,
        'password': passController.text,
      }),
    );

    if (!mounted) return;

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => HomeScreen(
            userData: data['user'],
          ),
        ),
      );
    } else {
      setState(() => error = 'Credenciales inválidas');
    }
  }

  Future<void> loginWhithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithCredential(credential);

      final user = userCredential.user;

      if (!mounted) return;

      if (user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => HomeScreen(
              userData: {
                'name': user.displayName ?? 'Sin nombre',
                'email': user.email,
              },
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          error = 'Error al iniciar con Google: $e';
        });
      }
    }
  }

  Future<void> loginWithGithub() async {
    try {
      final githubAuthProvider = GithubAuthProvider();
      githubAuthProvider.addScope('read:user');
      githubAuthProvider.setCustomParameters({'allow_signup': 'false'});

      final userCredential =
          await FirebaseAuth.instance.signInWithProvider(githubAuthProvider);

      final user = userCredential.user;

      if (!mounted) return;

      if (user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => HomeScreen(
              userData: {
                'name': user.displayName ?? 'Sin nombre',
                'email': user.email,
              },
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          error = 'Error al iniciar con GitHub: $e';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color.fromARGB(255, 255, 255, 255), Color.fromARGB(255, 82, 97, 185)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Card(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Iniciar Sesión',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: userController,
                      decoration: const InputDecoration(
                        labelText: 'Correo electrónico',
                        prefixIcon: Icon(Icons.email),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextField(
                      controller: passController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Contraseña',
                        prefixIcon: Icon(Icons.lock),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: loginWithCredentials,
                      icon: const Icon(Icons.login),
                      label: const Text('Ingresar'),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(45),
                        backgroundColor: Colors.indigo,
                        foregroundColor: Colors.white
                      ),
                    ),
                    if (error.isNotEmpty) ...[
                      const SizedBox(height: 15),
                      Text(
                        error,
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                    ],
                    const SizedBox(height: 25),
                    const Text(
                      'O inicia con',
                      style: TextStyle(color: Color.fromARGB(255, 63, 63, 63)),
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          onPressed: loginWhithGoogle,
                          icon: const Icon(FontAwesomeIcons.google),
                          label: const Text('Google'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(255, 249, 165, 165),
                          ),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton.icon(
                          onPressed: loginWithGithub,
                          icon: const Icon(FontAwesomeIcons.github),
                          label: const Text('GitHub'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(221, 62, 59, 59),
                            foregroundColor: const Color.fromARGB(255, 145, 92, 235)
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
