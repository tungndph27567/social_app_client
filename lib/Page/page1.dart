import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:todo_app/Screens/addNews.dart';
import 'package:todo_app/Screens/searchFriend.dart';
import 'package:todo_app/config/constant.dart';
import 'package:todo_app/items/itemNews.dart';
import 'package:todo_app/models/newPost.dart';

import 'package:todo_app/models/user.dart';

class Page1 extends StatefulWidget {
  const Page1({super.key});

  @override
  State<Page1> createState() => _Page1State();
}

class _Page1State extends State<Page1>
    with AutomaticKeepAliveClientMixin<Page1> {
  User? user;
  late String? token = "";
  late String id = "";
  late SharedPreferences prefs;
  final ScrollController _scrollController = ScrollController();
  int page = 1;
  bool load = false;
  bool isLoading = false;
  Future<void> getToken() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString("token");
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token!);
      setState(() {
        id = decodedToken["_id"];
      });
      getInforUser(id);
    });
  }

  Future<void> getInforUser(String id) async {
    var respone = await http.get(
      Uri.parse('$getInforUserLogin/$id'),
    );
    final body = respone.body;
    final jsonRs = jsonDecode(body);
    setState(() {
      user = User.fromJson(jsonRs);
    });
  }

  Future<List<newPost>> getDataNewPost() async {
    List<newPost> listNewPost = [];

    prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString("token");
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token!);
      setState(() {
        id = decodedToken["_id"];
      });
    });
    try {
      var respone = await http.get(
        Uri.parse('$getNewPostFromMyFriend/$id?page=$page'),
      );

      final List<dynamic> listPost = json.decode(respone.body);
      setState(() {
        listNewPost = listNewPost;
      });
      for (var element in listPost) {
        setState(() {
          listNewPost.add(newPost.fromJson(element));
        });
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
    return listNewPost;
  }

  void gotoScreenAddNew() {
    Navigator.push(context, MaterialPageRoute(
      builder: (context) {
        return addNews(
          nameUser: user!.name,
        );
      },
    ));
  }

  void scrollListener() {
    // if (_scrollController.position.pixels ==
    //     _scrollController.position.maxScrollExtent) {
    //   page += 1;
    //   getDataNewPost();
    // }
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(scrollListener);
    getToken();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverAppBar(
            floating: true,
            actions: <Widget>[
              IconButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return const searchFriend();
                      },
                    ));
                  },
                  icon: const Icon(
                    Icons.search,
                    color: Colors.black,
                  ))
            ],
            backgroundColor: Colors.white,
            expandedHeight: 60,
            title: const Text(
              "Home",
              style: TextStyle(color: Colors.black),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              height: 50,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        // CircleAvatar(
                        //   backgroundImage: NetworkImage(user!.avatar),
                        // ),
                        Padding(
                          padding: EdgeInsets.only(left: 5),
                          child: Text("Đăng tải bài viết"),
                        )
                      ],
                    ),
                    GestureDetector(
                        onTap: () {
                          gotoScreenAddNew();
                        },
                        child: const Icon(Icons.add))
                  ],
                ),
              ),
            ),
          ),
          FutureBuilder<List<newPost>>(
            future: getDataNewPost(),
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
                            )),
                      );
              }
              return SliverToBoxAdapter(
                  child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
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
                                  borderRadius: BorderRadius.circular(15)),
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Container(
                              width: 200,
                              height: 20,
                              decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(15)),
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
                      Padding(
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
                                        borderRadius:
                                            BorderRadius.circular(15)),
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
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4),
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
                      Padding(
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
                                        borderRadius:
                                            BorderRadius.circular(15)),
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
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4),
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
                      Padding(
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
                                        borderRadius:
                                            BorderRadius.circular(15)),
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
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4),
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
                      )
                    ],
                  ),
                ),
              ));
            },
          )
        ],
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
