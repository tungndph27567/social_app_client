import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:todo_app/Screens/ProfileUser.dart';
import 'package:todo_app/Screens/detailNewPost.dart';
import 'package:todo_app/config/constant.dart';
import 'package:todo_app/models/newPost.dart';
import 'package:http/http.dart' as http;
import 'package:todo_app/models/user.dart';
import 'package:cached_network_image/cached_network_image.dart';

class itemNews extends StatefulWidget {
  const itemNews({super.key, required this.list, required this.index});

  final List<newPost> list;
  final int index;
  @override
  State<itemNews> createState() => _itemNewsState();
}

class _itemNewsState extends State<itemNews> {
  List<dynamic> listUserLike = [];
  String id = "";
  String? token = "";
  bool isLike = false;
  late SharedPreferences prefs;
  static final customCacheManager = CacheManager(Config('customCacheKey',
      stalePeriod: const Duration(days: 15), maxNrOfCacheObjects: 100));
  void getToken() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString("token");
    });
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token!);
    setState(() {
      id = decodedToken["_id"];
    });
    for (var i = 0; i < widget.list[widget.index].like.length; i++) {
      if (widget.list[widget.index].like[i]["idUserLike"] == id) {
        setState(() {
          isLike = true;
        });
        break;
      }
    }
  }

  void onClickLike() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString("token");
    });
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token!);
    setState(() {
      id = decodedToken["_id"];
    });
    if (!isLike) {
      setState(() {
        isLike = true;
      });
      var reqBody = {"idUserLike": id};
      var respone = await http.post(
          Uri.parse('$likeNewPost/${widget.list[widget.index].id}'),
          headers: {"Content-Type": "application/json"},
          body: json.encode(reqBody));
    } else {
      setState(() {
        isLike = false;
      });
      var reqBody = {"idUserLike": id};
      var respone = await http.post(
          Uri.parse('$unLikeNewPost/${widget.list[widget.index].id}'),
          headers: {"Content-Type": "application/json"},
          body: json.encode(reqBody));
    }
  }

  @override
  void initState() {
    super.initState();
    getToken();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Icon(Icons.android),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return ProfileUser(
                                id: widget.list[widget.index].idUser,
                                name: widget.list[widget.index].nameUser,
                              );
                            },
                          ));
                        },
                        child: Text(
                          widget.list[widget.index].nameUser,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    )
                  ],
                ),
                Row(
                  children: [Text(widget.list[widget.index].content)],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return DetailNewPost(
                            newpost: widget.list[widget.index],
                            index: widget.index,
                          );
                        },
                      ));
                    },
                    child: widget.list[widget.index].image.isEmpty
                        ? const SizedBox(
                            height: 0,
                          )
                        : CachedNetworkImage(
                            cacheManager: customCacheManager,
                            key: UniqueKey(),
                            width: MediaQuery.of(context).size.width,
                            height: 350,
                            imageUrl: widget.list[widget.index].image,
                            fit: BoxFit.cover,
                            placeholder: (context, url) {
                              return Shimmer.fromColors(
                                  baseColor:
                                      const Color.fromARGB(255, 169, 167, 167),
                                  highlightColor:
                                      const Color.fromARGB(255, 223, 219, 219),
                                  child: Container(
                                    color: Colors.grey[200],
                                  ));
                            },
                          ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: onClickLike,
                          child: Icon(
                            Icons.favorite,
                            color: isLike ? Colors.red : Colors.grey,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child:
                              Text('${widget.list[widget.index].like.length}'),
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 5, top: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Icon(Icons.comment),
                          Text('${widget.list[widget.index].comment.length}'),
                          Padding(
                            padding: const EdgeInsets.only(left: 3),
                            child: GestureDetector(
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(
                                    builder: (context) {
                                      return DetailNewPost(
                                        newpost: widget.list[widget.index],
                                        index: widget.index,
                                      );
                                    },
                                  ));
                                },
                                child: const Text("Bình luận")),
                          )
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
