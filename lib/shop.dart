import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final firestore = FirebaseFirestore.instance;
final auth = FirebaseAuth.instance;

class Shop extends StatefulWidget {
  const Shop({Key? key}) : super(key: key);
  @override
  State<Shop> createState() => _ShopState();
}

class _ShopState extends State<Shop> {

  getData() async {
    //var result = await firestore.collection('product').doc('jkva9kd3FxQnWUS2pomp').get();
    //print(result['name']);
    //await firestore.collection('product').add({'name':'내복', 'price':5000});
    try {
      var result = await firestore.collection('product').get();
      for (var doc in result.docs) {
        print(doc['name']);
      }
    } catch (e) {
      print(e.toString());
    }

    try {
      var result = await auth.createUserWithEmailAndPassword(
        email: "kim@test.com",
        password: "123456",
      );
      print(result.user);
    } catch (e) {
      print(e);
    }



    //if (result.docs.isNotEmpty)

  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('샵페이지임.'),
    );
  }
}
