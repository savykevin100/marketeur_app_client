import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:marketeur_follow_me/authentification/page_renseignement.dart';
import 'package:marketeur_follow_me/composants/bouton.dart';
import 'package:marketeur_follow_me/composants/calcul.dart';
import 'package:marketeur_follow_me/modeles/hexadecimal.dart';
import 'package:marketeur_follow_me/composants/container_authentification.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:marketeur_follow_me/composants/decoration_text_field.dart';
import 'package:marketeur_follow_me/navigation_pages/premiere_page.dart';


class Connexion extends StatefulWidget {
  static String id='connexion';


  @override
  _ConnexionState createState() => _ConnexionState();
}

class _ConnexionState extends State<Connexion> {

  final _auth= FirebaseAuth.instance;
  String emailAdresse='';
  String motDePasse='';
  bool chargement = false;

  
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {

    return (chargement==true)?Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 100.0, vertical: 100.0),
        child: Column(
          children: <Widget>[
            Flexible(
              child: Image.asset('assets/images/marketeur.png',
                height: 197,
                width: 278,
              ),
            ),
            SizedBox(height: 50.0,),
            SpinKitThreeBounce(
              color:HexColor('#001C36'),
              size: 60,
            )
          ],
        ),
      ),
    ) :Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(
                  'assets/images/inscription.jpg',
                ),
                fit: BoxFit.cover),
          ),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: largeurPerCent(20, context), vertical:longueurPerCent(40, context)),
            child: Stack(
              children: <Widget>[
                Container(
                  alignment: Alignment(0, -0.9),
                  child: Container(
                    width:largeurPerCent(300, context),
                    height:longueurPerCent(100, context),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: HexColor('#001C36').withOpacity(0.7),
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment(0, -0.5),
                  child: Container(
                    width:largeurPerCent(500, context),
                    height:longueurPerCent(450, context),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: Colors.white,
                    ),
                    child: Container(
                      padding: EdgeInsets.only(top: 30,),
                      child: Column(
                        children: <Widget>[
                          SizedBox(height: longueurPerCent(10, context),),
                          Text("Se connecter", textAlign: TextAlign.center,
                              style: TextStyle(color:HexColor('#001C36'),
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Thin')
                          ),
                          Form(
                              key: _formKey,
                              child: Container(
                                padding:  EdgeInsets.only(top: longueurPerCent(30, context), right: largeurPerCent(5, context), left: largeurPerCent(5, context)),
                                child: Column(
                                  children: <Widget>[
                                    SizedBox(height: longueurPerCent(10, context),),
                                    container(email("Email", Icons.email)),
                                    container(password("Mot de passe", Icons.lock)),
                                    SizedBox(height: longueurPerCent(60, context),),
                                    Bouton(text: 'Se connecter', onPressed: () async{
                                      if(_formKey.currentState.validate()){
                                        setState(() {
                                          chargement = true;
                                        });
                                        try{
                                          final user = await _auth.signInWithEmailAndPassword(email: emailAdresse , password: motDePasse);
                                          if(user!=null) {
                                            Navigator.pushNamed(context,Allnavigation_pages.id);
                                            setState(() {
                                              Renseignement1.infos_utilisateur_connnecte=emailAdresse;
                                            });
                                          }
                                          setState(() {
                                            chargement = false;
                                          });
                                        } catch (e) {
                                          print(e);
                                        }
                                      }
                                    }
                                    ),
                                    SizedBox(
                                      height: longueurPerCent(20, context),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text("Mot de passe oublié?", style: TextStyle(color: Colors.blue),),
                                      ],
                                    )
                                  ],
                                ),
                              )
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      )
    );
  }


  Widget email(
    String data,
    IconData icon,
  ) {
    return TextFormField(
      style: TextStyle(
          color: HexColor('#001C36'),
          fontSize: 18.0,
          fontFamily: 'Regular'),
      keyboardType: TextInputType.emailAddress,
        decoration: inputDecoration("Email", Icons.email),
      validator: (String value) {
        if (EmailValidator.validate(emailAdresse) == false ) {
          return ("Entrer un email valide");
        }
      },
      onChanged: (value) => emailAdresse = value,
    );
  }

  Widget password(
    String data,
    IconData icon,
  ) {
    return TextFormField(
      style: TextStyle(
          color: HexColor('#001C36'),
          fontSize: 18.0,
          fontFamily: 'Regular'),
      minLines: 1,
      obscureText: true,
      decoration: inputDecoration("Mot de passe", Icons.lock),
      validator: (String value) {
        if(value.isEmpty) {
          return ("Entrer un mot de passe valide");
        } else if (value.length<6) {
          return ("Le nombre de caractères doit être supérieur à 5");
        }
      },
      onChanged: (value) => motDePasse = value,
    );
  }

}

