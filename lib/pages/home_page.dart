import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elite/main.dart';
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

  bool isDark = false;

  bool _isLoading = false;

  final ScrollController _scrollController = new ScrollController();

  void _scrollToBottom(){

    Future.delayed(Duration(milliseconds: 100), (){

      if(_scrollController.hasClients){
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }

    });
  }


  void _sendMessage({String? text, XFile? img}) async {

    String? imgURL;

    if(img != null){



      final storageRef = FirebaseStorage.instance.ref().child(user.uid).child(
        DateTime.now().millisecondsSinceEpoch.toString()
      );

      setState(() {
        _isLoading = true;
      });

      //se for mobile

      if(!kIsWeb){
        await storageRef.putFile(File(img.path));
      }
      //se for web
      else {
        await storageRef.putData(await img.readAsBytes());
      }







      imgURL = await storageRef.getDownloadURL();

      setState(() {
        _isLoading = false;
      });

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

    setState(() {
      if(themeNotifier.value == ThemeMode.dark){
        isDark = true;
      }
      else {
        isDark = false;
      }

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
                  CachedNetworkImageProvider(user.photoURL!,
                ) : const AssetImage("assets/person.jpeg")
              )
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("MODO DARK"),
                  Switch(value: isDark, onChanged:(valor){

                    isDark = valor;


                    setState(() {
                      if(isDark) {
                        themeNotifier.value = ThemeMode.dark;
                      }
                      else {
                        themeNotifier.value = ThemeMode.light;
                      }
                    });

                  } ),
                ],
              ),
            ),
            SizedBox(height: 20,),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                children: [

                  Text("LOGOUT"),

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

                       WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
        
                       return ListView.builder(
                        // reverse: true,

                         controller: _scrollController,
        
                         itemCount: documents.length,
        
        
        
                         itemBuilder: (context, index){
        
                           final Map<String, dynamic> item = documents[index].data() as Map<String, dynamic>;

                           bool cond = false;

                           if(user.uid == item['uid']){
                             cond = true;
                           }
        
        
                           return Container(
                              // width: MediaQuery.of(context).size.width>200? MediaQuery.of(context).size.width * 0.5 : 200,
                               alignment: cond? Alignment.centerRight:Alignment.centerLeft,
                               child: ConstrainedBox(
                                   constraints: BoxConstraints(
                                     maxWidth: MediaQuery.of(context).size.width>500? MediaQuery.of(context).size.width * 0.5 : 500,
                                     minWidth: 60
                                   ),
                                   child: CardMessenger(data: (item['timestamp'] as Timestamp).toDate()  ,isMy: cond,imgURL: item['imgURL'],photoURL: item['photoURL'] , name: item['nome'], text: item['text'])));
                         },
        
                       );
        
                   }
                 }
        
             )),
             _isLoading? LinearProgressIndicator(): Container(),
             TextCompose(sendMessage: _sendMessage)
           ],
          ),
        ),
      )
    );
  }
}
