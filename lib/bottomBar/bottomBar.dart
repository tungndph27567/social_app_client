import 'package:flutter/material.dart';
import 'package:todo_app/Page/chatPage.dart';
import 'package:todo_app/Page/page1.dart';
import 'package:todo_app/Page/page2.dart';
import 'package:todo_app/Page/page3.dart';

class BottomBar extends StatefulWidget {
  BottomBar({super.key, required this.selectedIndex});
  int selectedIndex = 0;

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  List<Widget> pages = [
    const Page1(),
    const Page2(),
    const PageChat(),
    const Page3(),
  ];
  PageController _controller = PageController();
  int currentIndex = 0;

  // void onTapPage(int index) {
  //   setState(() {
  //     currentIndex = index;
  //     _controller.jumpToPage(index);
  //   });
  // }

  @override
  void initState() {
    super.initState();
    // onTapPage(widget.selectedIndex);
    setState(() {
      currentIndex = widget.selectedIndex;
      _controller = PageController(initialPage: currentIndex);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.white,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          currentIndex: currentIndex,
          onTap: (value) {
            setState(() {
              currentIndex = value;
              _controller.jumpToPage(currentIndex);
            });
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.people), label: "Friend"),
            BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Message'),
            BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Setting'),
          ]),
      body: PageView(
        controller: _controller,
        physics: const NeverScrollableScrollPhysics(),
        children: pages,
      ),
    );
  }
}
