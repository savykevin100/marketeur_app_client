import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:marketeur_follow_me/composants/calcul.dart';
import 'package:marketeur_follow_me/modeles/hexadecimal.dart';
import 'package:search_app_bar/filter.dart';
import 'package:search_app_bar/search_app_bar.dart';

class Panier extends StatefulWidget {
  static String id='Panier';
  @override
  _PanierState createState() => _PanierState();
}

class _PanierState extends State<Panier> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SearchAppBar<String>(
        backgroundColor: HexColor("#001c36"),
        title: Text("Panier", style: TextStyle(color: Colors.white, fontFamily: "MonseraBold"),),
        searcher: null,
        filter: Filters.startsWith,
        iconTheme: IconThemeData(color: Colors.white),

        actions: <Widget>[
          IconButton(icon: Icon(Icons.shopping_basket, color: Colors.white,), onPressed: null)
        ],

      ),
      drawer: Drawer(

      ),
      body: new SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                SizedBox(height: longueurPerCent(17.0, context),),
                Container(
                  height: longueurPerCent(28.0, context),
                  width: largeurPerCent(160.0, context),
                  margin: EdgeInsets.only(left: longueurPerCent(13.0, context),top: longueurPerCent(17.0, context)),
                  child: Center(
                    child: Text(
                      "Ajouts récents",
                      style: TextStyle(color: HexColor("#001C36"), fontFamily: 'MontserratBold', fontSize: 24.0, fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Container(
                  height: longueurPerCent(13.0, context),
                  width: largeurPerCent(115.0, context),
                  margin: EdgeInsets.only(left: longueurPerCent(111.0, context),top: longueurPerCent(17.0, context)),
                  child: Center(
                    child: Text(
                      "Tout sélectionner",
                      style: TextStyle(color: HexColor("#001C36"), fontFamily: 'MontserratBold', fontSize: 13.0, fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: longueurPerCent(43.0, context),),
            Container(
              child:Row(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left:longueurPerCent(0.0, context),top: longueurPerCent(0.0, context),),
                    child: Checkbox(value: false,
                      activeColor: Colors.green,
                      onChanged: (bool newValue){
                        setState(() {

                        });
                      },
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: longueurPerCent(0.0, context),top: longueurPerCent(0.0, context),),
                    height: longueurPerCent(100, context),
                    width: largeurPerCent(95.5, context),
                    child: Card(
                      child: Container(
                        child: ClipRRect(
                          borderRadius:
                          BorderRadius.circular(12.0),
                          child: Image.asset("assets/images/icons8vêtements100.png",
                            fit: BoxFit.cover,),

                        ),
                      ),
                    ),
                  ),
                  Column(
                    children: <Widget>[
                       Container(
                         margin: EdgeInsets.only(right: longueurPerCent(50, context),left: longueurPerCent(4.0, context)),
                        child: Text(
                          "Habit propre",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: HexColor("#909090"),
                              fontSize: 18,
                              fontFamily: "Regular"),
                        ),
                      ),
                      SizedBox(height:longueurPerCent(4.0, context),),
                      Container(
                        margin: EdgeInsets.only(right:longueurPerCent(60, context),left: longueurPerCent(4.0, context) ),
                        child: Text(
                          "89.000 F CFA",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: HexColor("#001C36"),
                              fontSize: 15,
                              fontFamily: "MontserratBold",
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(left: longueurPerCent(40.0, context)),
                    child: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red,size: 30,),
                      onPressed: (){
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: longueurPerCent(13.0, context),),
            Container(
              width: largeurPerCent(360.0, context),
              height: longueurPerCent(1.0, context),
              child: Divider(
                color: HexColor("#707070"),
              ),
            ),

// Deuxieme article
            SizedBox(height: longueurPerCent(20.0, context),),
            Container(
              child:Row(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left:longueurPerCent(0.0, context),top: longueurPerCent(0.0, context),),
                    child: Checkbox(value: false,
                      activeColor: Colors.green,
                      onChanged: (bool newValue){
                        setState(() {

                        });
                      },
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: longueurPerCent(0.0, context),top: longueurPerCent(0.0, context),),
                    height: longueurPerCent(100, context),
                    width: largeurPerCent(95.5, context),
                    child: Card(
                      child: Container(
                        child: ClipRRect(
                          borderRadius:
                          BorderRadius.circular(12.0),
                          child: Image.asset("assets/images/icons8vêtements100.png",
                            fit: BoxFit.cover,),

                        ),
                      ),
                    ),
                  ),
                  Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(right: longueurPerCent(50, context),left: longueurPerCent(4.0, context)),
                        child: Text(
                          "Habit propre",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: HexColor("#909090"),
                              fontSize: 18,
                              fontFamily: "Regular"),
                        ),
                      ),
                      SizedBox(height:longueurPerCent(4.0, context),),
                      Container(
                        margin: EdgeInsets.only(right:longueurPerCent(60, context),left: longueurPerCent(4.0, context) ),
                        child: Text(
                          "89.000 F CFA",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: HexColor("#001C36"),
                            fontSize: 15,
                            fontFamily: "MontserratBold",
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(left: longueurPerCent(40.0, context)),
                    child: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red,size: 30,),
                      onPressed: (){
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: longueurPerCent(13.0, context),),
            Container(
              width: largeurPerCent(360.0, context),
              height: longueurPerCent(1.0, context),
              child: Divider(
                color: HexColor("#707070"),
              ),
            ),
            SizedBox(height:longueurPerCent(142.0, context)),
            Container(
              padding: EdgeInsets.only(right: longueurPerCent(16.0, context),left: longueurPerCent(16.0, context),top: largeurPerCent(6.0, context),),
              height: longueurPerCent(54.0, context),
              width: largeurPerCent(200.0, context),
              child: Material(
                borderRadius: BorderRadius.circular(7.0),
                //shadowColor: Colors.greenAccent,
                color: HexColor("#001C36"),
                elevation: 7.0,
                child: GestureDetector(
                  onTap: () {},
                  child: Center(
                    child: Text(
                      'ACHETER',
                      style: TextStyle(color: HexColor("#FFFFFF"), fontFamily: 'MontserratBold', fontSize: 12.0, fontWeight: FontWeight.bold ),
                    ),
                  ),
                ),
              ),

            ),
          ],
        ),
      )
    );
  }
}