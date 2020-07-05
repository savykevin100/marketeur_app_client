import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:marketeur_follow_me/articles/article_sans_taille.dart';
import 'package:marketeur_follow_me/composants/calcul.dart';
import 'package:marketeur_follow_me/modeles/firestore_service.dart';
import 'package:marketeur_follow_me/modeles/hexadecimal.dart';
import 'package:marketeur_follow_me/modeles/produit.dart';
import 'package:marketeur_follow_me/modeles/utilisateurs.dart';
import 'package:search_app_bar/filter.dart';
import 'package:search_app_bar/search_app_bar.dart';

class Favoris extends StatefulWidget {
  static const String routeName = 'favoris';

  @override
  _FavorisState createState() => _FavorisState();
}

class _FavorisState extends State<Favoris> {

  Favoris favoris;
  Firestore  _db = Firestore.instance;
  DocumentSnapshot indexDelete;
  List<String> idDocuments=[];
  final _auth = FirebaseAuth.instance;
  FirebaseUser utilisateurConnecte;
  int indice;
  String currentUserId;
  Map<String, dynamic> utilisateur;
  String idFavorisProduit;
  String id_produit;
  String etatIconeFavoris;


  ///Cette fonction permet d'avoir l'identifiant de l'utilisateur connecté dans la base de donnée  */
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


void recuperationIdProduit(Produit produit){
  Firestore.instance.collection("Utilisateurs").document(currentUserId).collection("ProduitsFavoirsUser")
  .where("imagePrincipaleProduit", isEqualTo: produit.image1)
  .getDocuments().then((QuerySnapshot snapshot){
    id_produit = snapshot.documents[0].documentID;
    print(id_produit);
  });
 /* _db.collection("Utilisateurs").document(currentUserId).collection("ProduitsFavoirsUser").
  getDocuments().then((QuerySnapshot snapshot) {
    for (int i = 0; i < snapshot.documents.length; i++) {
      if (snapshot.documents[i].data["imagePrincipaleProduit"] == produit.image1) {
        setState(() {
          id_produit = snapshot.documents[i].documentID;
        });
        print(id_produit);
      }
    }
  });*/
}

/// Permet d'obtenir l'id du produit dans les favoris lors qu'on veut supprimer
  void getIdFavoris(Produit produit) async{
    await  _db
        .collection("Utilisateurs")
        .document(currentUserId)
        .collection("Favoris")
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      if(snapshot.documents.isEmpty) {

      } else {
        for(int i=0; i<snapshot.documents.length; i++){
          if(snapshot.documents[i].data["image1"] == produit.image1){
            setState(() {
              idFavorisProduit = snapshot.documents[i].documentID;
            });

          }
        }
      }
    });
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();

  }
/* */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SearchAppBar<String>(
        backgroundColor: HexColor("#001c36"),
        title: Text(
          "Favoris",
          style: TextStyle(color: Colors.white, fontFamily: "MonseraBold"),
        ),
        searcher: null,
        filter: Filters.startsWith,
        iconTheme: IconThemeData(color: Colors.white),
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.shopping_basket,
                color: Colors.white,
              ),
              onPressed: null)
        ],
      ),
      drawer: Drawer(

      ),
      body:  (currentUserId!=null )?Container(
        margin: EdgeInsets.only(left: 10, right: 10, top: 10),
        child: StreamBuilder(
            stream: FirestoreService().getFavoris("$currentUserId"),
            builder: (BuildContext context,
                AsyncSnapshot<List<Produit>> snapshot) {
              if (snapshot.hasError || !snapshot.hasData) {
                return Center( child:CircularProgressIndicator());
              } else {
                return StaggeredGridView.countBuilder(
                  itemCount: snapshot.data.length,
                  crossAxisCount: 4,
                  itemBuilder: (BuildContext context, index) {
                    Produit produit = snapshot.data[index];
                    return Container(
                      child: InkWell(
                        onTap: () async{
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ArticleSansTaille(
                                      produit, currentUserId
                                  )));

                        },
                        child: Card(
                          elevation: 5.0,
                          child: Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Stack(
                                  children: <Widget>[
                                    Container(
                                      height: longueurPerCent(200, context),
                                      child: ClipRRect(
                                        borderRadius:
                                        BorderRadius.circular(5.0),
                                        child: Image.network(
                                          "${produit.image1}",
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                        top: 5,
                                        right: 0,
                                        child: IconButton(icon: Icon(Icons.delete, color: Colors.red,size: 30,),
                                            onPressed:() {
                                              recuperationIdProduit(produit);
                                              getIdFavoris(produit);
                                             if(id_produit!=null){
                                               FirestoreService().deleteFavoris(currentUserId, idFavorisProduit);
                                               _db
                                                   .collection("Utilisateurs")
                                                   .document(currentUserId).collection("ProduitsFavoirsUser")
                                                   .document(id_produit)
                                                   .updateData({"etatIconeFavoris":false});
                                             }
                                              /*  try {
                                              produit.iconeFavoris = true;
                                              print(produit.iconeFavoris);
                                                await  _db
                                                    .collection('Utilisateurs')
                                                    .document(currentUserId)
                                                    .collection("Favoris")
                                                    .document(produit.idDocumentsFavoris)
                                                    .delete();

                                                print(produit.idDocumentsFavoris);
                                                print(index);

                                            } catch (e) {
                                              print(e.toString());
                                            }*/
                                            }
                                        )
                                    ),
                                  ],
                                ),

                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: largeurPerCent(10, context),
                                      vertical: longueurPerCent(10, context)),
                                  child: Text(
                                    "${produit.nomDuProduit}",
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 15,
                                        fontFamily: "Regular"),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: largeurPerCent(10, context),
                                      vertical: longueurPerCent(10, context)),
                                  child: Text(
                                    "${produit.prix}",
                                    style: TextStyle(
                                        color: HexColor("#001C36"),
                                        fontSize: 17,
                                        fontFamily: "Bold"),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  staggeredTileBuilder: (_) => StaggeredTile.fit(2),
                  mainAxisSpacing: 10.0,
                  crossAxisSpacing: 10.0,
                );
              }
            }),
      ): Center(child: CircularProgressIndicator())
    );


  }
}