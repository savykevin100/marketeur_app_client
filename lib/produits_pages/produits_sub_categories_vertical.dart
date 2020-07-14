import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:marketeur_follow_me/articles/article_sans_taille.dart';
import 'package:marketeur_follow_me/authentification/page_renseignement.dart';
import 'package:marketeur_follow_me/composants/appBar.dart';
import 'package:marketeur_follow_me/composants/calcul.dart';
import 'package:marketeur_follow_me/modeles/firestore_service.dart';
import 'package:marketeur_follow_me/modeles/hexadecimal.dart';
import 'package:marketeur_follow_me/modeles/panier_classe.dart';
import 'package:marketeur_follow_me/modeles/produit.dart';
import 'package:marketeur_follow_me/modeles/produits_favoris_user.dart';
import 'package:marketeur_follow_me/modeles/utilisateurs.dart';
import 'package:marketeur_follow_me/panier.dart';
import 'package:marketeur_follow_me/panier.dart';
import 'package:search_app_bar/filter.dart';
import 'package:search_app_bar/search_app_bar.dart';
class Produits_sous_categories_vertical extends StatefulWidget {
  static bool cp = true;
  @override
  _Produits_sous_categories_verticalState createState() =>
      _Produits_sous_categories_verticalState();
}

class _Produits_sous_categories_verticalState
    extends State<Produits_sous_categories_vertical> {
  List<String> idDocuments = [];
  Firestore _db = Firestore.instance;
  final _auth = FirebaseAuth.instance;
  FirebaseUser utilisateurConnecte;
  Map<String, dynamic> utilisateur;
  int indice;
  String currentUserId;/// contient l'id de l'utilisateur connecté
  int nbAjoutPanier;
  int ajoutPanier;



/*Cette fonction permet d'avoir l'identifiant de l'utilisateur connecté dans la base de donnée  */
  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser();
      if (user != null) {
        utilisateurConnecte = user;
        await _db
            .collection("Utilisateurs")
            .getDocuments()
            .then((QuerySnapshot snapshot) {
          for (int i = 0; i < snapshot.documents.length; i++) {
            idDocuments.add(snapshot.documents[i].documentID);
            if (snapshot.documents[i].data["email"] ==
                utilisateurConnecte.email) {
              indice = i;
              utilisateur = snapshot.documents[i].data;
            }
          }
          setState(() {
            currentUserId = idDocuments[indice];
          });
        });
      }
    } catch (e) {
      print(e);
    }
  }
/*Fin de la fonction */

  void getNombreProduitPanier() {
    _db.collection("Utilisateurs").document(Renseignement1.infos_utilisateur_connnecte).collection("Panier")
        .document("AjoutPanierBadge").get().then((value){
      setState(() {
         ajoutPanier=value.data["nombreAjout"];
        print(value.data["nombreAjout"]);
         print("Ceci est le ajoutPanier ${ajoutPanier}");
      });
    });
  }

/* Cette fonction permet d'ajouter un produit dans ProduitsFavorisUser(collection composant le produit personnel
de l'utilisateur pour la selection des images et l'ajout des favoris
 */
  void idProduitsFavorisUser(Produit produit, BuildContext context) async{
    if (currentUserId != null) {
       try {
         Firestore.instance.collection("Utilisateurs").document(currentUserId).collection("ProduitsFavoirsUser")
         .where("imagePrincipaleProduit", isEqualTo: produit.image1)
         .getDocuments().then((QuerySnapshot snapshot){
           if(snapshot.documents.isEmpty){
             FirestoreService().addProduitFavorisUser(ProduitsFavorisUser(
                 imagePrincipaleProduit: produit.image1,
                 imageSelect: produit.image1,
                 quantite: 1,
                 etatIconeFavoris: false
             ), currentUserId);
           }
           print(snapshot.documents.isEmpty);
         });
       } catch (e){
         print(e);
       }
    }
  }
  /*Fin de la fonction*/
  void initState() {
    getCurrentUser();
    getNombreProduitPanier();
    print(Renseignement1.infos_utilisateur_connnecte);
  }
/// Pour la prochaine fois que je vais revenir je me suis arrêté ici, je teste la fonction function pour le panier
  ///
  ///
  /// 
  Text function() {
    StreamBuilder(
        stream: FirestoreService().getNombreProduitPanier(Renseignement1.infos_utilisateur_connnecte),
        builder: (BuildContext context,
            AsyncSnapshot<List<PanierClasse>> snapshot) {
          if(snapshot.hasError || !snapshot.hasData){
            return Text("");
          } else {
            for(int i=0; i<snapshot.data.length; i++) {
              if(snapshot.data[i].description=="AjoutPanierBadge"){
                setState(() {
                  nbAjoutPanier=snapshot.data[i].nombreAjout;
                });
              }
            }
            return Text("${nbAjoutPanier}");
          }
        }
    );
  }
  @override
  Widget build(BuildContext context) {
    AppBarClasse _appBar = AppBarClasse(titre: "Article",  context: context, currentUserId: Renseignement1.infos_utilisateur_connnecte);

    return Scaffold(
        backgroundColor: HexColor("#FFFFFF"),
        appBar:SearchAppBar<String>(
          backgroundColor: HexColor("#001c36"),
          title: Text(
            "Produits_sous_catégories",
            style: TextStyle(color: Colors.white, fontFamily: "MonseraBold"),
          ),
          searcher: null,
          filter: Filters.startsWith,
          iconTheme: IconThemeData(color: Colors.white),
          actions: <Widget>[
            Badge(
              badgeContent: function(),
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
        ),
        body: (currentUserId != null )
            ? StreamBuilder(
                stream: FirestoreService().getProduit(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<Produit>> snapshot) {
                  if (snapshot.hasError || !snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    return StaggeredGridView.countBuilder(
                      reverse: false,
                      crossAxisCount: 4,
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, index) {
                        Produit produit = snapshot.data[index];
                        return Container(
                          padding:
                              EdgeInsets.only(top: 30, right: 10, left: 10),
                          child: InkWell(
                              onTap: () {
                                idProduitsFavorisUser(produit, context);
                                print(currentUserId);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ArticleSansTaille(produit, currentUserId)));
                              },
                              child: Card(
                                elevation: 5.0,
                                child: Container(
                                  height: longueurPerCent(200, context),
                                  width: largeurPerCent(200, context),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        height: longueurPerCent(160, context),
                                        width: largeurPerCent(200, context),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(5),
                                                topRight: Radius.circular(5)),
                                            image: DecorationImage(
                                                image: NetworkImage(
                                                    produit.image1),
                                                fit: BoxFit.cover)),
                                      ),
                                      Container(
                                          height: longueurPerCent(40, context),
                                          width: largeurPerCent(200, context),
                                          child: Center(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: <Widget>[
                                                Text(
                                                  produit.nomDuProduit,
                                                  style: TextStyle(
                                                      color:
                                                          HexColor("#001C36"),
                                                      fontFamily:
                                                          "MonseraBold"),
                                                ),
                                                Text(
                                                  produit.prix,
                                                  style: TextStyle(
                                                      color:
                                                          HexColor("#001C36"),
                                                      fontFamily:
                                                          "MonseraBold"),
                                                ),
                                              ],
                                            ),
                                          )),
                                    ],
                                  ),
                                ),
                              )),
                        );
                      },
                      staggeredTileBuilder: (_) => StaggeredTile.fit(2),
                      mainAxisSpacing: 20.0,
                      crossAxisSpacing: 20.0,
                    );
                  }
                })
            : Center(child: CircularProgressIndicator()));
  }
}
