import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:marketeur_follow_me/modeles/hexadecimal.dart';

Widget container(Widget widget) {
  return Padding(
    padding: EdgeInsets.only(right: 30.0, left: 30.0),
    child: Container(
       height: 80.0,
      decoration: BoxDecoration(
       border: Border(
         bottom: BorderSide(width: 1.0, color: HexColor('#001C36'))
       )
      ),
      child: widget,
    ),
  );
}