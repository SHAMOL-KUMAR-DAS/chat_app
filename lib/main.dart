 import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:impel/pages/all_users.dart';
import 'package:impel/pages/sign_in_up.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:impel/services/app_colors.dart';
import 'package:impel/services/auth.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      debugShowCheckedModeBanner: false,
      home: Splash_Screen()
    );
  }
}

 class Splash_Screen extends StatefulWidget {
   @override
   _Splash_ScreenState createState() => _Splash_ScreenState();
 }

 class _Splash_ScreenState extends State<Splash_Screen>
     with SingleTickerProviderStateMixin{
   late AnimationController animationController;
   late Animation<double> animation;


   startTime() async {
     var _duration = Duration(milliseconds: 3000);
     return Timer(_duration, _loadUserInfo);
   }

   _loadUserInfo() async {
     AuthMethods().getCurrentUser() != null ?
     Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => All_Users()), (route) => false)
         :
     Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => SignInUp()), (route) => false);
   }

   @override
   void initState() {
     super.initState();
     animationController = AnimationController(
         vsync: this, duration: Duration(seconds: 1));
     animation = CurvedAnimation(parent: animationController, curve: Curves.easeOut);
     animation.addListener(() => this.setState(() {}));
     animationController.forward();
     startTime();
   }



   @override
   Widget build(BuildContext context) {
     return Scaffold(
       backgroundColor: Colors.white,
       body: Container(
         height: MediaQuery.of(context).size.height,
         width: MediaQuery.of(context).size.width,
         child: Stack(
           fit: StackFit.expand,
           children: <Widget>[
             Column(
               mainAxisAlignment: MainAxisAlignment.end,
               mainAxisSize: MainAxisSize.min,
               children: const [
                 Padding(padding: EdgeInsets.only(bottom: 30.0),child:Text("Welcome To Chatty",style: TextStyle(color: AppColors.primaryColor,fontSize: 18,fontWeight: FontWeight.w800))),

               ],),
             Column(
               mainAxisAlignment: MainAxisAlignment.center,
               children: <Widget>[
                 Image(image: AssetImage('assets/images/logo.png'),
                   width: animation.value * 250,
                   height: animation.value * 250,
                 ),

               ],
             ),
           ],
         ),
       ),
     );
   }
 }