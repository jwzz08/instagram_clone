import 'package:flutter/material.dart';
import './style.dart' as style;
import 'package:http/http.dart' as http; //서버
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import './profile.dart';
import 'notification.dart';

void main() {
  runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (c) => Store1()),
          ChangeNotifierProvider(create: (c) => Store2()),
        ],
        child: MaterialApp(
            theme: style.theme,
            home: MyApp()
        ),
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
  
  saveData() async {
    var storage = await SharedPreferences.getInstance();
    
    var map = {'age' : 20 }; 
    storage.setString('map', jsonEncode(map));      //map자료형 json 형식으로 바꾸기
    var result2 = storage.getString('map') ?? '없어요';
    print(result2);
    print(jsonDecode(result2)['age']);
    
    storage.setString('name', 'Roy');
    storage.setInt('five', 5);
    storage.remove('five');
    var result = storage.get('name');        //정석은 getString()임; 자료형에 맞게 쓰기; storage에 있는 자료 꺼낼 때 사용
    print(result);
  }
  
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
    initNotification();
    saveData();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(child: Text('+'),
      onPressed: (){
        showNotification();
    },),
        appBar: AppBar(
          title: Text("Instagram", style: TextStyle(color: Colors.black)),
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

                GestureDetector(child: Text(widget.data[index]['user']),
                onTap: (){
                  Navigator.push(context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) => Profile(),
                  transitionsBuilder: (context, animation, secondaryAnimation, child) =>
                    FadeTransition(opacity: animation, child: child,),));
                },),
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


class Store1 extends ChangeNotifier {
  var follower = 0;
  var textFollower = "팔로우";
  var isFriend = false;           //팔로우버튼 클릭유무
  var profileImage = [];

  /*
  changeName(){
    name = "John Park";
    notifyListeners();        //재랜더링함수 ==setstate()
  }
   */

  getData() async {
    var result = await http.get(Uri.parse('https://codingapple1.github.io/app/profile.json'));
    var result2 = jsonDecode(result.body);
    profileImage = result2;
    notifyListeners();
  }

  changeFollower(){
    if(isFriend == false) {
      follower += 1;
      isFriend = true;
    } else {
      follower -= 1;
      isFriend = false;
    }
    notifyListeners();
  }

  changeTextFollower(){
    if(isFriend == true)
    {
      textFollower = "팔로우 취소";
    } else {
      textFollower = "팔로우";
    }
  }
}


class Store2 extends ChangeNotifier {
  var name = 'John Kim';
}

