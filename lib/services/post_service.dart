import 'dart:convert';

import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/config/constant.dart';
import 'package:todo_app/models/newPost.dart';
import 'package:http/http.dart' as http;

class PostService {
  late SharedPreferences prefs;
  Future<List<newPost>> getDataPost() async {
    List<newPost> list = [];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token!);
    String id = decodedToken["_id"];
    String url = '$getNewPostFromMyFriend/$id?page=1';
    var respone = await http.get(Uri.parse(url));
    if (respone.statusCode == 200) {
      final List<dynamic> listPost = json.decode(respone.body);
      for (var element in listPost) {
        list.add(newPost.fromJson(element));
      }
      return list;
    } else {
      return [];
    }
  }
}
