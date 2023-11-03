import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/items/itemNews.dart';
import 'package:todo_app/provider/PostProvider.dart';

class pagePost extends StatefulWidget {
  const pagePost({super.key});

  @override
  State<pagePost> createState() => _pagePostState();
}

class _pagePostState extends State<pagePost> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<PostProvider>(context, listen: false).getPost();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Consumer<PostProvider>(
        builder: (context, value, child) {
          return SliverList.builder(
            itemCount: value.listPost.length,
            itemBuilder: (context, index) {
              return itemNews(
                list: value.listPost,
                index: index,
              );
            },
          );
        },
      ),
    );
  }
}
