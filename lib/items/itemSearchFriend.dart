import 'package:flutter/material.dart';
import 'package:todo_app/Screens/ProfileUser.dart';
import 'package:todo_app/models/user.dart';

class itemSearchFriend extends StatefulWidget {
  const itemSearchFriend({super.key, required this.list, required this.index});
  final List<User> list;
  final int index;

  @override
  State<itemSearchFriend> createState() => _itemSearchFriendState();
}

class _itemSearchFriendState extends State<itemSearchFriend> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(
            builder: (context) {
              return ProfileUser(
                  id: widget.list[widget.index].id,
                  name: widget.list[widget.index].name);
            },
          ));
        },
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(widget.list[widget.index].avatar),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                      widget.list[widget.index].name,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
              const Icon(Icons.more_horiz)
            ],
          ),
        ),
      ),
    );
  }
}
