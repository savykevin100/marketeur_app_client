import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:marketeur_follow_me/modeles/hexadecimal.dart';
import 'package:marketeur_follow_me/modeles/utilisateurs.dart';
import 'package:marketeur_follow_me/navigation_pages/chat.dart';
import 'package:marketeur_follow_me/navigation_pages/favoris.dart';
import 'package:marketeur_follow_me/panier.dart';
import 'package:marketeur_follow_me/navigation_pages/premiere_page.dart';
import 'package:marketeur_follow_me/pages/choixConnexionInscription.dart';

class ProfileSettings extends StatefulWidget {
  // final Widget creationHeader;
  //  ProfileSettings({this.creationHeader});

  @override
  _ProfileSettingsState createState() => _ProfileSettingsState();
}

class _ProfileSettingsState extends State<ProfileSettings> {
  final _auth = FirebaseAuth.instance;
  Utilisateur donneesUtilisateurConnecte;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          creationHeader(),
          drawerItem(
              icon: Icons.home,
              text: "Accueil",
              onTap: () {
                Navigator.pushNamed(context, Allnavigation_pages.id);
              }),
          drawerItem(
              icon: Icons.favorite,
              text: "Favoris",
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Favoris()));
              }),
          drawerItem(
              icon: Icons.notifications,
              text: "Notifications",
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Panier()));
              }),
          drawerItem(
              icon: Icons.chat_bubble,
              text: "Chat",
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Chat()));
              }),
          drawerItem(
              icon: Icons.shopping_basket,
              text: "Mes commandes",
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Chat()));
              }),
          drawerItem(
              icon: Icons.person,
              text: "Deconnexion",
              onTap: () async {
                await _auth.signOut();
                print("Reussie");
                Navigator.pushNamed(context, FirstPage.id);
              }),
          Divider(),
          drawerItem(
              icon: Icons.settings,
              text: "Paramètres",
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Chat()));
              }),
          drawerItem(
              icon: Icons.info,
              text: "À propos",
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Chat()));
              }),
        ],
      ),
    );
  }

  Widget creationHeader() {
    return UserAccountsDrawerHeader(
      decoration: BoxDecoration(
        color: HexColor('#001C36'),
      ),
      otherAccountsPictures: <Widget>[],
      // accountName: Text("${Renseignement1.infos_utilisateur_connnecte[1]}"),
      // accountEmail: Text("${Renseignement1.infos_utilisateur_connnecte[0]}",
      //     style: TextStyle(fontSize: 20)),
      currentAccountPicture: CircleAvatar(
          backgroundImage: AssetImage(
        "assets/images/user33312571280.png",
      )),
    );
  }

  Widget drawerItem({IconData icon, String text, GestureTapCallback onTap}) {
    return ListTile(
      title: Row(
        children: <Widget>[
          Icon(
            icon,
            color: Colors.grey,
          ),
          Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(
              text,
              style: TextStyle(
                  color: HexColor('#001C36'),
                  fontSize: 18.0,
                  fontFamily: 'Regular'),
            ),
          )
        ],
      ),
      onTap: onTap,
    );
  }
}
