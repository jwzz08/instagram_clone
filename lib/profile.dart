import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './main.dart';


class Profile extends StatelessWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.watch<Store2>().name, style: TextStyle(color: Colors.black)),       //provider 갖다쓰기
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: ProfileHeader(),
          ),
          SliverGrid(
              delegate: SliverChildBuilderDelegate(
                  (context, index) => Image.network(context.watch<Store1>().profileImage[index]),
                childCount: context.watch<Store1>().profileImage.length,
              ),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3)),
        ],
      ),


      /* ElevatedButton(onPressed: (){
            context.read<Store1>().changeName();
          }, child: Text('이름변경')),*/                //사용자 이름변경


    );
  }
}

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: Colors.grey,
        ),
        Text('팔로워 ${context.watch<Store1>().follower.toString()}명'),
        ElevatedButton(onPressed: (){
          context.read<Store1>().changeFollower();
          context.read<Store1>().changeTextFollower();
        }, child: Text(context.watch<Store1>().textFollower)),
        ElevatedButton(onPressed: (){
          context.read<Store1>().getData();
        }, child: Text('사진 가져오기')),
      ],
    );
  }
}
