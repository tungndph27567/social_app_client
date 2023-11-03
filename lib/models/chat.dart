// To parse this JSON data, do
//
//     final Chat = ChatFromJson(jsonString);

import 'dart:convert';

Chat ChatFromJson(String str) => Chat.fromJson(json.decode(str));

String ChatToJson(Chat data) => json.encode(data.toJson());

class Chat {
  String id;
  List<dynamic> message;
  String senderId;
  String receiverId;
  String avtSenderId;
  String avtReceiverId;
  String nameReceiverId;
  String nameSender;
  String statusReceiver;
  int v;

  Chat({
    required this.id,
    required this.message,
    required this.senderId,
    required this.receiverId,
    required this.avtSenderId,
    required this.avtReceiverId,
    required this.nameReceiverId,
    required this.nameSender,
    required this.statusReceiver,
    required this.v,
  });

  factory Chat.fromJson(Map<String, dynamic> json) => Chat(
        id: json["_id"],
        message: List<dynamic>.from(json["message"].map((x) => x)),
        senderId: json["senderId"],
        receiverId: json["receiverId"],
        avtSenderId: json["avatarSender"],
        avtReceiverId: json["avatarReceiver"],
        nameSender: json["nameSender"],
        nameReceiverId: json["nameReceiver"],
        statusReceiver: json["statusReceiver"],
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "message": List<dynamic>.from(message.map((x) => x)),
        "senderId": senderId,
        "receiverId": receiverId,
        "__v": v,
      };
}
