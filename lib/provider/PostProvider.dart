import 'package:flutter/material.dart';
import 'package:todo_app/models/newPost.dart';
import 'package:todo_app/services/post_service.dart';

class PostProvider extends ChangeNotifier {
  final PostService postService = PostService();
  List<newPost> _listPost = [];
  bool isLoading = false;
  List<newPost> get listPost => _listPost;
  Future<void> getPost() async {
    final response = await postService.getDataPost();
    _listPost = response;
    notifyListeners();
  }
}
