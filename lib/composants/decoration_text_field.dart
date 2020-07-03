import 'package:flutter/material.dart';
import 'package:marketeur_follow_me/modeles/hexadecimal.dart';

InputDecoration inputDecoration(String data, IconData icon) {
  return InputDecoration(
      border: InputBorder.none,
      prefixIcon: Padding(
        padding: EdgeInsets.only(top: 50, bottom: 5,right: 10),
       child: Icon(
          icon,
          color: HexColor('#001C36'),
          size: 25.0,
        ),
      ),
      contentPadding: EdgeInsets.only(top: 50, bottom: 5, left:40),
      hintText: data,
      hintStyle: TextStyle(
          color: HexColor('#001C36'),
          fontSize: 16.0,
          fontFamily: 'Regular')
  );
}