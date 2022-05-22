import 'dart:async';
import 'package:impel/pages/all_users.dart';
import 'package:impel/services/app_colors.dart';
import 'package:impel/services/auth.dart';
import 'package:impel/services/app_widgets.dart';
import 'package:lottie/lottie.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';


class SignInUp extends StatefulWidget {

  @override
  _SignInUpState createState() => _SignInUpState();
}

class _SignInUpState extends State<SignInUp> {

  bool _isContainerVisible = false;
  //for no internet
  bool status = true;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription _streamSubscription;

  @override
  void initState() {
    super.initState();
    checkRealtimeConnection();
  }

  void checkRealtimeConnection() {
    _streamSubscription = _connectivity.onConnectivityChanged.listen((event) {
      if (event == ConnectivityResult.mobile) {
        status = true;
      } else if (event == ConnectivityResult.wifi) {
        setState(() {
          status = true;
        });
      } else {
        status = false;
      }
      setState(() {});
    });
  }

  Future<void> SignIn() async {
    final formstate = formKey.currentState;
    if (formstate!.validate()) {
      formstate.save();
      try {
        showLoaderDialog(context);
        final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email.text, password: password.text);
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => All_Users()), (route) => false);
        appSnackBar(context, 'Success Login');
      }on FirebaseAuthException catch (e) {
        print(e.code);
        if (e.code == 'user-not-found') {
          appSnackBar(context, 'No User Found');
        } else if (e.code == 'wrong-password') {
          appSnackBar(context, 'Please Enter Correct Password');
        }
      }
    }
  }

  Future<void> SignUp()async{
    final cformkey = formKey.currentState;
    if(cformkey!.validate()){
      cformkey.save();
      try {
          var newuser = await FirebaseAuth.instance
              .createUserWithEmailAndPassword(
              email: email.text, password: password.text);

          //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>OTPVerification(_emailController.text)));

      } on FirebaseAuthException catch(e){
        print(e.message);
        if(e.message == 'The email address is already in use by another account.'){
          showDialog(context: context, builder: (BuildContext context) {
            return new AlertDialog(
              title: new Text("The E-Mail Address is Already in Use"),
            );
          }
          );
        }
      }
    }
  }

  @override
  void dispose() {
    _streamSubscription.cancel();
    super.dispose();
  }

  var formKey  = GlobalKey<FormState>();
  var email    = TextEditingController();
  var password = TextEditingController();

  var _hideText = true;
  viewPass() {
    setState(() {
      _hideText = !_hideText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return status ? Scaffold (
      body: Container(
        padding: EdgeInsets.only(left: 15, right: 15, bottom: 15),
        child: _isContainerVisible ?
        Sign_Up(context, _isContainerVisible)
            :
        ListView(
          padding: const EdgeInsets.all(20),
          physics: const BouncingScrollPhysics(),
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            Image.asset(
              'assets/images/logo.png',
              height: 150,
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              'Login',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
            ),
            const Text(
              'Please sign in to continue',
              style: TextStyle(fontSize: 15, color: AppColors.grey),
            ),
            const SizedBox(height: 25,),

            //for user input
            Form(
              key: formKey,
              child: Column(
                children: [
                  //for email address
                  inputText(email, 'Email', 'ENTER YOUR EMAIL', prefixIcon: Icons.email_outlined, labelText: 'EMAIL'),

                  const SizedBox(height: 20,),

                  //for password
                  inputText(password, 'Password', 'ENTER YOUR PASSWORD', prefixIcon: Icons.lock_outline, suffixIcon: InkWell(
                    onTap: viewPass,
                    child: _hideText
                        ? Icon(Icons.visibility_off)
                        : Icon(Icons.visibility),
                  ), obscureText: _hideText, labelText: 'PASSWORD'),
                ],
              ),
            ),

            const SizedBox(
              height: 40,
            ),

            //for button
            button(context, text: 'LOGIN',press: (){
              _isContainerVisible ? SignUp() : SignIn();
            }),

            const SizedBox(
              height: 10,
            ),

            Container(
              child: SignInButton(
                  Buttons.Google,
                  onPressed: () {
                    AuthMethods().signInWithGoogle(context);
                  }),
            ),

            SizedBox(
              height: MediaQuery.of(context).size.height / 10,
            ),
          ],
        ),
      ),
      bottomNavigationBar:
      _isContainerVisible ?
      Padding(
        padding: const EdgeInsets.only(bottom: 20, left: 250),
        child: FloatingActionButton(
          mini: true,
          backgroundColor: Colors.green,
          onPressed: () {
            setState(() {
              _isContainerVisible = !_isContainerVisible;
            });
          },
          child: Icon(
            Icons.done,
            size: 25,
          ),
        ),
      )
          :
      Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: FloatingActionButton(
          mini: true,
          backgroundColor: AppColors.primaryColor,
          onPressed: () {
            setState(() {
              _isContainerVisible = !_isContainerVisible;
            });
          },
          child: Icon(
            Icons.add,
            size: 25,
          ),
        ),
      ),
    ) : noInternet();
  }

  Widget noInternet(){
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset('assets/jsons/no_internet.json',height: 250,),
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Text('No internet connection found.\nCheck your connection and try again.',
                style: TextStyle(
                    fontSize: 15,
                    letterSpacing: 1
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget Sign_Up(BuildContext context, _isContainerVisible) {
  var courseTitle     = TextEditingController();
  var courseTopic     = TextEditingController();
  var nameOfOrganize  = TextEditingController();
  var locations       = TextEditingController();
  var year            = TextEditingController();
  var duration        = TextEditingController();

  return Center (
      child: Container (
        height: _isContainerVisible ? MediaQuery.of(context).size.height *0.65 : 0.0,
        width: _isContainerVisible ? MediaQuery.of(context).size.width : 0.0,
        child: Column(
          children: [
            //Course Title
            Padding(
                padding: const EdgeInsets.only(top: 15, bottom: 15),
                child: inputText(courseTitle, '123', 'hintText')
            ),

            //Course Topic
            inputText(courseTitle, '123', 'hintText'),

            //Name of Organization
            Padding(
              padding: const EdgeInsets.only(top: 15, bottom: 15),
              child: inputText(courseTitle, '123', 'hintText'),
            ),

            //Location
            inputText(courseTitle, '123', 'hintText'),

            //Year
            Padding(
              padding: const EdgeInsets.only(top: 15, bottom: 15),
              child: inputText(courseTitle, '123', 'hintText'),
            ),

            //Duration
            inputText(courseTitle, '123', 'hintText'),

            const SizedBox(
              height: 40,
            ),
          ],
        ),
      )
  );
}