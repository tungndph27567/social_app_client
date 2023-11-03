import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/Screens/chatScreen.dart';
import 'package:todo_app/config/constant.dart';
import 'package:todo_app/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class itemFriendChat extends StatefulWidget {
  const itemFriendChat({
    super.key,
    required this.list,
    required this.index,
  });
  final List<dynamic> list;
  final int index;

  @override
  State<itemFriendChat> createState() => _itemFriendChatState();
}

class _itemFriendChatState extends State<itemFriendChat> {
  User? user;
  late String? id = "";
  late String? token = "";
  late SharedPreferences prefs;
  static final customCacheManager = CacheManager(Config('customCacheKey',
      stalePeriod: const Duration(days: 15), maxNrOfCacheObjects: 100));
  Future<User?> getprofileUser() async {
    var respone = await http
        .get(Uri.parse('$getInforUser/${widget.list[widget.index]["idUser"]}'));
    var jsonRespone = jsonDecode(respone.body);
    setState(() {
      user = User.fromJson(jsonRespone);
    });
    return user;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
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
            return GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return chatScreen(
                      name: user.name,
                      id: user.id,
                      avatarReceiver: user.avatar,
                    );
                  },
                ));
              },
              child: Container(
                child: Column(
                  children: [
                    ClipOval(
                      child: CachedNetworkImage(
                        cacheManager: customCacheManager,
                        key: UniqueKey(),
                        width: 70,
                        height: 70,
                        imageUrl: user.avatar,
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
                    Padding(
                      padding: const EdgeInsets.only(top: 3),
                      child: SizedBox(
                          width: 80,
                          child: Wrap(children: [
                            Text(
                              user.name,
                              textAlign: TextAlign.center,
                            )
                          ])),
                    )
                  ],
                ),
              ),
            );
          }
          return Container();
        },
      ),
    );
  }
}
