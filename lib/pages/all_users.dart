import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:impel/pages/chatpage.dart';
import 'package:impel/pages/sign_in_up.dart';
import 'package:impel/services/app_colors.dart';


class All_Users extends StatefulWidget {
  @override
  _All_UsersState createState() => _All_UsersState();
}

var fname, address, email, imageurl, mobile;
_fetch()async{
  final firebaseUser = await FirebaseAuth.instance.currentUser!;
  if(firebaseUser!=null)
    await FirebaseFirestore.instance.collection('chat').doc(firebaseUser.uid).get().then((ds){
      fname=ds.data()!['First_Name'];
      address=ds.data()!['Address'];
      email=ds.data()!['E-Mail'];
      imageurl = ds.data()!['Image'];
      mobile = ds.data()!['Mobile'];

    }).catchError((e){
      print(e);
    });
}

class _All_UsersState extends State<All_Users> {
  var user;
  Future<void> getUserData() async {
    var userData = await FirebaseAuth.instance.currentUser!;
    setState(() {
      user = userData;
    });
  }

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: Padding(
          padding: const EdgeInsets.only(top: 5,left: 5),
          child: FutureBuilder(
            future: _fetch(),
            builder: (context,snapshot){
              if(snapshot.connectionState!= ConnectionState.done)
                return Text("",style: TextStyle(color: Colors.white),);
              return Column(
                children: [
                  CircleAvatar(
                    radius: 22.0,
                    backgroundImage: imageurl != null ? NetworkImage(imageurl) : AssetImage('assets/images/logo.png') as ImageProvider
                  ),

                ],
              );
            },
          ),
        ),
        title: Text('Messaging'),
        centerTitle: true,
        actions: [
          FlatButton(
              onPressed: (){
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>SignInUp()), (route) => false);
              },
              child: Icon(Icons.logout,color: Colors.white,))],
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('chat').snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Text(
                'Loading...',
                style: TextStyle(color: Colors.white),
              );
            } else {
              return
                ListView(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    children: snapshot.data!.docs.map((document) {
                      if (user.email == document['E-Mail']) {
                        return Container(
                          height: 0,
                          width: 0,
                        );
                      }
                      else {
                        return ListTile(
                          title: FlatButton(
                            onPressed: () {
                              String userid = document.id;
                              Navigator.push(context, MaterialPageRoute(
                                  builder: (context) => Chatting(myUid: userid, receiverImage: document['Image'], receiver: document['First_Name'],
                                      receiverUid: user.uid, userEmail: email, receiverEmail: document['E-Mail'], userImage: imageurl)));
                            },
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 20.0,
                                  backgroundImage: NetworkImage(
                                      document['Image'] ?? ""
                                  ),
                                ),

                                Padding(
                                  padding: const EdgeInsets.only(left: 10, right: 5),
                                  child: Text(
                                    document['First_Name'] ?? '',
                                    style: TextStyle(color: Colors.black,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),

                                Text(
                                  document['Last_Name'] ?? '',
                                  style: TextStyle(color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),

                        );
                      }
                    }).toList());
            }
          }
      ),
    );
  }
}