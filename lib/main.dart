import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elite/pages/homepage_test.dart';
import 'package:elite/pages/login_page.dart';
import 'package:elite/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseFirestore.instance.collection("mensagens").doc(
    DateTime.now().millisecondsSinceEpoch.toString()
  ).set(
    {'text' : 'oi' }
  );



  runApp(const MyApp());

//   final documents = await FirebaseFirestore.instance.collection("mensagens").get();
//
//   documents.docs.forEach((e){
//     print(e);
//   });



}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthGate(),
    );
  }
}

/// =======================================================
///  TELA QUE VERIFICA SE ESTÁ LOGADO
/// =======================================================
///
class AuthGate extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasData) {
          return const HomePage();
        }

        return const LoginPage();
      },
    );
  }
}

/// =======================================================
///  LOGIN PAGE — SUPORTA WEB E ANDROID
/// =======================================================
// class LoginPage extends StatelessWidget {
//   const LoginPage({super.key});
//
//   Future<UserCredential> signInWithGoogle() async {
//     // ===============================
//     // LOGIN PARA WEB
//     // ===============================
//     if (kIsWeb) {
//       GoogleAuthProvider googleProvider = GoogleAuthProvider();
//
//       googleProvider.setCustomParameters({
//         'prompt': 'select_account'
//       });
//
//       return await FirebaseAuth.instance.signInWithPopup(googleProvider);
//     }
//
//     // ===============================
//     // LOGIN PARA ANDROID
//     // ===============================
//     final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
//     if (googleUser == null) throw Exception("Login cancelado");
//
//     final GoogleSignInAuthentication googleAuth =
//     await googleUser.authentication;
//
//     final credential = GoogleAuthProvider.credential(
//       accessToken: googleAuth.accessToken,
//       idToken: googleAuth.idToken,
//     );
//
//     return await FirebaseAuth.instance.signInWithCredential(credential);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: ElevatedButton(
//           child: const Text("Entrar com Google"),
//           onPressed: () async {
//             try {
//               await signInWithGoogle();
//             } catch (e) {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(content: Text("Erro ao fazer login: $e")),
//               );
//             }
//           },
//         ),
//       ),
//     );
//   }
// }

/// =======================================================
///  PÁGINA APÓS LOGIN
/// =======================================================
// class HomePage extends StatelessWidget {
//   const HomePage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final user = FirebaseAuth.instance.currentUser!;
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Bem vindo, ${user.displayName}!"),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.logout),
//             onPressed: () async {
//               await FirebaseAuth.instance.signOut();
//               if (!kIsWeb) {
//                 await GoogleSignIn().signOut();
//               }
//             },
//           )
//         ],
//       ),
//       body: Center(
//         child: Text("Email: ${user.email}"),
//       ),
//     );
//   }
// }
