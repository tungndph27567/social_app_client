import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:todo_app/config/constant.dart';
import 'package:todo_app/items/itemSearchFriend.dart';
import 'package:todo_app/models/user.dart';
import 'package:http/http.dart' as http;

class searchFriend extends StatefulWidget {
  const searchFriend({super.key});

  @override
  State<searchFriend> createState() => _searchFriendState();
}

class _searchFriendState extends State<searchFriend> {
  final TextEditingController _controller = TextEditingController();
  List<User> listUser = [];
  void getData() async {
    var respone = await http.get(Uri.parse(getAllUser));
    var jsonRs = json.decode(respone.body);
    final List<dynamic> list = jsonRs;
    for (var user in list) {
      setState(() {
        listUser.add(User.fromJson(user));
      });
    }
  }

  List<User> list = [];

  void _searchFriend(String text) {
    if (text.isEmpty) {
      setState(() {
        list.clear();
      });
    } else {
      setState(() {
        list.clear();
      });
      for (var user in listUser) {
        if (user.name.toLowerCase().contains(text.toLowerCase())) {
          setState(() {
            list.add(user);
          });
        }
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: 300,
              child: TextField(
                controller: _controller,
                onChanged: (text) {
                  _searchFriend(text);
                },
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Color.fromARGB(255, 241, 240, 240),
                  hintText: 'Tìm kiếm',
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                      borderSide: BorderSide(color: Colors.grey)),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                      borderSide: BorderSide(color: Colors.grey)),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 5),
        child: SizedBox(
          height: 300,
          child: ListView.builder(
            itemCount: list.length,
            itemBuilder: (context, index) {
              return itemSearchFriend(
                index: index,
                list: list,
              );
            },
          ),
        ),
      ),
    );
  }
}
