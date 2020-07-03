import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:marketeur_follow_me/authentification/inscription.dart';
import 'package:marketeur_follow_me/authentification/page_renseignement.dart';
import 'package:marketeur_follow_me/composants/calcul.dart';
import 'package:marketeur_follow_me/modeles/firestore_service.dart';
import 'package:marketeur_follow_me/modeles/hexadecimal.dart';
import 'package:marketeur_follow_me/sub_categories/sub_categories_vertical.dart';
import 'package:search_app_bar/filter.dart';
import 'package:search_app_bar/search_app_bar.dart';
import 'package:marketeur_follow_me/modeles/categories.dart';

class Categories extends StatefulWidget {
  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SearchAppBar<String>(
        backgroundColor: HexColor("#001c36"),
        title: Text(
          "Catégories",
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
      body: StreamBuilder(
          stream: FirestoreService().getCategories(),
          builder: (BuildContext context,
              AsyncSnapshot<List<InfoCategories>> snapshot) {
            if (snapshot.hasError || !snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return StaggeredGridView.countBuilder(
                reverse: true,
                crossAxisCount: 4,
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, index) {
                  InfoCategories categorie = snapshot.data[index];
                  return Container(
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Sub_categories_vertical(
                                        titreCategorie: categorie.nomCategorie,
                                      )));
                        });
                      },
                      child: Padding(
                          padding: EdgeInsets.only(
                              top: longueurPerCent(20.0, context)),
                          child: Container(
                              child: new Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              new Container(
                                width: largeurPerCent(100.0, context),
                                height: longueurPerCent(90.0, context),
                                decoration: new BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                        fit: BoxFit.fill,
                                        image:
                                            NetworkImage(categorie.imagePath))),
                              ),
                              SizedBox(height: longueurPerCent(10, context)),
                              new Text(
                                categorie.nomCategorie,
                                style: TextStyle(
                                    color: HexColor("#001C36"),
                                    fontFamily: "MonseraBold"),
                              ),
                            ],
                          ))),
                    ),
                  );
                },
                staggeredTileBuilder: (_) => StaggeredTile.fit(2),
                mainAxisSpacing: 10.0,
                crossAxisSpacing: 10.0,
              );
            }
          }),
    );
  }
}

/* body:  , */
