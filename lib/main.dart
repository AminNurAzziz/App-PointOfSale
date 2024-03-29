import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:pos_aplication/Screen/LoginPage.dart';
import 'package:pos_aplication/Screen/HomePage.dart';
import 'package:pos_aplication/State/ProviderCard.dart';
import 'package:pos_aplication/State/ProviderProducts.dart';
import 'package:pos_aplication/State/ProviderAuth.dart';

import 'theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');
  final newToken = await refreshToken(token);
  runApp(MyApp(token: newToken));
}

Future<String?> refreshToken(String? token) async {
  if (token == null) {
    return null; // Handle the case when there's no token to refresh
  }

  final response = await http.get(
    Uri.parse('http://192.168.178.135:3000/produk'),
    headers: {'Authorization': 'Bearer $token'},
  );

  if (response.statusCode == 200 &&
      json.decode(response.body)['error'] == false) {
    final newToken = token;
    return newToken;
  }
  return null; // Handle errors appropriately
}

class MyApp extends StatelessWidget {
  final String? token;
  const MyApp({Key? key, this.token}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProviderCart()),
        ChangeNotifierProvider(create: (_) => ProviderProduct()),
        ChangeNotifierProvider(create: (_) => ProviderAuth()),
      ],
      child: MaterialApp(
        routes: {
          '/': (context) => token != null ? HomePage() : LoginPage(),
          '/homePage': (context) => HomePage(),
          // '/editProduk': (context) => ProdukEditWidget(),
        },
        initialRoute: '/',
        title: 'Flutter Demo',
        theme: myTheme,
      ),
    );
  }
}
