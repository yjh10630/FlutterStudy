import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BoardTag extends StatelessWidget {
  const BoardTag({
    Key? key,
    required this.tagName,
    required this.txtColor
  }): super(key: key);

  final String tagName;
  final Color txtColor;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 5, right: 5, top: 2, bottom: 2),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(3.0),
          color: Colors.black.withOpacity(0.6)
      ),
      child: Text(
        tagName,
        style: TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: 9,
            color: txtColor
        ),
      ),
    );
  }
}