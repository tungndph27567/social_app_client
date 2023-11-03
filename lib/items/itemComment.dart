import 'package:flutter/material.dart';

class itemComment extends StatefulWidget {
  const itemComment({super.key, required this.list, required this.index});
  final List<dynamic> list;
  final int index;

  @override
  State<itemComment> createState() => _itemCommentState();
}

class _itemCommentState extends State<itemComment> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      child: Container(
        child: Row(
          children: [
            const Icon(Icons.android),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Container(
                decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 203, 201, 201),
                    borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.list[widget.index]["name"],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 3),
                        child: Text(widget.list[widget.index]["contentCmt"]),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
