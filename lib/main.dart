import 'package:flutter/material.dart';
import 'package:pos_aplication/home_page.dart';
import 'package:provider/provider.dart';
import 'package:pos_aplication/cart_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
          useMaterial3: true,
        ),
        home: Provider(
          create: (context) => "CartProvider()",
          child: const HomePage(),
        ),
      ),
    );
  }
}
