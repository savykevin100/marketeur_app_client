import 'package:flutter/material.dart';
import 'package:marketeur_follow_me/composants/decoration_text_field.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Test extends StatefulWidget {
  static String id ="test.dart";
  static String ida ;
  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    obtenir();
  }
  @override
  
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child:  Column(
          children: <Widget>[
            TextField(
              decoration: inputDecoration("valeur", Icons.ac_unit),
              onChanged: (value){
            ajouter(value);
      }
            ),
            Text("${Test.ida}"),
          ],
        ),
      ),
    );
  }

  void obtenir() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String val = sharedPreferences.getString("val");
    if(val!=null){
      setState(() {
        Test.ida = val;
      });
    }
  }

  void ajouter( String str) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Test.ida = str;
    await sharedPreferences.setString("val", Test.ida);
    obtenir();
  }
}