import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pos_aplication/Widget/ListProducts.dart';
import 'package:pos_aplication/Screen/ProdukFormWidget.dart';
import 'package:pos_aplication/theme.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: myTheme.colorScheme.primary,
        title: Text(
          'POS Aplication',
          style: myTheme.textTheme.headline6,
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.shopping_cart),
          ),
        ],
        iconTheme: IconThemeData(
            color: Colors.white), // Mengatur warna untuk semua ikon di AppBar
      ),
      drawer: Drawer(
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(top: 30),
                    height: 100,
                    decoration: BoxDecoration(
                      color: myTheme.colorScheme.primary,
                    ),
                    child: Text(
                      'Menu',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                  ),
                  ListTile(
                    title: Text('Kasir'),
                    leading: Icon(Icons.monetization_on),
                    onTap: () {
                      setState(() {
                        _currentIndex = 0;
                      });
                    },
                  ),
                  ListTile(
                    title: Text('Tambah Menu'),
                    leading: Icon(Icons.add_box),
                    onTap: () {
                      setState(() {
                        _currentIndex = 1;
                      });
                    },
                  ),
                  // ... Other ListTiles
                ],
              ),
            ),
            Container(
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: FaIcon(FontAwesomeIcons.twitter,
                        color: Colors.grey[600]),
                    onPressed: () {
                      // Link to developer's Instagram
                    },
                  ),
                  IconButton(
                    icon: FaIcon(FontAwesomeIcons.instagram,
                        color: Colors.grey[600]),
                    onPressed: () {
                      // Link to developer's Instagram
                    },
                  ),
                  IconButton(
                    icon: FaIcon(FontAwesomeIcons.github,
                        color: Colors.grey[600]),
                    onPressed: () {
                      // Link to developer's GitHub
                    },
                  ),
                ],
              ),
            ),
            Text(
              'Azziz © 2023',
              style: TextStyle(color: Colors.grey[600]),
            ),
            SizedBox(height: 10)
          ],
        ),
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          ListProduct(),
          Produk(),
        ],
      ),
    );
  }
}
