import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:todo_app/config/constant.dart';
import 'package:todo_app/items/itemChat.dart';
import 'package:todo_app/models/chat.dart';

class chatScreen extends StatefulWidget {
  const chatScreen(
      {super.key,
      required this.name,
      required this.id,
      required this.avatarReceiver});
  final String name;
  final String id;
  final String avatarReceiver;

  @override
  State<chatScreen> createState() => _chatScreenState();
}

class _chatScreenState extends State<chatScreen>
    with AutomaticKeepAliveClientMixin<chatScreen> {
  TextEditingController contentController = TextEditingController();
  late String? id = "";
  late String? token = "";
  late SharedPreferences prefs;
  late String? avatar = "";
  late String? name = "";
  DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
  void getToken() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString("token");
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token!);
      setState(() {
        id = decodedToken["_id"];
      });
      setState(() {
        avatar = decodedToken["avatar"];
      });
      setState(() {
        name = decodedToken["name"];
      });
    });
  }

  Future<List<dynamic>> getDataChat() async {
    List<dynamic> listMessage = [];
    prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString("token");
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token!);
      setState(() {
        id = decodedToken["_id"];
      });
    });
    var respone =
        await http.get(Uri.parse('${url}chat/getMessage/${widget.id}/$id'));
    setState(() {
      Chat chat = Chat.fromJson(jsonDecode(respone.body));
      listMessage = chat.message;
    });

    return listMessage;
  }

  void onClickSendMessage() async {
    var reqBody = {
      "senderId": id,
      "content": contentController.text,
      "date": dateFormat.format(DateTime.now()),
      "avatarReceiver": widget.avatarReceiver,
      "avatarSender": avatar,
      "nameSender": name,
      "nameReceiver": widget.name,
      "status": widget.id
    };
    setState(() {
      contentController.text = "";
    });

    var respone = await http.post(Uri.parse('$sendMessage/${widget.id}'),
        headers: {"Content-Type": "application/json"},
        body: json.encode(reqBody));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getToken();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
          ),
          backgroundColor: Colors.white,
          title: Text(
            widget.name,
            style: const TextStyle(color: Colors.black),
          ),
        ),
        bottomNavigationBar: Container(
          child: SizedBox(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: TextFormField(
                controller: contentController,
                decoration: InputDecoration(
                    focusedBorder:
                        const UnderlineInputBorder(borderSide: BorderSide.none),
                    enabledBorder:
                        const UnderlineInputBorder(borderSide: BorderSide.none),
                    hintText: "Viết tin nhắn",
                    suffixIcon: IconButton(
                        onPressed: () {
                          onClickSendMessage();
                        },
                        icon: const Icon(Icons.send))),
              ),
            ),
          ),
        ),
        body: FutureBuilder(
          future: getDataChat(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            }
            if (snapshot.hasData) {
              List<dynamic> list = snapshot.data;
              return Padding(
                padding: const EdgeInsets.only(top: 5),
                child: SizedBox(
                  height: double.infinity,
                  width: double.infinity,
                  child: ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      return itemChat(
                        list: list,
                        index: index,
                        idLogin: id!,
                      );
                    },
                  ),
                ),
              );
            }
            return const SizedBox();
          },
        ));
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
