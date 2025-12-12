import 'package:elite/pages/frescar_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart' show kIsWeb;



class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  Future<UserCredential> signInWithGoogle() async {


    //======================WEB================


    if(kIsWeb){

      GoogleAuthProvider googleProvider = GoogleAuthProvider();

      googleProvider.setCustomParameters({
        'prompt': 'select_account'
      }
      );

      return await FirebaseAuth.instance.signInWithPopup(googleProvider);



    }





    // ========android===========
    //inicia o login no google
    final googleUser = await GoogleSignIn(
      scopes: [
        'email',
        'https://www.googleapis.com/auth/userinfo.profile'
      ]
    ).signIn();

    //se o usuario fechou retorna null

    if (googleUser == null) {
      throw Exception("Login Cancelado");
    }

    //pegar a autenticação

    final googleAuth = await googleUser.authentication;

    //Criar credenciais do firebase

    final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken
    );

    //fazer login no firebase auth

    return FirebaseAuth.instance.signInWithCredential(credential);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Card(
              child: Container(
                
                padding: EdgeInsets.all(10),

                width: MediaQuery.of(context).size.width>400? 400: MediaQuery.of(context).size.width*0.75,



              child : Column(

                mainAxisSize: MainAxisSize.min,
                children: [

                  Text("ELITE", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 30),),

                  SizedBox(height: 10,),

                  Text("Faça login para prosseguir"),

                  SizedBox(height: 40,),

                  ElevatedButton(onPressed: () async {
                    try {
                      await signInWithGoogle();
                    }
                    catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Erro ao fazer login $e"))
                      );
                    }
                  }, child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [

                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage("assets/google.png")
                          )
                        ),
                      ),

                      SizedBox(width: 10,),

                      const Text("Entrar no google"),

                    ],
                  ),),

                  SizedBox(height: 30,),

                  Text.rich(
                    TextSpan(
                      text: "Ao logar você concorda com os nossos ",
                      children: [
                        WidgetSpan(
                          child: GestureDetector(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => FrescarPage()));
                            },
                            child: Text("termos", style: TextStyle(color: Colors.blue,
                            decoration: TextDecoration.underline
                            )),
                          )
                        )
                      ],
                    ),
                    textAlign: TextAlign.center,
                  )







                ],
              ),

              )
            )


            )
    );
  }
}
