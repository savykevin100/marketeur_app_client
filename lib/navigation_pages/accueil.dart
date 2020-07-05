import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:marketeur_follow_me/authentification/page_renseignement.dart';
import 'package:marketeur_follow_me/composants/calcul.dart';
import 'package:marketeur_follow_me/modeles/hexadecimal.dart';
import 'package:marketeur_follow_me/modeles/profileUtilisateur.dart';
import 'package:marketeur_follow_me/modeles/utilisateurs.dart';
import 'package:search_app_bar/filter.dart';
import 'package:search_app_bar/search_app_bar.dart';

class Accueil extends StatefulWidget {
  @override
  _AccueilState createState() => _AccueilState();
}

class _AccueilState extends State<Accueil> with SingleTickerProviderStateMixin{

/// Definition des varialbles 
  int selecte = 0;
  final _auth = FirebaseAuth.instance;
  FirebaseUser utilisateurConnecte;
  Utilisateur donneesUtilisateurConnecte;
    int currentSelecte=0;


   List<String> textes = [
    "High-Tech",
    "Electroménager",
    "Vêtements",
    "Beauté",
    "Accessoires",
    "Décoration",
    "Restauration",
    "Prestation",
    "Sante",
    "Divers",
  ];


  List<String> imageCategories = [
    "assets/images/Decoration.svg",
    "assets/images/layer1.svg",
    "assets/images/Vetements.svg",
    "assets/images/Beaute.svg",
    "assets/images/Decoration.svg",
    "assets/images/layer1.svg",
    "assets/images/Vetements.svg",
    "assets/images/Beaute.svg",
    "assets/images/Decoration.svg",
    "assets/images/layer1.svg",
  ];


/* Définition de l'animation controller pour l'animation des images */

  AnimationController animationController;
  Animation carouselAnimation;


/* Liste de photos qui contient les images à defiler dans le carousel */
  int photoIndex = 0;
  List<String> photos = [
    'assets/images/gadgets-336635_1920.jpg',
    'assets/images/make-up-1209798_1920.jpg',
    'assets/images/sketchbook-156775_1280.png',
    'assets/images/vacuum-cleaner-657719_1920.jpg',
  ];


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



  /*Initialisation de la page*/
    @override
  void initState() {
    super.initState();
    getCurrentUser();

    animationController =
        AnimationController(duration: Duration(seconds: 18), vsync: this);

    carouselAnimation =
        IntTween(begin: 0, end: photos.length - 1).animate(animationController)
          ..addListener(() {
            setState(() {
              photoIndex = carouselAnimation.value;
            });
          });

    animationController.repeat();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }
  /*Fin de l'initialisation de la page*/


///***********************************************************************************************************/
/* Début du code l'interface */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: SearchAppBar<String>(
        backgroundColor: HexColor("#001c36"),
        title: Text("Accueil", style: TextStyle(color: Colors.white, fontFamily: "MonseraBold"),),
        searcher: null,
        filter: Filters.startsWith,
        iconTheme: IconThemeData(color: Colors.white),

        actions: <Widget>[
          IconButton(icon: Icon(Icons.shopping_basket, color: Colors.white,), onPressed: null)
         ],

        ),
      drawer: ProfileSettings(),
      body: ListView(
        children:<Widget>[
          carousel(),
          Stack(
            children: <Widget>[
              Container(
                height: longueurPerCent(120, context),
                decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      new BoxShadow(
                          color: Colors.white,
                          offset: new Offset(0.0, -10.0),
                          blurRadius: 10
                      ),
                    ]),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: <Widget>[
                    SizedBox(width: largeurPerCent(10, context),),
                    categories(0),
                    SizedBox(width: largeurPerCent(20, context),),
                    categories(1),
                    SizedBox(width: largeurPerCent(20, context),),
                    categories(2),
                    SizedBox(width: largeurPerCent(20, context),),
                    categories(3),
                    SizedBox(width: largeurPerCent(20, context),),
                    categories(4),
                    SizedBox(width: largeurPerCent(20, context),),
                    categories(5),
                    SizedBox(width: largeurPerCent(20, context),),
                    categories(6),
                    SizedBox(width: largeurPerCent(20, context),),
                    categories(7),
                    SizedBox(width: largeurPerCent(20, context),),
                    categories(8),
                    SizedBox(width: largeurPerCent(20, context),),
                    categories(9),
                    SizedBox(width: largeurPerCent(20, context),),
                  ],
                ),
              ),
            ],
          ),
        ]
      )
    );
  }
  /* Fin du code l'interface */

///**************************************************************************************************************** */





/*Fonction qui permet d'obtenir l'image arrondie et le texte en bas de l'image. On passe l'index et il 
affiche le texte et l'image qui est à la position index au niveau du scrollabe en bas du carousel
*/
 Widget categories(int index){
    return  Container(
      child: GestureDetector(
        onTap: (){
          setState(() {
            selecte =index;
            currentSelecte = index;
          });
        },
        child: Padding(
          padding: EdgeInsets.only(top: 0),
          child:Container(
             child:new Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Container(
                    width: largeurPerCent(60.0, context),
                    height:longueurPerCent(50.0, context),
                    decoration: new BoxDecoration(
                        shape: BoxShape.circle,
                        image: new DecorationImage(
                            fit: BoxFit.fill,
                            image:AssetImage("assets/images/vacuum-cleaner-657719_1920.jpg")
                        )
                    )),
                new Text(textes[index],style: TextStyle(color:HexColor("#001C36"), fontFamily:"MonseraBold"),
                  ),
                SizedBox(height:longueurPerCent(20, context)),
               (selecte ==index)?Container(
                  width:largeurPerCent(80, context),
                  height:longueurPerCent(3, context),
                 color: HexColor("#001C36"),
                ):Container(
                  width:largeurPerCent(80, context),
                  height:longueurPerCent(3, context),
                 color: Colors.white,
                )
              ],
            )
           )
          ),
        ),
    );
  }
  /* Fin de la fonction*/



/* Fonction permettant d'afficher l'image et le défilant pour defiler les images du carousel **/
  Widget carousel(){
    return  Stack(
      children: <Widget>[
        Container(
          height: longueurPerCent(150.0, context),
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(photos[photoIndex]),
                  fit: BoxFit.cover)),
        ),
        Positioned(
          top: longueurPerCent(120, context),
          left: largeurPerCent(120, context),
          child: SelectedPhoto(
              photoIndex: photoIndex, numberOfDots: photos.length),
        ),
      ],
    );
 }
}


 //Classe décrivant la selection des images du carousel avec la prise quand l'image est active ou non 


class SelectedPhoto extends StatelessWidget {
  final int numberOfDots;
  final int photoIndex;

  SelectedPhoto({this.numberOfDots, this.photoIndex});

  Widget _inactivePhoto() {
    return Center(
      child: new Container(
          child: new Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15.0),
           child: Container(
          height: 20.0,
          width: 20.0,
          decoration: BoxDecoration(
              color:  HexColor('#001C36'), borderRadius: BorderRadius.circular(10.0)),
        ),
      )),
    );
  }

  Widget _activePhoto() {
    return Container(
      child: Padding(
        padding: EdgeInsets.only(left: 15.0, right: 15.0),
        child: Container(
          height: 20.0,
          width: 20.0,
          decoration: BoxDecoration(
              color:  Colors.yellow,
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: [
                BoxShadow(
                    color: Colors.white, spreadRadius: 0.0, blurRadius: 10.0)
              ]),
        ),
      ),
    );
  }

  List<Widget> _buildDots() {
    List<Widget> dots = [];

    for (int i = 0; i < numberOfDots; ++i) {
      dots.add(i == photoIndex ? _activePhoto() : _inactivePhoto());
    }

    return dots;
  }

  @override
  Widget build(BuildContext context) {
    return new Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: _buildDots(),
      ),
    );
  }
}


