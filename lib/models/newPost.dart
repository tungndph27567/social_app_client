// To parse this JSON data, do
//
//     final newPost = newPostFromJson(jsonString);

import 'dart:convert';

List<newPost> newPostFromJson(String str) =>
    List<newPost>.from(json.decode(str).map((x) => newPost.fromJson(x)));

String newPostToJson(List<newPost> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class newPost {
  String id;
  String idUser;
  String content;
  String image;
  String nameUser;
  List<dynamic> comment;
  List<dynamic> like;

  newPost(
      {required this.id,
      required this.idUser,
      required this.content,
      required this.image,
      required this.comment,
      required this.nameUser,
      required this.like});

  factory newPost.fromJson(Map<String, dynamic> json) => newPost(
        id: json["_id"],
        idUser: json["idUser"],
        content: json["content"],
        nameUser: json["nameUser"],
        image: json["image"],
        comment: List<dynamic>.from(json["comment"].map((x) => x)),
        like: List<dynamic>.from(json["like"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "idUser": idUser,
        "content": content,
        "image": image,
        "comment": List<dynamic>.from(comment.map((x) => x)),
        "like": List<dynamic>.from(comment.map((x) => x)),
      };
}
