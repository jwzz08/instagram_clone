import 'package:flutter/material.dart';
import './style.dart' as style;
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(
      MaterialApp(
          theme: style.theme,
          home: MyApp()
      )
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var tab = 0;
  var data = [];

  getData() async {
    var result = await http.get(Uri.parse('https://codingapple1.github.io/app/data.json'));
    var result2 = jsonDecode(result.body);
    setState(() {
      data = result2 ;
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Instagram"),
          actions: [IconButton(onPressed: () {

          }, icon: Icon(Icons.add_box_outlined))],
        ),
        body: [mkPage( data : data ), Text('샵페이지')][tab],
        bottomNavigationBar: BottomNavigationBar(
          showSelectedLabels: false,
          showUnselectedLabels: false,
          onTap: (i) {
            setState(() {
              tab = i;
            });
          },
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home_outlined),
              label: 'home',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.shopping_bag_outlined),
              label: 'shopping_bag',)
          ],
        )
    );
  }
}

class mkPage extends StatelessWidget {
  const mkPage({Key? key, this.data }) : super(key: key);
  final data;

  @override
  Widget build(BuildContext context) {

    if (data.isNotEmpty) {
      return ListView.builder(
          itemCount: 3,
          itemBuilder: (context, index) {
            print(data);
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(data[index]['image']),
                Text(data[index]['content']),
                Text(data[index]['id'].toString()),
              ],
            );
          });
    }
    else {
      return CircularProgressIndicator(color: Colors.blue,);
    }
  }
}



