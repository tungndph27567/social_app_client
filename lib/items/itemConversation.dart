import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/Screens/chatScreen.dart';
import 'package:todo_app/config/constant.dart';
import 'package:todo_app/models/chat.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class itemConversation extends StatefulWidget {
  const itemConversation(
      {super.key,
      required this.index,
      required this.list,
      required this.id,
      required this.lastMessage,
      required this.idUserChat});

  final List<Chat> list;
  final int index;
  final String id;
  final String lastMessage;
  final String idUserChat;

  @override
  State<itemConversation> createState() => _itemConversationState();
}

class _itemConversationState extends State<itemConversation> {
  late String? token = "";
  late String id = "";
  late SharedPreferences prefs;
  static final customCacheManager = CacheManager(Config('customCacheKey',
      stalePeriod: const Duration(days: 15), maxNrOfCacheObjects: 100));

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

  void updateStatus() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString("token");
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token!);
      setState(() {
        id = decodedToken["_id"];
      });
    });
    var respone = http
        .post(Uri.parse('$updateStatusConversation/${widget.idUserChat}/$id'));
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
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      child: GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(
            builder: (context) {
              return chatScreen(
                name: widget.id == widget.list[widget.index].senderId
                    ? widget.list[widget.index].nameReceiverId
                    : widget.list[widget.index].nameSender,
                id: widget.id == widget.list[widget.index].senderId
                    ? widget.list[widget.index].receiverId
                    : widget.list[widget.index].senderId,
                avatarReceiver: widget.id == widget.list[widget.index].senderId
                    ? widget.list[widget.index].avtReceiverId
                    : widget.list[widget.index].avtSenderId,
              );
            },
          ));
          if (id == widget.list[widget.index].statusReceiver) {
            updateStatus();
          }
        },
        child: Container(
          width: double.infinity,
          color: Colors.white,
          child: Row(
            children: [
              ClipOval(
                child: CachedNetworkImage(
                  cacheManager: customCacheManager,
                  key: UniqueKey(),
                  width: 70,
                  height: 70,
                  imageUrl: widget.id == widget.list[widget.index].senderId
                      ? widget.list[widget.index].avtReceiverId
                      : widget.list[widget.index].avtSenderId,
                  fit: BoxFit.cover,
                  placeholder: (context, url) {
                    return Shimmer.fromColors(
                        baseColor: const Color.fromARGB(255, 169, 167, 167),
                        highlightColor:
                            const Color.fromARGB(255, 223, 219, 219),
                        child: Container(
                          color: Colors.grey[200],
                        ));
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    widget.id == widget.list[widget.index].senderId
                        ? Text(
                            widget.list[widget.index].nameReceiverId,
                            style: const TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 15),
                          )
                        : Text(
                            widget.list[widget.index].nameSender,
                            style: const TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 15),
                          ),
                    Text(
                      widget.lastMessage,
                      style: TextStyle(
                          fontWeight:
                              id == widget.list[widget.index].statusReceiver
                                  ? FontWeight.bold
                                  : null),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
