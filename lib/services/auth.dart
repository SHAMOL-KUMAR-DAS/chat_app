//For Google Signing In

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:impel/model/database.dart';
import 'package:impel/model/sharedpref_helper.dart';
import 'package:impel/pages/all_users.dart';
import 'package:random_string/random_string.dart';

class AuthMethods{
  final FirebaseAuth auth = FirebaseAuth.instance;

  getCurrentUser(){
    return auth.currentUser != null ? auth.currentUser : null;
  }

  signInWithGoogle(BuildContext context) async{
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    final GoogleSignIn _googleSignIn = GoogleSignIn();

    final GoogleSignInAccount? _googleSignInAccount = await _googleSignIn.signIn();

    final GoogleSignInAuthentication _googleSignInAuthentication = await _googleSignInAccount!.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: _googleSignInAuthentication.idToken,
        accessToken: _googleSignInAuthentication.accessToken);

    final result  = await _firebaseAuth.signInWithCredential(
        credential);
    final userDetails = result.user;

    if(result != null){
      SharedPreferenceHelper().saveUserEmail(userDetails!.email.toString());
      SharedPreferenceHelper().saveUserID(userDetails.uid);
      SharedPreferenceHelper().saveUserName(userDetails.displayName.toString());
      SharedPreferenceHelper().saveUserProfilePic(userDetails.photoURL.toString());
      SharedPreferenceHelper().saveUserMobile(userDetails.phoneNumber.toString());

      Map<String, dynamic> userInfoMap = {
        "First_Name": userDetails.displayName,
        "Mobile": userDetails.phoneNumber,
        "E-Mail": userDetails.email,
        "Image": userDetails.photoURL
      };

      //After Google sign in which page visible
      DatabaseMethods().addUserInfo(userDetails.uid, userInfoMap).then((value) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>All_Users()));
      });
    }
  }
}