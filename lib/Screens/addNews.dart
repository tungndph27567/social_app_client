import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_storage/firebase_storage.dart' as fire_storage;
import 'package:http/http.dart' as http;
import 'package:todo_app/config/constant.dart';

class addNews extends StatefulWidget {
  addNews({super.key, required this.nameUser});
  String nameUser;

  @override
  State<addNews> createState() => _addNewsState();
}

class _addNewsState extends State<addNews> {
  final storage = fire_storage.FirebaseStorage.instance;
  late String? token = "";
  late String? id = "";
  late SharedPreferences prefs;
  XFile? fileImage;
  String selectedFilename = "";
  String imageUrl = "";
  TextEditingController contentControler = TextEditingController();
  void getToken() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString("token");
    });
    Map<String, dynamic> decodeToken = JwtDecoder.decode(token!);
    setState(() {
      id = decodeToken["_id"];
    });
    print(id);
  }

  Future<void> pickImage() async {
    fileImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (fileImage == null) return;
    setState(() {
      selectedFilename = fileImage!.name;
    });
  }

  void onClickAddnewPost() async {
    if (fileImage != null) {
      fire_storage.UploadTask uploadTask;
      fire_storage.Reference ref =
          storage.ref().child("imageNewPost").child('/${fileImage!.name}');
      uploadTask = ref.putFile(File(fileImage!.path));
      await uploadTask.whenComplete(() => null);
      imageUrl = await ref.getDownloadURL();
    }

    var reqBody = {
      "idUser": id,
      "content": contentControler.text,
      "image": imageUrl,
      "nameUser": widget.nameUser,
    };
    var respone = await http.post(Uri.parse(addNewPost),
        headers: {"Content-Type": "application/json"},
        body: json.encode(reqBody));
    var jsonRespone = await jsonDecode(respone.body);
    if (jsonRespone["msg"]) {
      setState(() {
        Navigator.pop(context);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getToken();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                pickImage();
              },
              icon: const Icon(
                Icons.image,
                color: Colors.black,
              )),
          TextButton(
              onPressed: () {
                contentControler.text.isEmpty && selectedFilename == ""
                    ? null
                    : onClickAddnewPost();
              },
              child: const Text("Đăng"))
        ],
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.close,
              color: Colors.black,
            )),
        toolbarHeight: 60,
        backgroundColor: Colors.white,
        centerTitle: true,
        titleTextStyle:
            const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        elevation: 0,
        title: const Text("Tạo bài viết"),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 5),
        child: Container(
          color: Colors.white,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: TextFormField(
                    controller: contentControler,
                    maxLines: null,
                    decoration: const InputDecoration(
                        hintText: "Bạn đang nghĩ gì",
                        enabledBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(width: 0, color: Colors.white)),
                        focusedBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(width: 0, color: Colors.white))),
                  ),
                ),
                Container(
                  child: selectedFilename.isEmpty
                      ? null
                      : Image.file(File(fileImage!.path)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
