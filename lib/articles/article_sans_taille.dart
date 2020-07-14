import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share_file/flutter_share_file.dart';
import 'package:marketeur_follow_me/composants/appBar.dart';
import 'package:marketeur_follow_me/composants/calcul.dart';
import 'package:marketeur_follow_me/modeles/firestore_service.dart';
import 'package:marketeur_follow_me/modeles/hexadecimal.dart';
import 'package:marketeur_follow_me/modeles/panier_classe.dart';
import 'package:marketeur_follow_me/modeles/produit.dart';
import 'package:marketeur_follow_me/modeles/produits_favoris_user.dart';
class ArticleSansTaille extends StatefulWidget {
  Produit produit;
  String currentUserId;
  ArticleSansTaille(this.produit, this.currentUserId);
  @override
  _ArticleSansTailleState createState() => _ArticleSansTailleState();
}

class _ArticleSansTailleState extends State<ArticleSansTaille> {
    //  String imageCliquer = widget.produit.image1;
    int index = 1;
    Firestore _db = Firestore.instance;
    String id_produit;/// Cette variable permet de contenir l'id du produit affiché au niveau de produitFavorisUser
    int quantite; /// afiiche la quantite du produit que le client
    bool etatIconeFavoris; /// Variable permettant de changer la couleur de l'icone et la gestion de la couleur
    String idFavorisProduit;
    int ajoutPanier; /// Variable contenant le nombre de produit ajouter aux favoris à chaque ajout



    void getIdFavoris() async{
      await  _db
          .collection("Utilisateurs")
          .document(widget.currentUserId)
          .collection("Favoris")
          .getDocuments()
          .then((QuerySnapshot snapshot) {
        if(snapshot.documents.isEmpty) {

        } else {
          for(int i=0; i<snapshot.documents.length; i++){
            if(snapshot.documents[i].data["image1"] == widget.produit.image1){
              setState(() {
                idFavorisProduit = snapshot.documents[i].documentID;
                print("C'est ${idFavorisProduit}");
              });

            }
          }
        }
      });
    }
    void getIdProduitFavorisUser(){
      _db.collection("Utilisateurs").document(widget.currentUserId).collection("ProduitsFavoirsUser").
      getDocuments().then((QuerySnapshot snapshot) {
        for (int i = 0; i < snapshot.documents.length; i++) {
          if (snapshot.documents[i].data["imagePrincipaleProduit"] == widget.produit.image1) {
            setState(() {
              id_produit = snapshot.documents[i].documentID;
              quantite = snapshot.documents[i].data["quantite"];
              etatIconeFavoris = snapshot.documents[i].data["etatIconeFavoris"];
              ajoutPanier = snapshot.documents[i].data["ajoutPanier"];
            });
            print(id_produit);
          }
        }
      });
    }
    void getNombreProduitPanier(){
      _db.collection("Utilisateurs").document(widget.currentUserId).collection("Panier")
          .document("AjoutPanierBadge").get().then((value){
        setState(() {
          ajoutPanier=value.data["nombreAjout"];
          print("c'est ${ajoutPanier}");
        });
      });
    }

   @override
  void initState() {
      getIdProduitFavorisUser();
      getNombreProduitPanier();
      getIdFavoris();
     super.initState();
  }
   
  @override
  Widget build(BuildContext context) {
    AppBarClasse _appBar = AppBarClasse.nb(titre: "Article", nbAjoutPanier: ajoutPanier, context: context);

    return (id_produit!=null && etatIconeFavoris!=null && ajoutPanier!=null)?Scaffold(
      appBar: _appBar.appBarFunction(),
      body:Container(
        child: Stack(children: <Widget>[
          Positioned(
              top: longueurPerCent(20, context),
              left: largeurPerCent(10, context),
              child: Text(widget.produit.nomDuProduit,
                  style: TextStyle(
                      color: HexColor("#909090"),
                      fontFamily: "MonseraLight",
                      fontSize: 20))),
          Positioned(
              top: longueurPerCent(50, context),
              left: largeurPerCent(10, context),
              child: Text(widget.produit.prix,
                  style: TextStyle(
                      color: HexColor("#001c36"),
                      fontFamily: "MonseraBold",
                      fontSize: 20))),
          Positioned(
              top: longueurPerCent(80, context),
              left: largeurPerCent(10, context),
              child: Text("Quantité",
                  style: TextStyle(
                      color: HexColor("#909090"),
                      fontFamily: "MonseraRegular",
                      fontSize: 15))),
          Positioned(
            top: longueurPerCent(65, context),
            left: largeurPerCent(80, context),
            child: IconButton(
              onPressed: (){
               if(quantite>1){
                 setState(() {
                   print("moins");
                   quantite = quantite-1;
                   _db
                       .collection("Utilisateurs")
                       .document(widget.currentUserId).collection("ProduitsFavoirsUser")
                       .document(id_produit)
                       .updateData({"quantite": quantite});

                 });
                }
              },
              icon: Icon(Icons.remove, color: HexColor("#959595"),size: 20,),
            ),
          ),
          Positioned(
            top: longueurPerCent(65, context),
            left: largeurPerCent(110, context),
            child: FlatButton(
              onPressed: null,
              child: Text(
                "${quantite}",
                style: TextStyle(
                    color: HexColor("#959595"),
                    fontFamily: "Light",
                    fontSize: 20),
              ),
            ),
          ),
          Positioned(
            top: longueurPerCent(65, context),
            left: largeurPerCent(180, context),
            child: IconButton(
              onPressed: (){
                if(quantite<widget.produit.quantite){
                  setState(() {
                    print("plus");
                    quantite = quantite+1;
                    _db
                        .collection("Utilisateurs")
                        .document(widget.currentUserId).collection("ProduitsFavoirsUser")
                        .document(id_produit)
                        .updateData({"quantite": quantite});

                  });
                }
              },
              icon: Icon(Icons.add, color: HexColor("#959595"),size: 20,),
            ),
          ),

          Positioned(
            top: longueurPerCent(20, context),
            right: largeurPerCent(10, context),
            child: InkWell(
              onTap: () {
                // FlutterShareFile.shareImage(widget.produit.image, "image");
              },
              child: GestureDetector(
                onTap: (){
                    _db .collection("Utilisateurs")
                        .document(widget.currentUserId).collection("Panier").where("image1", isEqualTo: widget.produit.image1)
                        .getDocuments().then((QuerySnapshot snapshot){
                       if(snapshot.documents.isEmpty){
                        setState(() {
                          ajoutPanier++;
                          FirestoreService().addPanierSansId(PanierClasse(
                              nomDuProduit: widget.produit.nomDuProduit,
                              image1: widget.produit.image1,
                              prix: widget.produit.prix,
                              description: widget.produit.description,
                              quantiteCommander: quantite
                          ), widget.currentUserId, );
                          _db
                              .collection("Utilisateurs")
                              .document(widget.currentUserId).collection("Panier")
                              .document("AjoutPanierBadge")
                              .updateData({"nombreAjout": ajoutPanier});
                        });
                       }
                    });
                },
                child: Container(
                  height: longueurPerCent(37, context),
                  width: largeurPerCent(200, context),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: HexColor("#FFC30D"),
                  ),
                  child: Center(
                    child: Text(
                      "AJOUTER AU PANIER",
                      style: TextStyle(
                          color: HexColor('#001C36'),
                          fontFamily: "MonseraBold",
                          fontSize: 13),
                    ),
                  ),
                ),
              ),
            ),
          ),



          /// Partie icone favoris
          Positioned(
              top: longueurPerCent(70, context),
              right: largeurPerCent(20, context),
              child: GestureDetector(
                  onTap: () async{
                    getIdFavoris();
                    if(etatIconeFavoris == false){
                      setState(() {
                        print("ajout");
                        etatIconeFavoris = true;
                         FirestoreService().addFavoris(widget.produit,widget.currentUserId);
                        _db
                            .collection("Utilisateurs")
                            .document(widget.currentUserId).collection("ProduitsFavoirsUser")
                            .document(id_produit)
                            .updateData({"etatIconeFavoris":etatIconeFavoris});
                      });
                    } else {
                      setState(() {
                        print("supprimer");
                        etatIconeFavoris = false;
                         _db
                            .collection("Utilisateurs")
                            .document(widget.currentUserId).collection("ProduitsFavoirsUser")
                            .document(id_produit)
                            .updateData({"etatIconeFavoris":etatIconeFavoris});
                        FirestoreService().deleteFavoris(widget.currentUserId, idFavorisProduit);
                      });
                    }
                  },
                  child: Icon((etatIconeFavoris == false)?Icons.favorite_border:Icons.favorite, color: Colors.red, size:30,))),
          /// Fin partie icone favoris


          imageApparition(),
          Positioned(
              top: longueurPerCent(390, context),
              left: largeurPerCent(20, context),
              child: Text("Couleur",
                  style: TextStyle(
                      color: HexColor("#001C36"),
                      fontFamily: "MonseraRegular",
                      fontSize: 18))),
          Positioned(
              top: longueurPerCent(390, context),
              right: largeurPerCent(150, context),
              child: Text("Taille",
                  style: TextStyle(
                      color: HexColor("#001C36"),
                      fontFamily: "MonseraRegular",
                      fontSize: 18))),
          Positioned(
              top: longueurPerCent(410, context),
              left: largeurPerCent(5, context),
              right: largeurPerCent(5, context),
              child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(30))),
                  child: Container(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        widget.produit.description,
                        style: TextStyle(
                            fontFamily: "MonseraLight", fontSize: 15),
                      )))),
          Positioned(
            top: longueurPerCent(570, context),
            left: largeurPerCent(20, context),
            child: InkWell(
              onTap: () {
                // Navigator.push(context,
                //     MaterialPageRoute(builder: (context) => Commander(
                //       produit: widget.produit,
                //     )));
              },
              child: Container(
                height: longueurPerCent(37, context),
                width: largeurPerCent(180, context),
                decoration: BoxDecoration(
                    color: HexColor('#001C36'),
                    border: Border.all(color: HexColor('#001C36'), width: 1),
                    borderRadius: BorderRadius.circular(10)),
                child: Center(
                  child: Text(
                    "ACHETER",
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: "MonseraBold",
                        fontSize: 13),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: longueurPerCent(570, context),
            right: largeurPerCent(20, context),
            child: InkWell(
              onTap: () {
                // FlutterShareFile.shareImage(widget.produit.image, "image");
              },
              child: Container(
                height: longueurPerCent(37, context),
                width: largeurPerCent(180, context),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.yellow,
                ),
                child: Center(
                  child: Text(
                    "RECOMMANDER",
                    style: TextStyle(
                        color: HexColor('#001C36'),
                        fontFamily: "MonseraBold",
                        fontSize: 13),
                  ),
                ),
              ),
            ),
          ),
        ]),
      )
    ):Scaffold(
      body:Center(child: CircularProgressIndicator(),)
    );
  }
///Cette fonction permet d'afficher les images secondaires en fonction de leurs nombres
  Widget imageApparition(){
    if(widget.produit.numberImages==1){
      return Stack(
        children:<Widget>[

          Positioned(
            top: longueurPerCent(120, context),
            left: largeurPerCent(40, context),
            child: StreamBuilder(
                stream: _db.collection("Utilisateurs").document(widget.currentUserId).collection("ProduitsFavoirsUser").snapshots().map(
                      (snapshot) => snapshot.documents
                      .map(
                        (doc) => ProduitsFavorisUser.fromMap(doc.data, doc.documentID),
                  )
                      .toList(),
                ),
                builder: (BuildContext context,
                    AsyncSnapshot<List<ProduitsFavorisUser>> snapshot) {
                  if (snapshot.hasError || !snapshot.hasData) {
                    return Center(
                      child: null,

                    );
                  } else {
                    for (int i = 0; i < snapshot.data.length; i++) {
                      if (widget.produit.image1 == snapshot.data[i].imagePrincipaleProduit) {
                        ProduitsFavorisUser produit = snapshot.data[i];
                        return Container(
                          height: longueurPerCent(253, context),
                          width: largeurPerCent(300, context),
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: NetworkImage(produit.imageSelect),
                                  fit: BoxFit.cover)),
                        );
                      }
                    }
                    return null;
                  }
                }),
          ),
        ]
      );
    } else if(widget.produit.numberImages==2){
       return Stack(
         children:<Widget>[
           Positioned(
            top: longueurPerCent(120, context),
            left: largeurPerCent(10, context),
            child: StreamBuilder(
                stream: _db.collection("Utilisateurs").document(widget.currentUserId).collection("ProduitsFavoirsUser").snapshots().map(
                      (snapshot) => snapshot.documents
                          .map(
                            (doc) => ProduitsFavorisUser.fromMap(doc.data, doc.documentID),
                          )
                          .toList(),
                    ),
                builder: (BuildContext context,
                    AsyncSnapshot<List<ProduitsFavorisUser>> snapshot) {
                  if (snapshot.hasError || !snapshot.hasData) {
                    return Center(
                      child: null,
                    );
                  } else {
                    for (int i = 0; i < snapshot.data.length; i++) {
                      if (widget.produit.image1 == snapshot.data[i].imagePrincipaleProduit) {
                        ProduitsFavorisUser produit = snapshot.data[i];
                        return Container(
                          height: longueurPerCent(253, context),
                          width: largeurPerCent(262, context),
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: NetworkImage(produit.imageSelect),
                                  fit: BoxFit.cover)),
                        );
                      }
                    }
                    return null;
                  }
                }),
          ),
           Positioned(
            top: longueurPerCent(120, context),
            left: largeurPerCent(320, context),
            child: Container(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _db
                        .collection("Utilisateurs")
                        .document(widget.currentUserId).collection("ProduitsFavoirsUser")
                        .document(id_produit)
                        .updateData({"imageSelect": widget.produit.image1});
                    print(widget.produit.selectImage);
                  });
                },
                child: Container(
                  height: longueurPerCent(61, context),
                  width: largeurPerCent(63, context),
                  decoration: BoxDecoration(
                      border: Border.all(
                          width: largeurPerCent(2, context),
                          color: HexColor("#707070")),
                      image: DecorationImage(
                          image: NetworkImage(widget.produit.image1),
                          fit: BoxFit.cover)),
                ),
              ),
            ),
          ),
          Positioned(
            top: longueurPerCent(220, context),
            left: largeurPerCent(320, context),
            child: Container(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    print("2");
                    _db
                        .collection("Utilisateurs")
                        .document(widget.currentUserId).collection("ProduitsFavoirsUser")
                        .document(id_produit)
                        .updateData({"imageSelect": widget.produit.image2});
                    print(widget.produit.selectImage);
                  });
                },
                child: Container(
                  height: longueurPerCent(61, context),
                  width: largeurPerCent(63, context),
                  decoration: BoxDecoration(
                      border: Border.all(
                          width: largeurPerCent(2, context),
                          color: HexColor("#707070")),
                      image: DecorationImage(
                          image: NetworkImage(widget.produit.image2),
                          fit: BoxFit.cover)),
                ),
              ),
            ),
          ),
         ]
       );
    } else {
      return Stack(
         children:<Widget>[
           Positioned(
            top: longueurPerCent(120, context),
            left: largeurPerCent(10, context),
            child: StreamBuilder(
                stream: _db.collection("Utilisateurs").document(widget.currentUserId).collection("ProduitsFavoirsUser").snapshots().map(
                      (snapshot) => snapshot.documents
                      .map(
                        (doc) => ProduitsFavorisUser.fromMap(doc.data, doc.documentID),
                  )
                      .toList(),
                ),
                builder: (BuildContext context,
                    AsyncSnapshot<List<ProduitsFavorisUser>> snapshot) {
                  if (snapshot.hasError || !snapshot.hasData) {
                    return Center(
                      child: null,
                    );
                  } else {
                    for (int i = 0; i < snapshot.data.length; i++) {
                      if (widget.produit.image1 == snapshot.data[i].imagePrincipaleProduit) {
                        ProduitsFavorisUser produit = snapshot.data[i];
                        return Container(
                          height: longueurPerCent(253, context),
                          width: largeurPerCent(262, context),
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: NetworkImage(produit.imageSelect),
                                  fit: BoxFit.cover)),
                        );
                      }
                    }
                    return null;
                  }
                }),
          ),
           Positioned(
            top: longueurPerCent(120, context),
            left: largeurPerCent(320, context),
            child: Container(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _db
                        .collection("Utilisateurs")
                        .document(widget.currentUserId).collection("ProduitsFavoirsUser")
                        .document(id_produit)
                        .updateData({"imageSelect": widget.produit.image1});
                    print(widget.produit.selectImage);
                  });
                },
                child: Container(
                  height: longueurPerCent(61, context),
                  width: largeurPerCent(63, context),
                  decoration: BoxDecoration(
                      border: Border.all(
                          width: largeurPerCent(2, context),
                          color: HexColor("#707070")),
                      image: DecorationImage(
                          image: NetworkImage(widget.produit.image1),
                          fit: BoxFit.cover)),
                ),
              ),
            ),
          ),
          Positioned(
            top: longueurPerCent(220, context),
            left: largeurPerCent(320, context),
            child: Container(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    print("2");
                    _db
                        .collection("Utilisateurs")
                        .document(widget.currentUserId).collection("ProduitsFavoirsUser")
                        .document(id_produit)
                        .updateData({"imageSelect": widget.produit.image2});
                    print(widget.produit.selectImage);
                  });
                },
                child: Container(
                  height: longueurPerCent(61, context),
                  width: largeurPerCent(63, context),
                  decoration: BoxDecoration(
                      border: Border.all(
                          width: largeurPerCent(2, context),
                          color: HexColor("#707070")),
                      image: DecorationImage(
                          image: NetworkImage(widget.produit.image2),
                          fit: BoxFit.cover)),
                ),
              ),
            ),
          ),
           Positioned(
            top: longueurPerCent(310, context),
            left: largeurPerCent(320, context),
            child: Container(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    print("3");
                    _db
                        .collection("Utilisateurs")
                        .document(widget.currentUserId).collection("ProduitsFavoirsUser")
                        .document(id_produit)
                        .updateData({"imageSelect": widget.produit.image3});
                    print(widget.produit.selectImage);
                  });
                },
                child: Container(
                  height: longueurPerCent(61, context),
                  width: largeurPerCent(63, context),
                  decoration: BoxDecoration(
                      border: Border.all(
                          width: largeurPerCent(2, context),
                          color: HexColor("#707070")),
                      image: DecorationImage(
                          image: NetworkImage(widget.produit.image3),
                          fit: BoxFit.cover)),
                ),
              ),
            ),
          ),
         ]
       );
    }
  }
}
/*Fin de la fonction */