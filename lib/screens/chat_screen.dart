import 'dart:developer';
import 'dart:math' as math;

import 'package:chat_demo1/constants.dart';
import 'package:chat_demo1/models/usermodel.dart';
import 'package:chat_demo1/utils/snack.dart';
import 'package:chat_demo1/widgets/singleMessageCard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../models/single_chat_message_model.dart';
import '../services/chat_data_service.dart';
import '../services/checknet.dart';
import '../services/dataservice.dart';
import '../utils/textstyles.dart';

class ChatScreen extends StatefulWidget {
  UserModel userModel;
  ChatScreen(this.userModel, {Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController _controller = TextEditingController();
  FocusNode _focusNode = FocusNode();
  String _friendEmailid = '';
  ScrollController _msgListcontroller = ScrollController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _friendEmailid = widget.userModel.useremail.toString().toLowerCase().trim();
  }

  @override
  void dispose() {
    _controller.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String pairId =
        '${FirebaseAuth.instance.currentUser!.email!.toLowerCase().trim()}_$_friendEmailid';
    return Scaffold(
        backgroundColor: Colors.purple.shade100,
        appBar: AppBar(
          title: Text(
            widget.userModel.username!,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            style: TxtStyles.whitetextwithSize(25),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                radius: 25,
                backgroundImage: NetworkImage(widget.userModel.imgurl!),
                backgroundColor: Colors.primaries[
                        math.Random().nextInt(Colors.primaries.length - 1)]
                    .withAlpha(20),
              ),
            ),
          ],
          //  CircleAvatar(radius: 20,
          // backgroundColor: Colors.white, child: Image.network(imgpath, fit: BoxFit.contain,)),
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            setState(() {});
          },
          child: Column(
            children: [
              StreamBuilder(
                stream: DataService()
                    .fbStore
                    .collection('chatroom/$pairId/messages')
                    .orderBy('time')
                    .snapshots(),
                // ChatDataForUser.getChatdataForUser(_friendEmailid),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<SingleChatMessageModel> messages = [];
                    QuerySnapshot<Map<String, dynamic>> refMsg =
                        snapshot.data as QuerySnapshot<Map<String, dynamic>>;
                    refMsg.docs.forEach((m) async {
                      // count++;
                      try {
                        Map map = m.data();
                        SingleChatMessageModel model = SingleChatMessageModel(
                            m.data()['msg'],
                            m.data()['sender'],
                            m.data()['receiver']);
                        model.id = map['id'].toString();

                        // model.timestamp = map['time'];
                        messages.add(model);
                        log('message ${messages.length}');
                      } catch (e) {
                        log('err $e  / ${m.data()['time'].runtimeType}');
                      }
                    });

                    // _msgListcontroller.jumpTo();
                    return
                        // Container();
                        ChatScreenWidget(messages);
                  } else {
                    return Builder(
                      builder: (context) {
                        return Expanded(
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }
                    );
                  }
                },
              ),
              TextFieldAndButton(),
            ],
          ),
        ));
  }

  Widget ChatScreenWidget(List<SingleChatMessageModel> data) {
    return Expanded(
      child: ListView.builder(
          controller: _msgListcontroller,
          itemCount: data.length + 1,
          itemBuilder: (c, i) {
            if (data.isNotEmpty) {
              if (i == data.length) {
                int count = data[i - 1].msg.split('\n').length;

                data[i - 1].msg.allMatches('\r').length;

                return Container(
                  height: 50 * count.toDouble(),
                  // data[i - 1].msg.allMatches('\r').length * 30,
                  // child: Text(count.toString()),
                  // 50,
                );
              }
            } else {
              return SizedBox.shrink();
            }

            return SinlgeMessageCard(data[i]);
          }),
    );
  }

  TextFieldAndButton() {
    return Container(
      color: Colors.transparent,
      padding: const EdgeInsets.all(20),
      child: TextField(
        minLines: 1,
        maxLines: 3,
        focusNode: _focusNode,
        controller: _controller,
        keyboardType: TextInputType.multiline,
        onSubmitted: (d) {},
        decoration: InputDecoration(
            filled: true,
            fillColor: Colors.amber.shade100,
            focusedBorder: OutlineInputBorder(
                // borderSide: BorderSide(width: 0, color: Colors.brown),
                borderRadius: BorderRadius.circular(20)),
            enabledBorder: OutlineInputBorder(
                // borderSide: BorderSide(width: null, color: Colors.orange),
                borderRadius: BorderRadius.circular(20)),
            suffixIcon: IconButton(
                onPressed: () async {
                  if (!await checkInternetConnection()) {
                    showSnack(context, 'Check Internet Connection');
                  }
                  // FocusManager.instance.primaryFocus?.unfocus();

                  _msgListcontroller.animateTo(
                      _msgListcontroller.position.maxScrollExtent,
                      duration: Duration(milliseconds: 600),
                      curve: Curves.decelerate);

                  ChatDataForUser.sendThisMessage(
                      _controller.text, _friendEmailid);
                  _controller.clear();
                  setState(() {});
                },
                icon: const Icon(
                  Icons.send,
                  color: Colors.deepPurple,
                ))),
      ),
    );
  }
}

/*
// FutureBuilder(
              //   future: ChatDataForUser.getChatdataForUser(_friendEmailid),
              //   builder: (context, snapshot) {
              //     if (snapshot.hasData &&
              //         snapshot.connectionState == ConnectionState.done) {
              //       return Container(
              //         height: h * 0.3,
              //         child: ChatScreenWidget(
              //             snapshot.data as List<SingleChatMessageModel>),
              //       );
              //     } else {
              //       return Container(
              //         height: h * 0.3,
              //       );
              //     }
              //   },
              // ),
*/
