// Separate files for each widget
// Example: list_product.dart, produk.dart, manage_produk.dart, produk_edit_widget.dart

// home_page.dart
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pos_aplication/Widget/ProductsList.dart';
import 'package:pos_aplication/Widget/ProductsManage.dart';
import 'package:pos_aplication/Widget/ProductsEdit.dart';
import 'package:pos_aplication/Screen/ProductFormPage.dart';
import 'package:pos_aplication/theme.dart';

class HomePage extends StatefulWidget {
  final int? index;
  final String? productId;

  const HomePage({Key? key, this.index, this.productId}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    if (widget.index != null) {
      _currentIndex = widget.index!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      drawer: buildDrawer(),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          ProductsList(),
          Produk(),
          ProductsManage(),
          ProductsEditWidget(
            productId: widget.productId,
          ),
        ],
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      centerTitle: true,
      backgroundColor: myTheme.colorScheme.primary,
      title: Text(
        'POS Application',
        style: myTheme.textTheme.headline6,
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.shopping_cart),
        ),
      ],
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
    );
  }

  Drawer buildDrawer() {
    return Drawer(
      child: Column(
        children: <Widget>[
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                buildDrawerHeader(),
                buildListTile('Kasir', Icons.monetization_on, 0),
                buildListTile('Tambah Menu', Icons.add_box, 1),
                buildListTile('Produk', Icons.food_bank, 2),
                buildListTile('Logout', Icons.logout, 3),
              ],
            ),
          ),
          buildSocialIcons(),
          buildFooterText(),
          SizedBox(height: 10),
        ],
      ),
    );
  }

  ListTile buildListTile(String title, IconData icon, int index) {
    return ListTile(
      title: Text(title),
      leading: Icon(icon),
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
    );
  }

  Container buildDrawerHeader() {
    return Container(
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
    );
  }

  Container buildSocialIcons() {
    return Container(
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: FaIcon(FontAwesomeIcons.twitter, color: Colors.grey[600]),
            onPressed: () {
              // Link to developer's Instagram
            },
          ),
          IconButton(
            icon: FaIcon(FontAwesomeIcons.instagram, color: Colors.grey[600]),
            onPressed: () {
              // Link to developer's Instagram
            },
          ),
          IconButton(
            icon: FaIcon(FontAwesomeIcons.github, color: Colors.grey[600]),
            onPressed: () {
              // Link to developer's GitHub
            },
          ),
        ],
      ),
    );
  }

  Text buildFooterText() {
    return Text(
      'Azziz © 2023',
      style: TextStyle(color: Colors.grey[600]),
    );
  }
}
