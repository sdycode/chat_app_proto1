import 'package:cloud_firestore/cloud_firestore.dart';

class SingleChatMessageModel {
  String id = '';
  Timestamp timestamp =Timestamp(0, 0);
  String msg;
  String sender;
  String receiver;
  SingleChatMessageModel(this.msg, this.sender, this.receiver);
}
