import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/config/constant.dart';
import 'package:todo_app/items/itemConversation.dart';
import 'package:todo_app/items/itemFriendChat.dart';
import 'package:http/http.dart' as http;
import 'package:todo_app/models/chat.dart';
import 'package:todo_app/models/user.dart';

class PageChat extends StatefulWidget {
  const PageChat({super.key});

  @override
  State<PageChat> createState() => _PageChatState();
}

class _PageChatState extends State<PageChat>
    with AutomaticKeepAliveClientMixin<PageChat> {
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

  Future<List<Chat>> getConversation() async {
    List<Chat> listConversation = [];
    prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString("token");
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token!);
      setState(() {
        id = decodedToken["_id"];
      });
    });
    var respone = await http.get(Uri.parse('$getMyConversation/$id'));
    List<dynamic> listJson = json.decode(respone.body);
    for (var conversation in listJson) {
      setState(() {
        listConversation.add(Chat.fromJson(conversation));
      });
    }
    return listConversation;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getConversation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          "Đoạn chat",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 5),
        child: Container(
          color: Colors.white,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 120,
                  child: FutureBuilder<List<dynamic>>(
                    future: getListMyFriend(),
                    builder: (BuildContext, AsyncSnapshot snapshot) {
                      if (snapshot.hasError) {
                        return Center(
                          child: Text("Some error occurred ${snapshot.error}"),
                        );
                      }
                      if (snapshot.hasData) {
                        List<dynamic> list = snapshot.data;
                        return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: list.length,
                          itemBuilder: (context, index) {
                            return itemFriendChat(
                              index: index,
                              list: list,
                            );
                          },
                        );
                      }
                      return Container();
                    },
                  ),
                ),
                SizedBox(
                  height: 400,
                  child: FutureBuilder(
                    future: getConversation(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.hasError) {
                        return Center(
                          child: Text('Error: ${snapshot.error}'),
                        );
                      }
                      if (snapshot.hasData) {
                        List<Chat> list = snapshot.data;
                        return ListView.builder(
                          itemCount: list.length,
                          itemBuilder: (context, index) {
                            return itemConversation(
                              index: index,
                              list: list,
                              id: id,
                              lastMessage: list[index].message.last["content"],
                              idUserChat: id == list[index].senderId
                                  ? list[index].receiverId
                                  : list[index].senderId,
                            );
                          },
                        );
                      }
                      return Container();
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
