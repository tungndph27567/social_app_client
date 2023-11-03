import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/config/constant.dart';
import 'package:todo_app/items/itemImageUser.dart';
import 'package:todo_app/items/itemNews.dart';
import 'package:todo_app/models/newPost.dart';
import 'package:todo_app/models/user.dart';

class ProfileUser extends StatefulWidget {
  const ProfileUser({super.key, required this.id, required this.name});
  final String id;
  final String name;

  @override
  State<ProfileUser> createState() => _ProfileUserState();
}

class _ProfileUserState extends State<ProfileUser> {
  List<dynamic> listReqAddFriend = [];
  List<dynamic> listFriend = [];
  List<dynamic> listMyFriend = [];
  List<dynamic> listMyReqFriend = [];
  late SharedPreferences prefs;
  late String? token = "";
  late String id = "";
  String statusBtn = "Kết bạn";
  bool isMe = true;
  bool isPost = true;
  void getToken() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString("token");
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token!);
      setState(() {
        id = decodedToken["_id"];
      });
    });
    if (id == widget.id) {
      setState(() {
        isMe = false;
      });
    }
  }

  Future<User> getprofileUser() async {
    User user = User(id: "", email: "", avatar: "", name: "");
    var respone = await http.get(Uri.parse('$getInforUser/${widget.id}'));
    var jsonRespone = jsonDecode(respone.body);
    setState(() {
      user = User.fromJson(jsonRespone);
    });
    return user;
  }

  Future<List<dynamic>> getImageUser() async {
    List<dynamic> listImg = [];

    var respone =
        await http.get(Uri.parse('$getImageUserFromPost/${widget.id}'));
    final List<dynamic> listJs = json.decode(respone.body);
    for (var img in listJs) {
      setState(() {
        listImg.add(img);
      });
    }
    return listImg;
  }

  Future<List<newPost>> getDataPost() async {
    List<newPost> listNewPost = [];
    var respone =
        await http.get(Uri.parse('$getAllNewPostWhereIdUser/${widget.id}'));
    var responseJs = jsonDecode(respone.body);
    List<dynamic> list = responseJs;
    for (var post in list) {
      setState(() {
        listNewPost.add(newPost.fromJson(post));
      });
    }
    return listNewPost;
  }

  void onClickSendReqAddFriend() async {
    if (statusBtn == "Kết bạn") {
      setState(() {
        statusBtn = "Đã gửi lời mời";
      });
      prefs = await SharedPreferences.getInstance();
      setState(() {
        token = prefs.getString("token");
        Map<String, dynamic> decodedToken = JwtDecoder.decode(token!);
        setState(() {
          id = decodedToken["_id"];
        });
      });
      var reqBody = {"idPersionReq": id};
      var respone = await http.post(Uri.parse('$addFirendReq/${widget.id}'),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(reqBody));
    } else if (statusBtn == "Phản hồi") {
      showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(15), // Bo góc trên
          ),
        ),
        builder: (context) {
          return SizedBox(
            height: 120,
            child: Center(
              child: Column(
                children: [
                  ListTile(
                    onTap: () {
                      onClickAcceptFriendReq();
                      Navigator.pop(context);
                    },
                    leading: Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                            color: Colors.grey, shape: BoxShape.circle),
                        child: const Icon(
                          Icons.check,
                          color: Colors.white,
                        )),
                    title: const Text(
                      "Xác nhận lời mời",
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                  ListTile(
                    leading: Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                            color: Colors.grey, shape: BoxShape.circle),
                        child: const Icon(
                          Icons.close,
                          color: Colors.white,
                        )),
                    title: const Text("Xóa lời mời",
                        style: TextStyle(fontWeight: FontWeight.w500)),
                  )
                ],
              ),
            ),
          );
        },
      );
    }
  }

  void onClickAcceptFriendReq() async {
    setState(() {
      statusBtn = "Bạn bè";
    });
    prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString("token");
    });
    Map<String, dynamic> decodeToken = JwtDecoder.decode(token!);
    setState(() {
      id = decodeToken["_id"];
    });
    var reqBody = {"idPersionReq": widget.id};
    var respone = http.post(Uri.parse('$acceptFriendReq/$id'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(reqBody));
  }

  void getStatusButtonAddFriend() async {
    var respone =
        await http.get(Uri.parse('$getListReqAddFriend/${widget.id}'));
    final List<dynamic> listjson = json.decode(respone.body);
    for (var element in listjson) {
      setState(() {
        listReqAddFriend.add(element);
      });
    }
    prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString("token");
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token!);
      setState(() {
        id = decodedToken["_id"];
      });
    });
    for (var i = 0; i < listReqAddFriend.length; i++) {
      if (id == listReqAddFriend[i]["idPersionReq"]) {
        setState(() {
          statusBtn = "Đã gửi lời mời";
        });
        break;
      }
    }
  }

  void getListFriendWhereId() async {
    var respone =
        await http.get(Uri.parse('$getListFriendWhereIdUser/${widget.id}'));
    final List<dynamic> listjson = json.decode(respone.body);
    for (var element in listjson) {
      setState(() {
        listFriend.add(element);
      });
    }
    prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString("token");
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token!);
      setState(() {
        id = decodedToken["_id"];
      });
    });
    for (var i = 0; i < listFriend.length; i++) {
      if (id == listFriend[i]["idUser"]) {
        setState(() {
          statusBtn = "Bạn bè";
        });
        break;
      }
    }
  }

  void getListMyFriend() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString("token");
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token!);
      setState(() {
        id = decodedToken["_id"];
      });
    });
    var respone = await http.get(Uri.parse('$getListFriendWhereIdUser/$id'));
    final List<dynamic> listjson = json.decode(respone.body);
    for (var element in listjson) {
      setState(() {
        listMyFriend.add(element);
      });
    }

    for (var i = 0; i < listMyFriend.length; i++) {
      if (widget.id == listMyFriend[i]["idUser"]) {
        setState(() {
          statusBtn = "Bạn bè";
        });
        break;
      }
    }
  }

  void getMyListReqFriend() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString("token");
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token!);
      setState(() {
        id = decodedToken["_id"];
      });
    });
    var respone = await http.get(Uri.parse('$getListReqAddFriend/$id'));
    final List<dynamic> listjson = json.decode(respone.body);
    for (var element in listjson) {
      setState(() {
        listMyReqFriend.add(element);
      });
    }
    for (var element in listMyReqFriend) {
      if (widget.id == element["idPersionReq"]) {
        setState(() {
          statusBtn = "Phản hồi";
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getStatusButtonAddFriend();
    getListFriendWhereId();
    getListMyFriend();
    getMyListReqFriend();
    getToken();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CustomScrollView(
      slivers: [
        SliverAppBar(
          floating: true,
          elevation: 0,
          backgroundColor: Colors.white,
          title: Text(
            widget.name,
            style: const TextStyle(color: Colors.black),
          ),
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
          ),
        ),
        FutureBuilder(
          future: getprofileUser(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasError) {}
            if (snapshot.hasData) {
              User objU = snapshot.data;
              return SliverToBoxAdapter(
                child: Container(
                  color: Colors.white,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Container(
                              width: 100.0,
                              height: 100.0,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(objU.avatar),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              objU.name,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Visibility(
                              visible: isMe,
                              child: ElevatedButton(
                                  onPressed: () {
                                    onClickSendReqAddFriend();
                                  },
                                  style: ButtonStyle(
                                    elevation: MaterialStateProperty.all(0),
                                  ),
                                  child: Text(statusBtn)),
                            ),
                            Visibility(
                              visible: isMe,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              const Color.fromARGB(
                                                  255, 179, 178, 178)),
                                      elevation: MaterialStateProperty.all(0)),
                                  onPressed: () {},
                                  child: const Text("Nhắn tin"),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  backgroundColor:
                                      isPost ? Colors.blue : Colors.white,
                                  foregroundColor:
                                      isPost ? Colors.white : Colors.black,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20))),
                              onPressed: () {
                                setState(() {
                                  isPost = true;
                                });
                              },
                              child: const Text("Bài viết")),
                          Padding(
                            padding: const EdgeInsets.only(left: 5),
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    elevation: 0,
                                    foregroundColor:
                                        isPost ? Colors.black : Colors.white,
                                    backgroundColor:
                                        isPost ? Colors.white : Colors.blue,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20))),
                                onPressed: () {
                                  setState(() {
                                    isPost = false;
                                  });
                                },
                                child: const Text("Ảnh")),
                          ),
                        ],
                      ),
                      isPost
                          ? Padding(
                              padding: const EdgeInsets.only(
                                  top: 10, bottom: 3, left: 5, right: 5),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  isMe
                                      ? Text(
                                          "Bài viết của ${objU.name}",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                        )
                                      : const Text(
                                          "Bài viết của bạn",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                ],
                              ),
                            )
                          : Padding(
                              padding: const EdgeInsets.only(
                                  top: 10, bottom: 3, left: 5, right: 5),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  isMe
                                      ? Text(
                                          "Ảnh của ${objU.name}",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                        )
                                      : const Text(
                                          "Ảnh của bạn",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                ],
                              ),
                            ),
                      Padding(
                        padding: const EdgeInsets.only(left: 5, right: 5),
                        child: Container(
                          color: Colors.black,
                          width: MediaQuery.of(context).size.width,
                          height: 1,
                        ),
                      )
                    ],
                  ),
                ),
              );
            }
            return const SliverToBoxAdapter();
          },
        ),
        isPost
            ? FutureBuilder<List<newPost>>(
                future: getDataPost(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text("Some error occurred ${snapshot.error}"),
                    );
                  }
                  if (snapshot.hasData) {
                    List<newPost> list = snapshot.data;
                    return list.isNotEmpty
                        ? SliverList.builder(
                            itemCount: list.length,
                            itemBuilder: (context, index) {
                              return itemNews(
                                list: list,
                                index: index,
                              );
                            },
                          )
                        : SliverToBoxAdapter(
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height * 0.75,
                              child: const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.newspaper),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child:
                                        Text("Không có bài viết nào từ bạn bè"),
                                  )
                                ],
                              ),
                            ),
                          );
                  }
                  return SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 5),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 30,
                                  height: 30,
                                  decoration: BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.circular(15)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 5),
                                  child: Container(
                                    width: 100,
                                    height: 20,
                                    decoration: BoxDecoration(
                                        color: Colors.grey,
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                  ),
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 4),
                                  child: Container(
                                    width: 200,
                                    height: 20,
                                    decoration: BoxDecoration(
                                        color: Colors.grey,
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                height: 200,
                                decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.circular(15)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              )
            : FutureBuilder(
                future: getImageUser(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text("Error: ${snapshot.error}"),
                    );
                  }
                  if (snapshot.hasData) {
                    List<dynamic> list = snapshot.data;
                    return SliverGrid.builder(
                      itemCount: list.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3),
                      itemBuilder: (context, index) {
                        return itemImageUser(
                          index: index,
                          list: list,
                        );
                      },
                    );
                  }
                  return const SliverToBoxAdapter();
                },
              )
      ],
    ));
  }
}
