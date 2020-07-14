import 'package:flutter/material.dart';
import 'package:marketeur_follow_me/authentification/inscription.dart';
import 'package:marketeur_follow_me/panier.dart';
import 'package:marketeur_follow_me/navigation_pages/premiere_page.dart';
import 'package:marketeur_follow_me/pages/choixConnexionInscription.dart';
import 'package:marketeur_follow_me/authentification/connexion.dart';
import 'package:marketeur_follow_me/pages/test_page.dart';
import 'package:marketeur_follow_me/profile.dart';
import 'package:marketeur_follow_me/panier.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  

  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(),
      debugShowCheckedModeBanner: false,
      initialRoute: Panier.id,
      routes: {
        FirstPage.id: (context) => FirstPage(),
        Connexion.id: (context) => Connexion(),
        Inscription.id: (context) => Inscription(),
        Allnavigation_pages.id: (context) => Allnavigation_pages(),
        Test.id:(context) => Test(),
        UserProfil.id:(context) => UserProfil(),
        Panier.id:(context) => Panier(),
      },
    );

  }


  
}
