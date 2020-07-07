import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:marketeur_follow_me/authentification/page_renseignement.dart';
import 'package:marketeur_follow_me/navigation_pages/accueil.dart';
import 'package:marketeur_follow_me/navigation_pages/panier.dart';
import 'package:marketeur_follow_me/navigation_pages/chat.dart';
import 'package:marketeur_follow_me/navigation_pages/favoris.dart';
import 'package:marketeur_follow_me/modeles/hexadecimal.dart';
import 'categories.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Allnavigation_pages extends StatefulWidget {
  static String id = 'all_navigation_pages';

  @override
  _Allnavigation_pagesState createState() => _Allnavigation_pagesState();
}

class _Allnavigation_pagesState extends State<Allnavigation_pages> {
  PageController pageController;
  FirebaseUser utilisateurConnecte;
 String email;
  int page = 0;
  final _auth = FirebaseAuth.instance;


/*Obtention des élements de l'utilisateur connecté */
  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser();
      if (user != null) {
        utilisateurConnecte = user;
      }
    } catch (e) {
      print(e);
    }
  }
/*Fin de la fonction */

  @override
  void initState() {
    getCurrentUser();
    super.initState();
    pageController = PageController(initialPage: 0);
    print("Ceci est le sharedPreferences ${Renseignement1.infos_utilisateur_connnecte}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: PageView(
        controller: pageController,
        children: <Widget>[
          Accueil(),
          Favoris(),
          Categories(),
          Chat(),
          Panier(),
        ],
        onPageChanged: (int index) {
          setState(() {
            pageController.jumpToPage(index);
          });
        },
      ),
      bottomNavigationBar: CurvedNavigationBar(
          backgroundColor:Colors.white.withOpacity(0.9),
          index: 0,
          items: <Widget>[
            /* */
            Icon(Icons.home, size: 30, color: Colors.white),
            Icon(Icons.favorite, size: 30, color: Colors.white),
            Icon(Icons.category, size: 30, color: Colors.white),
            Icon(Icons.chat_bubble, size: 30, color: Colors.white),
            Icon(Icons.shopping_basket, size: 30, color: Colors.white),
          ],
          onTap: (index) {
            setState(() {
              pageController.jumpToPage(index);
            });
          },
          buttonBackgroundColor:HexColor("#001C36"),
          color: HexColor("#001C36")),
    );
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

}