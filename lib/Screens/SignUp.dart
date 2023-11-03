import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/bottomBar/bottomBar.dart';
import '../config/constant.dart';
import 'package:http/http.dart' as http;
import 'HomeScreen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwdController = TextEditingController();
  TextEditingController confirmPasswdController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  String msgEmail = "";
  String msgPass = "";
  late SharedPreferences pref;
  bool isvalidateEmail = false;
  bool isvalidatePass = false;
  bool isNameValidate = false;
  bool isvalidateConfirmPass = false;
  XFile? file;
  String selectedFilename = "";
  String imageUrl = "";
  final storage = firebase_storage.FirebaseStorage.instance;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future<void> setSomeValue(String token) async {}

  Future<void> pickImage() async {
    file = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (file == null) return;
    setState(() {
      selectedFilename = file!.name;
    });
  }

  void onClickSignUp() async {
    if (emailController.text.isEmpty) {
      setState(() {
        isvalidateEmail = true;
      });
    } else {
      setState(() {
        isvalidateEmail = false;
      });
    }
    if (nameController.text.isEmpty) {
      setState(() {
        isNameValidate = true;
      });
    } else {
      setState(() {
        isNameValidate = false;
      });
    }
    if (passwdController.text.isEmpty) {
      setState(() {
        isvalidatePass = true;
      });
    } else {
      setState(() {
        isvalidatePass = false;
      });
    }
    if (confirmPasswdController.text.isEmpty) {
      setState(() {
        isvalidateConfirmPass = true;
      });
    } else {
      setState(() {
        isvalidateConfirmPass = false;
      });
      if (confirmPasswdController.text != passwdController.text) {
        setState(() {
          msgPass = "Nhắc lại mật khẩu không chính xác";
        });
      }
      if (!isvalidateConfirmPass &&
          !isvalidatePass &&
          !isvalidateEmail &&
          !isNameValidate) {
        firebase_storage.UploadTask uploadTask;
        firebase_storage.Reference ref =
            storage.ref().child("avatar").child('/${file!.name}');
        uploadTask = ref.putFile(File(file!.path));
        await uploadTask.whenComplete(() => null);
        imageUrl = await ref.getDownloadURL();
        var respone = await http.post(Uri.parse(regisUser),
            headers: {'Content-Type': 'application/json'},
            body: json.encode({
              'email': emailController.text,
              'name': nameController.text,
              'password': passwdController.text,
              'confirmpPassword': confirmPasswdController.text,
              'avatar': imageUrl,
            }));
        var jsonRespone = jsonDecode(respone.body);
        if (jsonRespone["status"]) {
          var myToken = jsonRespone["token"];
          pref = await SharedPreferences.getInstance();
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', myToken);
          setState(() {
            Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context) {
                return BottomBar(
                  selectedIndex: 0,
                );
              },
            ));
          });
        } else {
          setState(() {
            msgEmail = jsonRespone["msgEmail"];
          });
        }
      }
    }
  }

  @override
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
                "ĐĂNG KÝ",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              )),
              const SizedBox(
                height: 10,
              ),
              IconButton(
                  onPressed: () {
                    pickImage();
                  },
                  icon: const Icon(Icons.camera_alt_outlined)),
              Container(
                child: selectedFilename.isEmpty
                    ? SizedBox(
                        width: 70,
                        height: 70,
                        child: Image.network(
                            "https://ss-images.saostar.vn/wp700/pc/1613810558698/Facebook-Avatar_3.png"),
                      )
                    : Image.file(
                        File(file!.path),
                        height: 70,
                        width: 70,
                      ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                      errorText: isvalidateEmail
                          ? "Email không được để trống"
                          : msgEmail,
                      prefixIcon: const Icon(Icons.email),
                      hintText: "Email",
                      focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(color: Colors.red)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(color: Colors.grey)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(color: Colors.grey)),
                      errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(color: Colors.grey))),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                      errorText:
                          isvalidateEmail ? "Tên không được để trống" : "",
                      prefixIcon: const Icon(Icons.email),
                      hintText: "Họ và tên",
                      focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(color: Colors.red)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(color: Colors.grey)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(color: Colors.grey)),
                      errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(color: Colors.grey))),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextFormField(
                  controller: passwdController,
                  decoration: InputDecoration(
                      errorText:
                          isvalidatePass ? "Password không được để trống" : "",
                      prefixIcon: const Icon(Icons.password),
                      hintText: "Password",
                      focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(color: Colors.grey)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(color: Colors.grey)),
                      errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(color: Colors.grey)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(color: Colors.grey))),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextFormField(
                  controller: confirmPasswdController,
                  decoration: InputDecoration(
                      errorText: isvalidateConfirmPass
                          ? "Xác nhận Password không được để trống"
                          : msgPass,
                      prefixIcon: const Icon(Icons.password),
                      hintText: "Confirm Password",
                      focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(color: Colors.grey)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(color: Colors.grey)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(color: Colors.grey)),
                      errorBorder: OutlineInputBorder(
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
                      onClickSignUp();
                    },
                    style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ))),
                    child: const Text("Đăng ký"),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "Đăng nhập",
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ),
                ],
              ),
            ],
          )),
        ),
      ),
    );
  }
}
