import 'package:flutter/material.dart';
import './style.dart' as style;
import 'package:http/http.dart' as http; //서버
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

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

  addData(a) {
    setState(() {
      data.add(a);
    });
  }

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
            Navigator.push(context,             //새로운 페이지로 이동
            MaterialPageRoute(builder: (context){         //{ return ~ }을 =>로 바꿔서 쓰기 가능
              return Upload(); })
            );
          }, icon: Icon(Icons.add_box_outlined))],
        ),
        body: [mkPage( data : data, addData : addData ), Text('샵페이지')][tab],
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

class mkPage extends StatefulWidget {
  const mkPage({Key? key, this.data, this.addData }) : super(key: key);
  final data;
  final addData;

  @override
  State<mkPage> createState() => _mkPageState();
}

class _mkPageState extends State<mkPage> {

  var scroll = ScrollController();

  getData2() async {
    var result = await http.get(Uri.parse('https://codingapple1.github.io/app/more2.json'));
    var result2 = jsonDecode(result.body);
    widget.addData(result2);
  }

  @override
  void initState() {
    super.initState();
    scroll.addListener(() {
      if(scroll.position.pixels == scroll.position.maxScrollExtent){
        getData2();
      }
    });
  }
  
  @override
  Widget build(BuildContext context) {

    if (widget.data.isNotEmpty) {
      return ListView.builder(
          itemCount: widget.data.length,
          controller: scroll,
          itemBuilder: (context, index) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(widget.data[index]['image']),
                Text(widget.data[index]['id'].toString()),
                Text('좋아요 ${widget.data[index]['likes']}'),
                Text(widget.data[index]['content']),
              ],
            );
          });
    }
    else {
      return CircularProgressIndicator(color: Colors.blue,);
    }
  }
}

class Upload extends StatelessWidget {
  const Upload({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('이미지업로드화면'),
          IconButton(onPressed: (){
            Navigator.pop(context);     //페이지 pop(닫기)
          }, icon: Icon(Icons.close)),
          IconButton(onPressed: (){
            Navigator.push(context,             //새 페이지 열기
                MaterialPageRoute(builder: (context){
                  return Text('세번째페이지'); })
            );
          }, icon: Icon(Icons.add)),
        ],
      )
    );
  }
}



