import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/config/constant.dart';
import 'package:http/http.dart' as http;
import 'package:todo_app/items/itemFriend.dart';

class MyFriend extends StatefulWidget {
  const MyFriend({super.key});

  @override
  State<MyFriend> createState() => _MyFriendState();
}

class _MyFriendState extends State<MyFriend> {
  late SharedPreferences prefs;
  String id = "";
  String? token = "";
  Future<List<dynamic>> getListMyFriend() async {
    List<dynamic> listFriend = [];
    prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString("token");
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token!);
      setState(() {
        id = decodedToken["_id"];
      });
    });
    var respone = await http.get(Uri.parse('$getListFriendWhereIdUser/$id'));
    var jsonRs = jsonDecode(respone.body);
    final List<dynamic> listjson = json.decode(respone.body);
    for (var element in listjson) {
      setState(() {
        listFriend.add(element);
      });
    }
    return listFriend;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.white,
            expandedHeight: 60,
            floating: true,
            title: const Text(
              "Bạn bè",
              style: TextStyle(color: Colors.black),
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
          FutureBuilder<List<dynamic>>(
            future: getListMyFriend(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text("Some error occurred ${snapshot.error}"),
                );
              }
              if (snapshot.hasData) {
                List<dynamic> list = snapshot.data;
                return list.isNotEmpty
                    ? SliverList.builder(
                        itemCount: list.length,
                        itemBuilder: (context, index) {
                          return itemMyFriend(
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
                              Icon(Icons.people),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text("Bạn chưa có người bạn nào"),
                              )
                            ],
                          ),
                        ),
                      );
              }
              return const SliverToBoxAdapter(
                child: Center(child: CircularProgressIndicator()),
              );
            },
          )
        ],
      ),
    );
  }
}
