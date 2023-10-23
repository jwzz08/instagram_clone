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
  var userImage; //사용자가 선택한 사진 저장
  var userText; //사용자가 입력한 텍스트 저장


  addData(a) {
    setState(() {
      data.add(a);
    });
  }

  setUserText(a){
    setState(() {
      userText = a;
    });
  }

  addNewPost(){
    var newPost = {
      'id' : data.length,
      'image' : userImage,
      'likes' : 4,
      'data' : 'Oct 23rd',
      'content' : userText,
      'liked' : 7,
      'user' : 'Roy Yoo',
    };
    setState(() {
      data.insert(0, newPost);
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
          actions: [IconButton(
              onPressed: () async {
            var picker = ImagePicker();
            var image = await picker.pickImage(source: ImageSource.gallery);    //video를 고르고 싶다면 .pickVideo()
            if (image != null){
              setState(() {
                userImage = File(image.path);
              });
            }

            Navigator.push(context,             //새로운 페이지로 이동
            MaterialPageRoute(builder: (context){         //{ return ~ }을 =>로 바꿔서 쓰기 가능
              return Upload( userImage: userImage, setUserText: setUserText, addNewPost: addNewPost ); })
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
                widget.data[index]['image'].runtimeType == String
                    ? Image.network(widget.data[index]['image'])
                    : Image.file(widget.data[index]['image']),
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
  const Upload({Key? key, this.userImage, this.setUserText, this.addNewPost }) : super(key: key);
  final userImage;
  final setUserText;
  final addNewPost;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: (){
            addNewPost();
            Navigator.pop(context);
          }, icon: Icon(Icons.send))
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.file(userImage, height: 200),
          Text('이미지업로드화면'),
         TextField(onChanged: (text) {
           setUserText(text);
         },),
          IconButton(onPressed: (){
            Navigator.pop(context);     //페이지 pop(닫기)
          }, icon: Icon(Icons.close),),
        ],
      )
    );
  }
}



