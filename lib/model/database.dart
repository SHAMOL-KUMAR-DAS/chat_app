import 'package:cloud_firestore/cloud_firestore.dart';

class DataBaseUserService{
  var uid;
  DataBaseUserService({this.uid});

  final CollectionReference user = FirebaseFirestore.instance.collection('chat');

  Future UpdateUserData(String _fname, _lname, _address, _mobile, _email) async{
    return await user.doc(uid).set({
      'First_Name': _fname,
      'Mobile': _mobile,
      'E-Mail': _email,
    });
  }
  Future updateuserimage(String image) async{
    return await user.doc(uid).update({
      'Image': image,
    });
  }
}

class DatabaseMethods{
  Future addUserInfo(String userId, Map<String, dynamic> userInfoMap) async{
    return await FirebaseFirestore.instance.collection('chat').doc(userId).set(
        (userInfoMap)
    );
  }
}