import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/config/constant.dart';
import 'package:todo_app/models/user.dart';
import 'package:http/http.dart' as http;

class itemReqAddFriend extends StatefulWidget {
  const itemReqAddFriend({super.key, required this.index, required this.list});
  final List<dynamic> list;
  final int index;

  @override
  State<itemReqAddFriend> createState() => _itemReqAddFriendState();
}

class _itemReqAddFriendState extends State<itemReqAddFriend> {
  User? user;
  late String? id = "";
  late String? token = "";
  late SharedPreferences prefs;
  Future<User?> getprofileUser() async {
    var respone = await http.get(Uri.parse(
        '$getInforUser/${widget.list[widget.index]["idPersionReq"]}'));
    var jsonRespone = jsonDecode(respone.body);
    setState(() {
      user = User.fromJson(jsonRespone);
    });
    return user;
  }

  void onClickAcceptFriendReq() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString("token");
    });
    Map<String, dynamic> decodeToken = JwtDecoder.decode(token!);
    setState(() {
      id = decodeToken["_id"];
    });
    var reqBody = {"idPersionReq": widget.list[widget.index]["idPersionReq"]};
    var respone = http.post(Uri.parse('$acceptFriendReq/$id'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(reqBody));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getprofileUser();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: FutureBuilder(
          future: getprofileUser(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text("Some error occurred ${snapshot.error}"),
              );
            }
            if (snapshot.hasData) {
              User user = snapshot.data;
              return Container(
                child: Row(
                  children: [
                    Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(user.avatar),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Row(
                            children: [
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      fixedSize: const Size(90, 30),
                                      elevation: 0),
                                  onPressed: () {
                                    onClickAcceptFriendReq();
                                  },
                                  child: const Text("Đồng ý")),
                              Padding(
                                padding: const EdgeInsets.only(left: 5),
                                child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        fixedSize: const Size(90, 30),
                                        elevation: 0),
                                    onPressed: () {},
                                    child: const Text("Xóa")),
                              )
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              );
            }
            return Container();
          },
        )
        );
  }
}
