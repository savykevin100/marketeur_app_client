import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:marketeur_follow_me/modeles/firestore_service.dart';
import 'package:marketeur_follow_me/modeles/hexadecimal.dart';
import 'package:marketeur_follow_me/modeles/panier_classe.dart';
import 'package:marketeur_follow_me/navigation_pages/panier.dart';
import 'package:search_app_bar/filter.dart';
import 'package:search_app_bar/search_app_bar.dart';

class AppBarClasse{
  String titre;
  int nbAjoutPanier;
  BuildContext context;
  String currentUserId;

  AppBarClasse.nb({this.titre, this.nbAjoutPanier, this.context});
  AppBarClasse({this.titre, this.context, this.currentUserId});


  Widget appBarFunction(){
    return SearchAppBar<String>(
      backgroundColor: HexColor("#001c36"),
      title: Text(
        titre,
        style: TextStyle(color: Colors.white, fontFamily: "MonseraBold"),
      ),
      searcher: null,
      filter: Filters.startsWith,
      iconTheme: IconThemeData(color: Colors.white),
      actions: <Widget>[
        Badge(
          badgeContent: Text("${nbAjoutPanier}"),
          toAnimate: true,
          position: BadgePosition.topRight(top:   0,  right: 0),
          child: IconButton(
              icon: Icon(
                Icons.shopping_basket,
                color: Colors.white,
              ),
              onPressed: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            Panier()));
              }),
        )

      ],
    );
  }

  Widget appBarFunctionStream(){
    return SearchAppBar<String>(
      backgroundColor: HexColor("#001c36"),
      title: Text(
        titre,
        style: TextStyle(color: Colors.white, fontFamily: "MonseraBold"),
      ),
      searcher: null,
      filter: Filters.startsWith,
      iconTheme: IconThemeData(color: Colors.white),
      actions: <Widget>[
        Badge(
          badgeContent: StreamBuilder(
            stream: FirestoreService().getNombreProduitPanier(currentUserId),
              builder: (BuildContext context,
              AsyncSnapshot<List<PanierClasse>> snapshot) {
               if(snapshot.hasError || !snapshot.hasData){
                 return Text("");
               } else {
               for(int i=0; i<snapshot.data.length; i++) {
                 if(snapshot.data[i].description==null){
                   nbAjoutPanier=snapshot.data[i].nombreAjout;
                 }
                }
               return Text("${nbAjoutPanier}");
               }
              }
          ),
          toAnimate: true,
          position: BadgePosition.topRight(top:   0,  right: 0),
          child: IconButton(
              icon: Icon(
                Icons.shopping_basket,
                color: Colors.white,
              ),
              onPressed: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            Panier()));
              }),
        )

      ],
    );
  }

}




