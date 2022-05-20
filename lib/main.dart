 import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:impel/pages/sign_in_up.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:impel/test.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  _loadUserInfo() async {
    AuthMethods().getCurrentUser() != null ?
    Testing()
        :
    SignInUp();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      debugShowCheckedModeBanner: false,
      home: _loadUserInfo()
    );
  }
}

 class AuthMethods{
   final FirebaseAuth auth = FirebaseAuth.instance;
   getCurrentUser(){
     return auth.currentUser != null ? auth.currentUser : null;
   }
 }