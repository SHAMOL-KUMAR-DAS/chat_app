import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:impel/services/app_colors.dart';
import 'package:impel/services/app_widgets.dart';
import 'package:intl/intl.dart';

class Chatting extends StatefulWidget {
  var myUid, receiverImage, receiver, receiverUid, userEmail, receiverEmail, userImage;

  Chatting(
      {this.myUid,
      this.receiverImage,
      this.receiver,
      this.receiverUid,
      this.userEmail,
      this.receiverEmail,
      this.userImage});
  @override
  _ChattingState createState() => _ChattingState();
}

class _ChattingState extends State<Chatting> {
  var chatRoomId, messageId = '';
  TextEditingController _message = TextEditingController();

  getMyInfo() async {
    chatRoomId = getChatRoomId(widget.myUid, widget.receiverUid);
  }

  getChatRoomId(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  getAndSetMessages() async {}
  doThisLaunch() async {
    await getMyInfo();
    getAndSetMessages();
  }
  @override
  void initState() {
    doThisLaunch();
    super.initState();
  }

  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,

        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(widget.receiver),
            CircleAvatar(
              radius: 20.0,
              backgroundImage: widget.receiverImage != null ? NetworkImage(widget.receiverImage) : AssetImage('assets/images/logo.png') as ImageProvider,
            ),
          ],
        ),

      ),
      body: Column(children: [
        Expanded(
          child: Container(
            child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('chatRooms')
                    .doc(chatRoomId)
                    .collection('Messages')
                    .orderBy('messageTime', descending: true)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return Text('Loading...');
                  } else
                    return ListView(
                        reverse: true,
                        physics: BouncingScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        children: snapshot.data!.docs.map((document) {
                          return Column(
                              crossAxisAlignment:
                              widget.userEmail != document['senderEmail']
                                  ? CrossAxisAlignment.start
                                  : CrossAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                            color: widget.userEmail !=
                                                document['senderEmail']
                                                ? AppColors.primaryColor
                                                : Color(0xFF3d403d)),
                                        child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Column(
                                            children: [
                                              Text(
                                                document['Message'] ?? '',
                                                style:
                                                TextStyle(color: Colors.white,fontSize: 15),

                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Text(DateFormat.yMd().add_jm().format(document['messageTime'].toDate()),style: TextStyle(fontSize: 8),)
                                    ],
                                  ),
                                ),
                              ]);
                        }).toList());
                }),
          ),
        ),

        Row(
          children: [
            SizedBox(width: 10.0),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(left: 12, bottom: 3, top: 3,),
                margin: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                    color: AppColors.backgroundColor,
                    boxShadow: AppColors.softShadowsInvert,
                    borderRadius: BorderRadius.circular(30.0)),
                child: TextField(
                  controller: _message,
                  style: TextStyle(color: AppColors.textColor, fontSize: 16.0),
                  decoration: InputDecoration(
                      hintText: 'Type Your Message',
                      hintStyle:
                      TextStyle(color: AppColors.textColor.withOpacity(.6)),
                      filled: false,
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 6.0, vertical: 8.0)),
                ),
              ),
            ),
            SizedBox(width: 10.0),
            sendButton(icon: Icons.send, size: 24.0,
              action: () {
                FirebaseFirestore.instance
                    .collection('chatRooms')
                    .doc(chatRoomId)
                    .collection('Messages')
                    .doc()
                    .set({
                  'Message': _message.text,
                  'senderEmail': widget.userEmail,
                  'receiverEmail': widget.receiverEmail,
                  'messageTime': DateTime.now(),
                }).then((value) => _message.text = '');
              },
            ),
          ],
        ),
      ]),
    );
  }
  Widget timeView(time) {
    return Text(DateFormat.yMMMd().add_jm().format(time),
        style: TextStyle(fontSize: 6));
  }
}