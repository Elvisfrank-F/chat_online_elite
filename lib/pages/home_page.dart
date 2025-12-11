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



class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final user = FirebaseAuth.instance.currentUser!;


  void _sendMessage({String? text, XFile? img}) async {

    String? imgURL;

    if(img != null){



      final storageRef = FirebaseStorage.instance.ref().child(
        DateTime.now().millisecondsSinceEpoch.toString()
      );

      await storageRef.putFile(File(img.path));

      imgURL = await storageRef.getDownloadURL();

    }

    Map<String, dynamic> data = {
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

      body: SafeArea(
        child: Center(
          child: Column(
           children: [
        
             Expanded(child: StreamBuilder<QuerySnapshot>(
        
                 stream: FirebaseFirestore.instance.collection('mensagens').orderBy('timestamp').snapshots() ,
        
                 builder: (context, snapshot){
        
                   switch(snapshot.connectionState){
                     case ConnectionState.none:
                     case ConnectionState.waiting:
                       return Center(
                         child: CircularProgressIndicator(),
                       );
        
                     default:
                       List<DocumentSnapshot> documents = snapshot.data!.docs;
        
                       return ListView.builder(
                        // reverse: true,
        
                         itemCount: documents.length,
        
        
        
                         itemBuilder: (context, index){
        
                           final Map<String, dynamic> item = documents[index].data() as Map<String, dynamic>;
        
        
                           return Align(
                               alignment: true? Alignment.centerRight:Alignment.centerLeft,
                               child: CardMessenger(isMy: true,imgURL: item['imgURL'],photoURL: item['photoURL'] , name: item['nome'], text: item['text']));
                         },
        
                       );
        
                   }
                 }
        
             )),
             TextCompose(sendMessage: _sendMessage)
           ],
          ),
        ),
      )
    );
  }
}
