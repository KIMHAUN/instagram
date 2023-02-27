import 'package:flutter/material.dart';
import 'style.dart' as style;
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MaterialApp(
    theme: style.theme,
      home:  MyApp()
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var tab = 0;
  var list = [1, 2, 3];
  var map = {'name': 'john', 'age': 20};


  getData() async {
    var result = await http.get(Uri.parse('https://codingapple1.github.io/app/data.json'));
    //list/map으로 변환
    var result2 = jsonDecode(result.body);
    print(result2[0]['likes']);



  }

  //MyApp위젯이 로드될 때 실행됨 initState는 async 안됨.
  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("instagram"),
        actions: [
          IconButton(
              icon: Icon(Icons.add_box_outlined),
              onPressed: (){
              },
            iconSize: 30
          )
        ]
      ),
      body: [
        Home(),
        Text("샵")][tab],
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: (i){
          setState(() {
            tab = i;
          });},
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: '홈'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_bag_outlined), label: '홈'),
        ]
      ),
    );
  }
}

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 3,
      itemBuilder: (BuildContext ctx, int idx) {
        return Container(
          child: (
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Image.asset('ICU.png',
                  //   width: double.infinity,
                  //   height:500,
                  //   fit: BoxFit.fill),
                  Image.network('https://codingapple1.github.io/kona.jpg'),
                  Text("좋아요 100", style: TextStyle(fontWeight: FontWeight.bold)),
                  Text("글쓴이"),
                  Text("글내용"),
                ],
              )
          ),
        );
      });
  }
}


