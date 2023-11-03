import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/config/constant.dart';
import 'package:todo_app/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class itemMyFriend extends StatefulWidget {
  const itemMyFriend({super.key, required this.index, required this.list});
  final List<dynamic> list;
  final int index;

  @override
  State<itemMyFriend> createState() => _itemMyFriendState();
}

class _itemMyFriendState extends State<itemMyFriend> {
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
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
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
                          padding: const EdgeInsets.only(left: 10),
                          child: Text(
                            user.name,
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                    const Icon(Icons.more_horiz)
                  ],
                ),
              );
            }
            return Container();
          },
        ));
  }
}
