import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class itemChat extends StatefulWidget {
  const itemChat(
      {super.key,
      required this.list,
      required this.index,
      required this.idLogin});
  final List<dynamic> list;
  final int index;
  final String idLogin;

  @override
  State<itemChat> createState() => _itemChatState();
}

class _itemChatState extends State<itemChat> {
  late String? id = "";
  late String? token = "";
  bool isCheck = false;
  late SharedPreferences prefs;
  void getToken() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString("token");
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token!);
      setState(() {
        id = decodedToken["_id"];
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getToken();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
      child: widget.list[widget.index]["idUser"] == widget.idLogin
          ? Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(25),
                            bottomRight: Radius.circular(5))),
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(widget.list[widget.index]["content"]),
                    ),
                  )
                ],
              ),
            )
          : Container(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 25,
                    height: 25,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(
                            "https://inkythuatso.com/uploads/thumbnails/800/2023/03/9-anh-dai-dien-trang-inkythuatso-03-15-27-03.jpg"),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: Container(
                      decoration: const BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(5),
                              topLeft: Radius.circular(25),
                              topRight: Radius.circular(20),
                              bottomRight: Radius.circular(20))),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(widget.list[widget.index]["content"]),
                      ),
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
