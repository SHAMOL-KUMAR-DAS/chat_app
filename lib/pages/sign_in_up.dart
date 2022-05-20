import 'dart:async';
import 'package:impel/services/app_colors.dart';
import 'package:impel/services/app_widgets.dart';
import 'package:impel/test.dart';
import 'package:lottie/lottie.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';


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
        final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email.text, password: password.text);
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Testing()), (route) => false);
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
        SignUp(_isContainerVisible)
            :
        ListView(
          padding: const EdgeInsets.all(20),
          physics: const BouncingScrollPhysics(),
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 10,
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
            const SizedBox(height: 40,),

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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: button(context, text: 'LOGIN',press: (){
                showLoaderDialog(context);
                SignIn();
              })

            ),

            const SizedBox(
              height: 40,
            ),

            // GestureDetector(
            //   onTap: (){
            //     setState(() {
            //       _isContainerVisible = !_isContainerVisible;
            //     });
            //   },
            //   child: const Center(
            //       child: Text(
            //         'Don\'t Have Account? Create Account',
            //         style: TextStyle(color: AppColors.primaryColor, fontSize: 12),
            //       )),
            // ),

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
          backgroundColor: Colors.green,
          onPressed: () {
            setState(() {
              _isContainerVisible = !_isContainerVisible;
            });
          },
          child: Icon(
            Icons.done,
            size: 35,
          ),
        ),
      )
          :
      Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: FloatingActionButton(
          backgroundColor: AppColors.primaryColor,
          onPressed: () {
            setState(() {
              _isContainerVisible = !_isContainerVisible;
            });
          },
          child: Icon(
            Icons.add,
            size: 35,
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

class SignUp extends StatefulWidget {
  SignUp(this._isContainerVisible);
  bool _isContainerVisible;

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  var courseTitle     = TextEditingController();
  var courseTopic     = TextEditingController();
  var nameOfOrganize  = TextEditingController();
  var locations       = TextEditingController();
  var year            = TextEditingController();
  var duration        = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Center (
        child: Container (
          height: widget._isContainerVisible ? MediaQuery.of(context).size.height *0.65 : 0.0,
          width: widget._isContainerVisible ? MediaQuery.of(context).size.width : 0.0,
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
}