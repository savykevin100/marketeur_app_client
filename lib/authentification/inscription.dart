import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:marketeur_follow_me/composants/bouton.dart';
import 'package:marketeur_follow_me/composants/calcul.dart';
import 'package:marketeur_follow_me/modeles/hexadecimal.dart';
import 'package:marketeur_follow_me/composants/container_authentification.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:marketeur_follow_me/composants/decoration_text_field.dart';
import 'package:marketeur_follow_me/modeles/utilisateurs.dart';
import 'package:marketeur_follow_me/authentification/page_renseignement.dart';


class Inscription extends StatefulWidget {
  static String id ="inscription";
  @override
  _InscriptionState createState() => _InscriptionState();
}

class _InscriptionState extends State<Inscription> {

  final _auth = FirebaseAuth.instance;
 static String emailAdress = '';
  String motDePass = '';
  String confirmation = '';
  bool chargement = false;
  Utilisateur utilisateur;



  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return (chargement==true)?Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 100.0, vertical: 100.0),
        child: Column(
          children: <Widget>[
                Image.asset('assets/images/marketeurLogo.jpeg',
                height: 197,
                width: 278,
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
              padding: EdgeInsets.symmetric(horizontal: largeurPerCent(20, context), vertical:longueurPerCent(50, context)),
              child: Stack(
                children: <Widget>[
                  Container(
                    alignment: Alignment(0, -0.9),
                    child: Container(
                      width:largeurPerCent(300, context),
                      height:longueurPerCent(500, context),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        color: HexColor('#001C36').withOpacity(0.7),
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment(0, -0.5),
                    child: Container(
                      height:longueurPerCent(500, context),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        color: Colors.white,
                      ),
                      child: Container(
                        padding: EdgeInsets.only(top: longueurPerCent(30, context),),
                        child: Column(
                          children: <Widget>[
                            SizedBox(height: longueurPerCent(10, context),),
                            Text("S'inscrire", textAlign: TextAlign.center,
                                style: TextStyle(color:HexColor('#001C36'),
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Thin')
                            ),
                            Form(
                                key: _formKey,
                                child: Container(
                                  padding:  EdgeInsets.only(top: longueurPerCent(30, context), right: largeurPerCent(5, context), left: largeurPerCent(0, context)),
                                  child: Column(
                                    children: <Widget>[
                                      SizedBox(height: longueurPerCent(10, context),),
                                      container(email("Email", Icons.email)),
                                      container(password("Mot de passe", Icons.email)),
                                      container(confirmPassword("Confirmation mot de passe", Icons.email)),
                                      SizedBox(height: longueurPerCent(60, context),),
                                      Bouton(text: 'S\'inscrire', onPressed: () async{
                                        if(_formKey.currentState.validate()) {
                                          setState(() {
                                            chargement = true;
                                          });
                                          try {
                                            final user= await _auth.createUserWithEmailAndPassword(email: emailAdress, password: motDePass);
                                            if(user!=null ) {
                                              print("reussie");
                                             Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                               return Renseignement1(emailAdress: emailAdress, motDePass: motDePass,);
                                             }));
                                            }
                                            setState(() {
                                              chargement = false;
                                            });
                                          } catch(e){
                                            print(e);
                                          }
                                        }
                                      }
                                      ),
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

  Widget email(String data,
      IconData icon,) {
    return TextFormField(
      style: TextStyle(
          color: HexColor('#001C36'),
          fontSize: 18.0,
          fontFamily: 'Regular'),
      keyboardType: TextInputType.emailAddress,
      decoration: inputDecoration('Email', Icons.email),

      onChanged: (value){
         emailAdress = value;
      },

      validator: (String value) {
        if (EmailValidator.validate(emailAdress) == false) {
          return ("Entrer un email valide");
        }
        },
    );
  }


  Widget password(String data,
      IconData icon,) {
    return TextFormField(
      obscureText: true,
      style: TextStyle(
          color: HexColor('#001C36'),
          fontSize: 18.0,
          fontFamily: 'Regular'),
      decoration: inputDecoration('Mot de passe', Icons.lock),
      validator: (String value) {
        if (value.isEmpty) {
          return ("Entrer un mot de passe valide");
        } else if (value.length < 6) {
          return ("Le nombre de caractères doit être supérieur à 5");
        }
      },
      onChanged: (value) => motDePass = value,
    );
  }

  Widget confirmPassword(String data,
      IconData icon,) {
    return TextFormField(
        obscureText: true,
        style: TextStyle(
            color: HexColor('#001C36'),
            fontSize: 18.0,
            fontFamily: 'Regular'),
        decoration: inputDecoration(data, Icons.lock),
        validator: (String value) {
          if (value.isEmpty || motDePass != value) {
            return ("Entrer votre mot de passe");
          }
        },
        onChanged:
        (value) => confirmation = value
    );
  }


}

/**/