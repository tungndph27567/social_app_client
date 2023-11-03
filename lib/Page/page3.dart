import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:todo_app/Screens/LoginScreen.dart';
import 'package:todo_app/config/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Page3 extends StatefulWidget {
  const Page3({super.key});

  @override
  State<Page3> createState() => _Page3State();
}

class _Page3State extends State<Page3> {
  late String? token = "";
  late SharedPreferences prefs;
  void getToken() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('token');
    });
  }

  @override
  void initState() {
    super.initState();
    getToken();
  }

  void OnClickLogout() async {
    var reqBody = {"token": token};
    var respone = await http.post(Uri.parse(Logout),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(reqBody));
    var jsonRespone = jsonDecode(respone.body);
    if (jsonRespone["check"]) {
      setState(() {
        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) {
            return const LoginScreen();
          },
        ));
      });
    } else {
      print("LogOut that bai");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(
            backgroundColor: Colors.white,
            expandedHeight: 60,
            title: Text(
              "Setting",
              style: TextStyle(color: Colors.black),
            ),
          ),
          SliverToBoxAdapter(
            child: ElevatedButton(
                onPressed: () {
                  OnClickLogout();
                },
                child: const Text("Đăng xuất")),
          ),
        ],
      ),
    );
  }
}
