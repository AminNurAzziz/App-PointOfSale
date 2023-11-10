import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:pos_aplication/Services/CardProvider.dart';
import 'package:pos_aplication/Services/User.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool rememberMe = false;
  bool isPasswordVisible = false;

  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  Future<void> login() async {
    User user = User(
      username: usernameController.text,
      password: passwordController.text,
    );
    UserService userService = UserService();

    try {
      final result = await userService.login(user);

      if (result['success']) {
        final token = result['data']["loginResult"]["token"];
        Provider.of<CartProvider>(context, listen: false).setToken(token);
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Success'),
            content: const Text('Login successful!'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Tutup dialog
                  Navigator.pushNamed(context, '/homePage');
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      } else {
        _showErrorDialog(result['errorMessage']);
      }
    } catch (e) {
      _showErrorDialog(e.toString());
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.primary,
              Color.fromARGB(255, 255, 255, 255)
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 340,
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'FINANCE \n APP',
                        style: GoogleFonts.lato(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      // SizedBox(height: 20),
                      // Image.asset(
                      //   'assets/images/Banner.png',
                      //   height: 180,
                      // ),
                    ],
                  ),
                ),
                // Container Login
                Container(
                  padding: EdgeInsets.all(20.0),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(30.0),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      SizedBox.fromSize(size: Size(0, 5)),
                      Text(
                        'Please login with your account',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox.fromSize(size: Size(0, 20)),
                      Text(
                        'Username',
                        style: TextStyle(
                          fontSize: 18,
                          color: const Color.fromARGB(255, 71, 73, 77),
                        ),
                      ),
                      TextField(
                        controller: usernameController,
                        decoration: InputDecoration(
                          suffixIcon: Icon(Icons.check), // Checkmark icon
                          suffixIconConstraints: BoxConstraints(
                            maxHeight: 32,
                            maxWidth: 32,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Password',
                        style: TextStyle(
                          fontSize: 18,
                          color: const Color.fromARGB(255, 71, 73, 77),
                        ),
                      ),
                      TextField(
                        controller: passwordController,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: isPasswordVisible
                                ? Icon(Icons.visibility)
                                : Icon(Icons.visibility_off),
                            onPressed: () {
                              setState(() {
                                isPasswordVisible = !isPasswordVisible;
                              });
                            },
                          ),
                          suffixIconConstraints: BoxConstraints(
                            maxHeight: 32,
                            maxWidth: 32,
                          ),
                        ),
                        obscureText:
                            !isPasswordVisible, // Menyembunyikan atau menampilkan password
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Checkbox(
                                value: rememberMe,
                                onChanged: (value) {
                                  setState(() {
                                    rememberMe = value!;
                                  });
                                },
                              ),
                              Text('Remember Me'),
                            ],
                          ),
                          Spacer(), // Spacer pushes elements to the right
                          Text('Forget Password?'),
                        ],
                      ),
                      SizedBox(height: 20),
                      Container(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: login, // Use the login method
                          child: Text(
                            'Login',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            primary: Theme.of(context).colorScheme.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Don't have an account?"),
                          TextButton(
                            onPressed: () {},
                            child: Text('Sign Up'),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
