import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elite/wids/card_messenger.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:elite/wids/text_compose.dart';
import 'package:image_picker/image_picker.dart';



class HomeTestPage extends StatefulWidget {
  const HomeTestPage({super.key});

  @override
  State<HomeTestPage> createState() => _HomeTestPageState();
}

class _HomeTestPageState extends State<HomeTestPage> {

  final user = FirebaseAuth.instance.currentUser!;
  Map<String, dynamic> data = {};



  void _sendMessage({String? text, XFile? img}) async {

    String? imgURL;

    if(img != null){



      final storageRef = FirebaseStorage.instance.ref().child(
          DateTime.now().millisecondsSinceEpoch.toString()
      );

      await storageRef.putFile(File(img.path));

      imgURL = await storageRef.getDownloadURL();

    }

    data = {
      'text' : text ?? null,
      'nome' : user.displayName ?? "",
      'photoURL' : user.photoURL ?? "",
      'imgURL' : imgURL,
      'uid' : user.uid,
      'timestamp' : FieldValue.serverTimestamp()
    };

    FirebaseFirestore.instance.collection('mensagens').add(
        data
    );

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseFirestore.instance.collection("mensagens").snapshots().listen((dado){

      dado.docs.forEach((d){
        print(d.data());
      });

    });

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: Drawer (

            child: ListView(
              padding: EdgeInsets.zero,

              children: [
                UserAccountsDrawerHeader(
                    accountName: Text(user.displayName ?? ""),
                    accountEmail: Text(user.email ?? ""),
                    currentAccountPicture: CircleAvatar(
                        backgroundImage:
                        user.photoURL != null ?
                        NetworkImage(
                            user.photoURL!
                        ) as ImageProvider : const AssetImage("assets/person.jpeg")
                    )
                )
              ],
            )


        ),
        appBar: AppBar(
          title: Text("Elite"),
          centerTitle: true,
          backgroundColor: Colors.amber,

          actions: [
            IconButton(
              icon: Icon(Icons.logout),

              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                if(!kIsWeb){
                  await GoogleSignIn().signOut();
                }
              },
            )
          ],
        ),

        body: Column(
          children: [
            CardMessenger(photoURL: user.photoURL, name: user.displayName, text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum." ),
          ],
        )

    );

  }
}
