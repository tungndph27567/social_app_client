import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:todo_app/Screens/SignUp.dart';
import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/bottomBar/bottomBar.dart';

import '../config/constant.dart';
import 'HomeScreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwdController = TextEditingController();
  late SharedPreferences prefs;
  bool isValidate = false;
  Future<void> setSomeValue(String token) async {
    prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    emailController.text = "tung123";
    passwdController.text = "123";
  }

  void onClickSignIn() async {
    if (emailController.text.isNotEmpty || passwdController.text.isNotEmpty) {
      setState(() {
        isValidate = false;
      });
      var reqBody = {
        "email": emailController.text,
        "password": passwdController.text
      };
      var respone = await http.post(Uri.parse(SignIn),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(reqBody));
      var jsonRespone = jsonDecode(respone.body);

      if (jsonRespone["status"]) {
        setState(() {
          setSomeValue(jsonRespone["token"]);
        });
        setState(() {
          Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (context) {
              return BottomBar(
                selectedIndex: 0,
                // token: myToken,
              );
            },
          ));
        });
      } else {
        setState(() {
          QuickAlert.show(
            context: context,
            type: QuickAlertType.error,
            title: 'Thông báo',
            text: 'Thông tin tài khoản mật khẩu không chính xác',
          );
        });
      }
    } else {
      setState(() {
        isValidate = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: SafeArea(
              child: Column(
            children: [
              const Center(
                  child: Text(
                "WELCOME BACK!",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              )),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(color: Colors.grey)),
                    errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(color: Colors.grey)),
                    errorText: isValidate ? "Email không được để trống" : null,
                    prefixIcon: const Icon(Icons.email),
                    hintText: "Email",
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(color: Colors.grey)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(color: Colors.grey)),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextFormField(
                  controller: passwdController,
                  decoration: InputDecoration(
                      errorText:
                          isValidate ? "Mật khẩu không được để trống" : null,
                      focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(color: Colors.grey)),
                      errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(color: Colors.grey)),
                      prefixIcon: const Icon(Icons.password),
                      hintText: "Password",
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(color: Colors.grey)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(color: Colors.grey))),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 40,
                  child: ElevatedButton(
                    onPressed: () {
                      onClickSignIn();
                    },
                    style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ))),
                    child: const Text("Đăng nhập"),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Bạn chưa có tài khoản?",
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return const SignUp();
                          },
                        ));
                      },
                      child: const Text(
                        "Đăng ký",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  )
                ],
              )
            ],
          )),
        ),
      ),
    );
  }
}
