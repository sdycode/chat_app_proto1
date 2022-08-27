import 'package:chat_demo1/models/single_chat_message_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SinlgeMessageCard extends StatelessWidget {
  SingleChatMessageModel data;
  SinlgeMessageCard(this.data, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isSender = data.sender == FirebaseAuth.instance.currentUser!.email;
    return Container(
      margin: EdgeInsets.all(6),
      width: double.infinity,
      alignment: isSender
          // data.msg.length > 7
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: Container(
          decoration: BoxDecoration(
           color: isSender ?Color.fromARGB(255, 203, 146, 230):Color.fromARGB(255, 111, 183, 222) ,
              borderRadius: BorderRadius.circular(8)),
          padding: EdgeInsets.all(6),
          child: Text(data.msg, style: TextStyle(
            fontSize: 20, fontWeight: FontWeight.w400
          ),)),
    );
  }
}
