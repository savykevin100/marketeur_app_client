class ProduitsFavorisUser {
 String imageSelect;
 int quantite;
 String imagePrincipaleProduit;
 bool etatIconeFavoris;
ProduitsFavorisUser({this.imageSelect, this.quantite, this.imagePrincipaleProduit, this.etatIconeFavoris});

 ProduitsFavorisUser.fromMap(Map<String, dynamic> donnees, String quantite)
      : imageSelect = donnees["imageSelect"],
        quantite = donnees["quantite"],
        imagePrincipaleProduit = donnees["imagePrincipaleProduit"],
       etatIconeFavoris = donnees["etatIconeFavoris"];

  Map<String, dynamic> toMap() {
    return {
      "imageSelect": imageSelect,
      "quantite": quantite,
      "imagePrincipaleProduit":imagePrincipaleProduit,
      "etatIconeFavoris":etatIconeFavoris
    };
  }
}

/*Cette classe ProduitsFavorisUser est utilisée pour récuperer les infos spécifiques des produits pour l'utilisateur
connecté dont les favoris, la quantité du produit, l'image selectionnée et autres
 */