import 'package:marketeur_follow_me/panier.dart';

class PanierClasse {
  String nomDuProduit;
  String prix;
  String description;
  String image1;
  int quantiteCommander;
  String id;
  int nombreAjout;

  PanierClasse(
      {this.nomDuProduit,
        this.prix,
        this.description,
        this.image1,
        this.quantiteCommander,
        this.id,
        this.nombreAjout
    });

  PanierClasse.fromMap(Map<String, dynamic> donnees, String id)
      : nomDuProduit = donnees["nomDuProduit"],
        prix = donnees["prix"],
        description = donnees["description"],
        image1 = donnees["image1"],
         quantiteCommander = donnees["quantiteCommander"],
        nombreAjout= donnees["nombreAjout"],
        id= donnees["id"];

  Map<String, dynamic> toMap() {
    return {
      "nomDuProduit": nomDuProduit,
      "prix": prix,
      "description": description,
      "image1": image1,
      "quantiteCommander":quantiteCommander,
      "nombreAjout":nombreAjout,
      "id":id
    };
 }
}