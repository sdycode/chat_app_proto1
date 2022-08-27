import 'dart:async';
import 'dart:developer';

import 'package:chat_demo1/models/single_chat_message_model.dart';
import 'package:chat_demo1/services/dataservice.dart';
import 'package:chat_demo1/utils/checknet.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatDataForUser {
  static Future<List<SingleChatMessageModel>> getChatdataForUser(
      String friendemilid) async {
    List<SingleChatMessageModel> messages = [];
    DocumentSnapshot<Map<String, dynamic>>? data;
    String pairId =
        '${FirebaseAuth.instance.currentUser!.email!.toLowerCase().trim()}_$friendemilid';

   await    DataService()
        .fbStore
        .collection('chatroom/$pairId/messages').orderBy('id')
        .get()
        .then((value) {
      QuerySnapshot<Map<String, dynamic>> refMsg = value;
   refMsg.docs.forEach((m) async {
      // count++;
      try {
        Map map = m.data();
        SingleChatMessageModel model = SingleChatMessageModel(
            m.data()['msg'], m.data()['sender'], m.data()['receiver']);
        model.id = map['id'].toString();

        // model.timestamp = map['time'];
        messages.add(model);
        log('message ${messages.length}');
      } catch (e) {
        log('err $e  / ${m.data()['time'].runtimeType}');
      }
    });

    });
    
    return messages;

  }

  static Future sendThisMessage(String message, String friendemilid) async {
    // DocumentReference<
    //     Map<String,
    //         dynamic>> doc = DataService().chatroomInstance.doc(
    //     '${FirebaseAuth.instance.currentUser!.email!.toLowerCase().trim()}_$friendemilid');
    Map<String, dynamic> msgdata = {
      'id': DateTime.now().millisecondsSinceEpoch,
      'msg': message,
      'time': DateTime.now(),
      'sender': FirebaseAuth.instance.currentUser!.email ?? '',
      'receiver': friendemilid
    };
    String pairId =
        '${FirebaseAuth.instance.currentUser!.email!.toLowerCase().trim()}_$friendemilid';
            String reversepairId =
        '${friendemilid}_${FirebaseAuth.instance.currentUser!.email!.toLowerCase().trim()}';

   
    final refMsg =
        DataService().fbStore.collection('chatroom/$pairId/messages');
    refMsg.add(msgdata);
      final refMsgReverse =
        DataService().fbStore.collection('chatroom/$reversepairId/messages');
    refMsgReverse.add(msgdata);
    // String id = msgdata['id'].toString();
    // // DataService().chatroomInstance.a
    // log('msgdata $msgdata');
    // await doc.collection(id).add(msgdata['id']).then((msgdoc) {
    //   msgdoc.set({'newid': 'new ddff', 'msg': 'dfsdf'});
    // });
    // await doc.firestore.doc(msgdata['id'].toString()).set(msgdata);
    // collection(msgdata['id']).add(msgdata);
    // .set(msgdata);
  }
}
