import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Shop extends StatefulWidget {
  const Shop({Key? key}) : super(key: key);

  @override
  State<Shop> createState() => _ShopState();
}

class _ShopState extends State<Shop> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('샵페이지임'),
    );
  }
}
