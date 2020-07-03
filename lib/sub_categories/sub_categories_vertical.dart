import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:marketeur_follow_me/composants/calcul.dart';
import 'package:marketeur_follow_me/modeles/categories.dart';
import 'package:marketeur_follow_me/modeles/firestore_service.dart';
import 'package:marketeur_follow_me/modeles/hexadecimal.dart';
import 'package:marketeur_follow_me/produits_pages/produits_sub_categories_vertical.dart';
import 'package:search_app_bar/filter.dart';
import 'package:search_app_bar/search_app_bar.dart';

class Sub_categories_vertical extends StatefulWidget {
  String titreCategorie;
  Sub_categories_vertical({this.titreCategorie});
  @override
  _Sub_categories_verticalState createState() => _Sub_categories_verticalState();
}

class _Sub_categories_verticalState extends State<Sub_categories_vertical> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: SearchAppBar<String>(
        backgroundColor: HexColor("#001c36"),
        title: Text(widget.titreCategorie, style: TextStyle(color: Colors.white, fontFamily: "MonseraBold"),),
        searcher: null,
        filter: Filters.startsWith,
        iconTheme: IconThemeData(color: Colors.white),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.shopping_basket, color: Colors.white,), onPressed: null)
         ],
        ),
        body:
         StreamBuilder(
          stream: FirestoreService().getSousCategories(),
          builder: (BuildContext context, AsyncSnapshot<List<InfoCategories>> snapshot){
            if(snapshot.hasError || !snapshot.hasData){
              return Center(child: CircularProgressIndicator());
            }
            else {
                return StaggeredGridView.countBuilder(
                reverse: false,
                crossAxisCount: 4,
                itemCount: snapshot.data.length, 
                itemBuilder: (BuildContext context, index) {                                                                                                                                                                             
                InfoCategories categorie = snapshot.data[index];
                  return Container(
                padding: EdgeInsets.only(top:30, right: 10, left: 10),
                child: InkWell(
               onTap: (){
                  Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Produits_sous_categories_vertical(
                            )));

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
                        height:longueurPerCent(160, context),
                        width: largeurPerCent(200, context),
                           decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(5), topRight:Radius.circular(5)),
                          image: DecorationImage(image: NetworkImage(categorie.imagePath), fit: BoxFit.cover)
                    ),              
                      ),
                       Container(
                        height:longueurPerCent(40, context),
                        width: largeurPerCent(200, context),
                           child: Center(child:Text(categorie.nomCategorie,style: TextStyle(color:HexColor("#001C36"), fontFamily:"MonseraBold"),),                  
                      )
                    ),
                  ],
                ),
            ),
          )),
              );
             },
             staggeredTileBuilder: (_) =>StaggeredTile.fit(2),
             mainAxisSpacing: 20.0,
             crossAxisSpacing: 20.0,
             );
            }
          })
    );
  }
}