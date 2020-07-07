import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:marketeur_follow_me/modeles/firestore_service.dart';
import 'package:marketeur_follow_me/composants/calcul.dart';
import 'package:marketeur_follow_me/modeles/hexadecimal.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:marketeur_follow_me/modeles/panier_classe.dart';
import 'package:marketeur_follow_me/modeles/produits_favoris_user.dart';
import 'package:marketeur_follow_me/modeles/utilisateurs.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:marketeur_follow_me/navigation_pages/premiere_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Renseignement1 extends StatefulWidget {
  static final String id = "Renseignement";
  static String infos_utilisateur_connnecte ;

  


  final String emailAdress, motDePass;
  Renseignement1({this.emailAdress, this.motDePass});

  @override
  _Renseignement1State createState() => _Renseignement1State();
}

class _Renseignement1State extends State<Renseignement1> {
  String image;
  String nomComplet;
  String numeroPayement;
  String sexe = '';
  String age;
  int i = 0;
  final _formKey = GlobalKey<FormState>();
  Utilisateur utilisateur;
  bool chargement = false;
  FirebaseMessaging _messaging = FirebaseMessaging();
  Firestore _db = Firestore.instance;
  String key = "infos_utilisateur_connecte";
  /* Cette variable contiendra les informations de l'utilisateur connecte(nomComplet, numeroPayement...) 
  qui sera permanent dans l'application du à l'utilisation de shared_preferences*/

  @override
  void initState() {
    super.initState();
    sexe = '';
    obtenir();
    ajouter(widget.emailAdress);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: (chargement == true)
          ? Scaffold(
              body: Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: 100.0, vertical: 100.0),
                child: Column(
                  children: <Widget>[
                    Image.asset(
                      'assets/images/marketeurLogo.jpeg',
                      height: 197,
                      width: 278,
                    ),
                    SizedBox(
                      height: 50.0,
                    ),
                    SpinKitThreeBounce(
                      color: HexColor('#001C36'),
                      size: 60,
                    )
                  ],
                ),
              ),
            )
          : SingleChildScrollView(
              child: Center(
                child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: largeurPerCent(20, context),
                      vertical: longueurPerCent(90, context)),
                  child: Stack(
                    children: <Widget>[
                      Card(
                        elevation: 5.0,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: largeurPerCent(20, context),
                              vertical: longueurPerCent(0, context)),
                          alignment: Alignment(0, -0.5),
                          child: Container(
                            width: longueurPerCent(500, context),
                            height: longueurPerCent(550, context),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                              color: Colors.white,
                            ),
                            child: SingleChildScrollView(
                              child: Container(
                                padding: EdgeInsets.only(
                                  top: longueurPerCent(30, context),
                                ),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: <Widget>[
                                    SizedBox(
                                      height: longueurPerCent(10, context),
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Padding(
                                            padding: EdgeInsets.only(
                                                left:
                                                    largeurPerCent(5, context)),
                                            child: Text(
                                              "Paramétres",
                                              style: TextStyle(
                                                  color: HexColor('#001C36'),
                                                  fontFamily: 'Bold',
                                                  fontSize: 25.0),
                                            )),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left:
                                                  largeurPerCent(130, context)),
                                          child: Icon(
                                            Icons.settings,
                                            color: HexColor('#001C36'),
                                            size: 30.0,
                                          ),
                                        )
                                      ],
                                    ),
                                    Form(
                                        key: _formKey,
                                        child: Column(
                                          children: <Widget>[
                                            SizedBox(
                                              height:
                                                  longueurPerCent(20, context),
                                            ),
                                            nomm('Nom complet'),
                                            SizedBox(
                                              height:
                                                  longueurPerCent(10, context),
                                            ),
                                            Container(
                                              padding: EdgeInsets.only(left: 0),
                                              color: Colors.white,
                                              child: DropDownFormField(
                                                errorText: 'Choisissez un sexe',
                                                titleText:
                                                    'Selectionnez votre genre',
                                                hintText: 'Sexe',
                                                value: sexe,
                                                dataSource: [
                                                  {
                                                    "display": "Masculin",
                                                    "value": "Masculin",
                                                  },
                                                  {
                                                    "display": "Féminin",
                                                    "value": "Féminin",
                                                  },
                                                ],
                                                onChanged: (value) {
                                                  setState(() {
                                                    sexe = value;
                                                    
                                                  });
                                                },
                                                validator: (value) {
                                                  if (value == null) {
                                                    return ("Veuil  lez selectionner un sexe");
                                                  }
                                                  return null;
                                                },
                                                textField: 'display',
                                                valueField: 'value',
                                              ),
                                            ),
                                            SizedBox(
                                              height:
                                                  longueurPerCent(10, context),
                                            ),
                                            fage("Âge"),
                                            SizedBox(
                                              height:
                                                  longueurPerCent(10, context),
                                            ),
                                            fnumeroPayement(
                                                'Numéro de payement'),
                                            SizedBox(
                                              height:
                                                  longueurPerCent(40, context),
                                            ),
                                            FlatButton(
                                              onPressed: () async {
                                                if (_formKey.currentState
                                                    .validate()) {
                                                  setState(() {
                                                    chargement = true;
                                                  });
                                                  try {
                                                    await FirestoreService()
                                                        .addUtilisateur(
                                                            Utilisateur(
                                                              nomComplet:
                                                                  nomComplet,
                                                              sexe: sexe,
                                                              age: age,
                                                              numeroDePayement:
                                                                  numeroPayement,
                                                              email: widget
                                                                  .emailAdress,
                                                              motDePasse: widget
                                                                  .motDePass,
                                                              id: widget
                                                                  .emailAdress,
                                                            ),
                                                            widget.emailAdress);

                                                    await FirestoreService()
                                                        .addProduitFavorisUser(
                                                            ProduitsFavorisUser(
                                                              etatIconeFavoris: false
                                                            ),
                                                            widget.emailAdress);
                                                    await FirestoreService().addPanier(PanierClasse(
                                                      nombreAjout: 0,
                                                      description: "AjoutPanierBadge"
                                                    ), widget.emailAdress, "AjoutPanierBadge");
                                                    print(Renseignement1.infos_utilisateur_connnecte);
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                Allnavigation_pages()));
                                                    setState(() {
                                                      chargement = true;
                                                    });
                                                  } catch (e) {
                                                    print(e);
                                                  }
                                                }
                                              },
                                              child: Container(
                                                padding: EdgeInsets.only(
                                                    top: longueurPerCent(
                                                        12, context)),
                                                width: largeurPerCent(
                                                    278, context),
                                                height: longueurPerCent(
                                                    59, context),
                                                decoration: BoxDecoration(
                                                  color: Colors.yellow,
                                                ),
                                                child: Container(
                                                    width: largeurPerCent(
                                                        140, context),
                                                    height: longueurPerCent(
                                                        29, context),
                                                    child: Text(
                                                      "Enregistrer",
                                                      textAlign:
                                                          TextAlign.center,
                                                      maxLines: 1,
                                                      style: TextStyle(
                                                          color: HexColor(
                                                              '#001C36'),
                                                          fontSize: 25,
                                                          fontFamily: 'Bold'),
                                                    )),
                                              ),
                                            ),
                                            SizedBox(
                                              height:
                                                  longueurPerCent(50, context),
                                            ),
                                          ],
                                        ))
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget nomm(String data) {
    return TextFormField(
      style: TextStyle(
          color: HexColor('#001C36'), fontSize: 20.0, fontFamily: 'Regular'),
      decoration: InputDecoration(
          contentPadding: EdgeInsets.only(top: 20, bottom: 2, left: 5),
          labelText: data,
          hintText: "Nom et prénoms",
          hintStyle: TextStyle(
              color: Colors.grey.withOpacity(0.4),
              fontSize: 20.0,
              fontFamily: 'Regular'),
          labelStyle: TextStyle(
              color: HexColor('#001C36'),
              fontSize: 18.0,
              fontFamily: 'Regular')),
      validator: (String value) {
        if (value.isEmpty) {
          return ("Entrer un email valide");
        }
      },
      onChanged: (value){
      nomComplet = value;
     
      }
    ); 
  }

  Widget fnumeroPayement(
    String data,
  ) {
    return TextFormField(
      style: TextStyle(
          color: HexColor('#001C36'), fontSize: 20.0, fontFamily: 'Regular'),
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.only(top: 20, bottom: 2, left: 5),
        labelText: 'Numéro de payement',
        labelStyle: TextStyle(
            color: HexColor('#001C36'), fontSize: 18.0, fontFamily: 'Regular'),
        hintText: "Numero mobile money",
        hintStyle: TextStyle(
            color: Colors.grey.withOpacity(0.4),
            fontSize: 20.0,
            fontFamily: 'Regular'),
      ),
      validator: (String value) {
        if (value.isEmpty) {
          return ("Entrer votre numéro de payement ");
        }
      },
     
       onChanged: (value){
       numeroPayement = value;
  
      }
    );
  }

  Widget fage(
    String data,
  ) {
    return TextFormField(
      style: TextStyle(
          color: HexColor('#001C36'), fontSize: 20.0, fontFamily: 'Regular'),
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.only(top: 20, bottom: 2, left: 5),
        hintText: "Ex: 18",
        hintStyle: TextStyle(
            color: Colors.grey.withOpacity(0.4),
            fontSize: 20.0,
            fontFamily: 'Regular'),
        labelText: data,
        labelStyle: TextStyle(
            color: HexColor('#001C36'), fontSize: 18.0, fontFamily: 'Regular'),
      ),
      validator: (value) {
        if (value.isEmpty) {
          return ("Entrer votre âge");
        }
      },
    
     onChanged: (value){
     age = value;
  
      }
      
    );
  }

/*Cette fonction permet d'obtenir les valeurs à conserver dans le shared_preferences */
  void obtenir() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String liste = await sharedPreferences.getString(key);
    if (liste != null) {
      setState(() {
        Renseignement1.infos_utilisateur_connnecte = liste;
      });
    }
  }
  /* Fin de la fonction */

  /** Cette fonction permet d'ajouter les informations*/

  void ajouter(String str) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Renseignement1.infos_utilisateur_connnecte=str;
    await sharedPreferences.setString(key,  Renseignement1.infos_utilisateur_connnecte);
    obtenir();
  }
}
