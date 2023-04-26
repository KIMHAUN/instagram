import 'package:flutter/material.dart';
import 'style.dart' as style;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
        create: (c) => Store(),
      child: MaterialApp(
          theme: style.theme,
          home:  MyApp()
      )
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
  var hide = false;
  var userImage;
  var userContent;

  saveData() async {
    var storage = await SharedPreferences.getInstance();
    storage.setString('name', 'john');
    storage.setStringList('bool', ['dsfsd', 'sdklfjsdkl']);
    storage.remove('ndfas');
    var map = {'age' : 20};
    storage.setString('map', jsonEncode(map)); //Map자료 저장하려면 JSON(String)으로 바꿔서 저장.
    var result = storage.getString('map') ?? '없는데요'; //null check
    print(jsonDecode(result)['age']);

  }

  addData(userImage) {
    var newData = {
      'id' : data.length,
      'image': userImage,
      'likes': 0,
      'date': 'Apr 15',
      'content': userContent,
      'liked': false,
      'user': 'Jerry_park'
    };
    setState(() {
      data.insert(0, newData);
    });
  }

  setUserContent(a) {
    setState(() {
      userContent = a;
    });
  }

  getData() async {
    //Dio패키지 사용시 get요청 더 짧아짐. 오래 걸리는 코드 Future를 뱉는 함수.
    var result = await http.get(Uri.parse('https://codingapple1.github.io/app/data.json'));
    if (result.statusCode == 200) {
      //list/map으로 변환
      var result2 = jsonDecode(result.body);
      setState(() {
        data = result2;
      });
    } else {

    }
  }

  //MyApp위젯이 로드될 때 실행됨 initState는 async 안됨.
  @override
  void initState() {
    super.initState();
    saveData();
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
              onPressed: () async {
                //사진선택화면 띄우기
                var picker = ImagePicker();
                var image = await picker.pickImage(source: ImageSource.gallery);
                if (image != null) {
                  setState(() {
                    userImage = File(image.path);
                  });
                }
                //MaterialApp들어있는 context
                Navigator.push(context,
                    //return{} 는 =>로 대체가능.
                    MaterialPageRoute(builder: (c) => Upload(
                        userImage: userImage, setUserContent: setUserContent,addData: addData) )
                );
              },
            iconSize: 30
          )
        ]
      ),
      body: [
        Home(data: data, hide:hide),
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

//스크롤바 높이 측정하려면 ListView 담은 곳이 StatefulWidget이어야함.
class Home extends StatefulWidget {
  Home({Key? key, this.data, this.hide}) : super(key: key);
  //부모가 보낸건 보통 수정하지 않기 떄문에 final
  final data;
  var hide;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var scroll = ScrollController();
  var moreCount = 0;

  getMoreData() async {
    moreCount++;
    var result = await http.get(Uri.parse('https://codingapple1.github.io/app/more${moreCount}.json'));
    if (result.statusCode == 200) {
      //list/map으로 변환
      var more = jsonDecode(result.body);
      print(more);
      setState(() {
        widget.data.add(more);
      });
    } else {
      return "no data";
    }
  }

  @override
  void initState() {
    super.initState();
    //scroll이 변할 때마다 실행하는 함수.
    scroll.addListener(() {
      //print(scroll.position.userScrollDirection);
      if (scroll.position.userScrollDirection == ScrollDirection.reverse ) {
        //print('내려간당');
        //하단 바 숨김
        widget.hide = true;
      }
      if (scroll.position.pixels == scroll.position.maxScrollExtent) {
        getMoreData();
        print('더 볼 거 없음');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    //데이터가 도착하면 위젯 보여주세요
    //첫 클래스 안에 있던 변수 사용은 widget.변수명

    if (widget.data.isNotEmpty) {
      return ListView.builder(
          itemCount: widget.data.length,
          controller: scroll,
          itemBuilder: (BuildContext ctx, int idx) {
            //print(widget.data[idx]['image'].runtimeType);
            return
                Column(
                  //crossAxisAlignment: CrossAxisAlignment.start,
                  //mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //폰에서 고른 이미지는 Image.file
                    widget.data[idx]['image'].runtimeType == String ?
                    Image.network(widget.data[idx]['image']) : Image.file(widget.data[idx]['image']),

                    Container(
                      constraints: BoxConstraints(maxWidth: 600),
                      padding: EdgeInsets.all(20),
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
//Text에 기능 추가
                          GestureDetector(
                            child : Text(widget.data[idx]['user']),
                            onTap: () {
                              try {
                                Navigator.push(context,
                                //MaterialRouteBuilder
                                //CupertinoPageRoute :  아이폰꺼
                                PageRouteBuilder(
                                    pageBuilder: (c, a1, a2) => Profile(),
                                  transitionsBuilder: (c, a1, a2, child) =>
                                  //child: 새로 띄울 페이지(Profile)
                                  //c : context
                                  //a1: animation object 페이지 덮어질 때 페이지 전환 얼마나 되었는지 0~1로 표시 페이지 전환 다되면 1
                                  //a2 : 애니메이션 오브젝트 기존 페이지에 애니메이션 주고싶을 때.
                                      FadeTransition(opacity: a1, child: child),
                                  transitionDuration: Duration(milliseconds: 500)
                                )
                                );
                              } catch (e, s) {
                                print(s);
                              }
                            },
                          ),
                          Text('좋아요 ${widget.data[idx]['likes']}', style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(widget.data[idx]['date']),
                          Text(widget.data[idx]['content']),
                        ]
                      )
                    )
                  ]
                );
          });
    }
    else {
      return CircularProgressIndicator();
    }
  }
}

class Upload extends StatelessWidget {
  const Upload({Key? key, this.userImage, this.setUserContent, this.addData}) : super(key: key);
  final userImage;
  final setUserContent;
  final addData;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(actions: [
          IconButton(onPressed: () {
            addData(userImage);
            Navigator.pop(context);
           }, icon: Icon(Icons.send))
        ]),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.file(userImage),
              Text('이미지 업로드 화면'),
              TextField(onChanged: (text) {
                setUserContent(text);
                },
              ),
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.close)
              ),
            ],
          ),
        )
    );
  }
}

class Store extends ChangeNotifier {
  var name = 'haun kim';
  var follower = 0;
  var followed = false;
  changeName() {
    name = 'john park';
    notifyListeners(); //재랜더링 해줘
  }
  following() {
    followed = !followed;
    if (followed) {
      follower ++;
    } else {
      follower --;
    }
    notifyListeners();

  }
}

class Profile extends StatelessWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.watch<Store>().name)),
      body:
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(onPressed: () {


          },
              icon: Icon(Icons.circle)
          ),
          Text("팔로워 ${context.watch<Store>().follower} 명 "),
          ElevatedButton(onPressed: (){
            //context.read<Store>().changeName();
            context.read<Store>().following();
          }, child: Text('팔로우'))
        ]
      )

    );
  }
}


