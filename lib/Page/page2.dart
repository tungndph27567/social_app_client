import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/Screens/MyFriend.dart';
import 'package:todo_app/config/constant.dart';
import 'package:todo_app/items/itemReqAddFriend.dart';
import 'package:http/http.dart' as http;

class Page2 extends StatefulWidget {
  const Page2({super.key});

  @override
  State<Page2> createState() => _Page2State();
}

class _Page2State extends State<Page2>
    with AutomaticKeepAliveClientMixin<Page2> {
  late SharedPreferences prefs;
  late String? token = "";
  late String id = "";
  Future<List<dynamic>> getDataListReqAddFriend() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString("token");
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token!);
      setState(() {
        id = decodedToken["_id"];
      });
    });
    List<dynamic> list = [];
    var respone = await http.get(Uri.parse('$getListReqAddFriend/$id'));
    var jsonRs = jsonDecode(respone.body);
    final List<dynamic> listjson = json.decode(respone.body);
    for (var element in listjson) {
      setState(() {
        list.add(element);
      });
    }
    return list;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDataListReqAddFriend();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Bạn Bè",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(5),
        child: Container(
          child: Column(
            children: [
              Row(
                children: [
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor:
                              const Color.fromARGB(255, 56, 149, 225),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20))),
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return const MyFriend();
                          },
                        ));
                      },
                      child: const Text("Bạn Bè"))
                ],
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 1,
                color: Colors.black,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Lời mời kết bạn",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextButton(
                        onPressed: () {}, child: const Text("Xem tất cả"))
                  ],
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.62,
                child: FutureBuilder<List<dynamic>>(
                  future: getDataListReqAddFriend(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Text("Some error occurred ${snapshot.error}"),
                      );
                    }
                    if (snapshot.hasData) {
                      List<dynamic> list = snapshot.data;
                      return list.isNotEmpty
                          ? ListView.builder(
                              itemCount: list.length,
                              itemBuilder: (context, index) {
                                return itemReqAddFriend(
                                  index: index,
                                  list: list,
                                );
                              },
                            )
                          : Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Container(
                                child: const Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.people),
                                    Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                          "Bạn không có lời mời kết bạn nào"),
                                    )
                                  ],
                                ),
                              ),
                            );
                    } else {
                      return Container();
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
