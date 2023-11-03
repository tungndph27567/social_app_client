import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:todo_app/config/constant.dart';
import 'package:todo_app/items/itemComment.dart';
import 'package:todo_app/models/newPost.dart';
import 'package:http/http.dart' as http;
import 'package:todo_app/models/user.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:shimmer/shimmer.dart';
import 'package:intl/intl.dart';

class DetailNewPost extends StatefulWidget {
  const DetailNewPost({super.key, required this.newpost, required this.index});
  final newPost? newpost;
  final int index;

  @override
  State<DetailNewPost> createState() => _DetailNewPostState();
}

class _DetailNewPostState extends State<DetailNewPost> {
  TextEditingController cmtController = TextEditingController();
  DateFormat dateFormat = DateFormat("yyyy-MM-dd");
  static final customCacheManager = CacheManager(Config('customCacheKey',
      stalePeriod: const Duration(days: 15), maxNrOfCacheObjects: 100));
  @override
  Future<List<dynamic>> getlistCmt() async {
    List<dynamic> list = [];
    var respone = await http.get(
      Uri.parse('$getCommentWhereIdPost/${widget.newpost!.id}'),
    );
    final List<dynamic> listjson = json.decode(respone.body);
    for (var cmt in listjson) {
      setState(() {
        list.add(cmt);
      });
    }
    return list;
  }

  void onClickCmt() async {
    var reqBody = {
      "idUserCmt": widget.newpost!.idUser,
      "contentCmt": cmtController.text,
      "name": widget.newpost!.nameUser,
      "avatar": "",
      "date": dateFormat.format(DateTime.now())
    };
    var respone = await http.post(Uri.parse('$addCmt/${widget.newpost!.id}'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(reqBody));
    var jsonRespone = await jsonDecode(respone.body);
    if (jsonRespone["msg"]) {
      cmtController.clear();
    }
  }

  @override
  void initState() {
    super.initState();
    // getDataNewPost();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        child: SizedBox(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: TextFormField(
              controller: cmtController,
              decoration: InputDecoration(
                  focusedBorder:
                      const UnderlineInputBorder(borderSide: BorderSide.none),
                  enabledBorder:
                      const UnderlineInputBorder(borderSide: BorderSide.none),
                  hintText: "Viết bình luận",
                  suffixIcon: IconButton(
                      onPressed: () {
                        onClickCmt();
                      },
                      icon: const Icon(Icons.send))),
            ),
          ),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.white,
            toolbarHeight: 40,
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.close),
              color: Colors.black,
            ),
          ),
          SliverToBoxAdapter(
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
                            child: Text(
                              widget.newpost!.nameUser,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: [Text(widget.newpost!.content)],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: widget.newpost!.image.isEmpty
                            ? const SizedBox()
                            : CachedNetworkImage(
                                cacheManager: customCacheManager,
                                key: UniqueKey(),
                                width: MediaQuery.of(context).size.width,
                                height: 350,
                                imageUrl: widget.newpost!.image,
                                fit: BoxFit.cover,
                                placeholder: (context, url) {
                                  return Shimmer.fromColors(
                                      baseColor: const Color.fromARGB(
                                          255, 169, 167, 167),
                                      highlightColor: const Color.fromARGB(
                                          255, 223, 219, 219),
                                      child: Container(
                                        color: Colors.grey[200],
                                      ));
                                },
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          FutureBuilder(
            future: getlistCmt(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text("Some error occurred ${snapshot.error}"),
                );
              }
              if (snapshot.hasData) {
                List<dynamic> listCMT = snapshot.data;
                return SliverList.builder(
                  itemCount: listCMT.length,
                  itemBuilder: (context, index) {
                    return itemComment(
                      list: listCMT,
                      index: index,
                    );
                  },
                );
              }
              return const SliverToBoxAdapter();
            },
          )
        ],
      ),
    );
  }
}
