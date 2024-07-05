import 'package:flutter/material.dart';

class LostItemBinCatalog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lost Item Bin Catalog'),
      ),
      body: Center(
        child: Text(
          'Lost Item Bin Catalog',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}