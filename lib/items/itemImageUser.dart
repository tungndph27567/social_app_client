import 'package:flutter/material.dart';

class itemImageUser extends StatefulWidget {
  const itemImageUser({super.key, required this.index, required this.list});
  final List<dynamic> list;
  final int index;

  @override
  State<itemImageUser> createState() => _itemImageUserState();
}

class _itemImageUserState extends State<itemImageUser> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2),
      child: Container(
        width: MediaQuery.of(context).size.width / 3,
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          image: DecorationImage(
            fit: BoxFit.cover,
            image: NetworkImage(widget.list[widget.index]),
          ),
        ),
      ),
    );
  }
}
