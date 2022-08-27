import 'dart:math';

import 'package:chat_demo1/models/usermodel.dart';
import 'package:chat_demo1/screens/chat_screen.dart';
import 'package:chat_demo1/utils/textstyles.dart';
import 'package:flutter/material.dart';

class UserNameiconCard extends StatelessWidget {
  UserModel userModel;
  UserNameiconCard(this.userModel, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (c) => ChatScreen(userModel)));
      },
      child: Container(
        padding: EdgeInsets.all(6),
        child: Row(
          children: [
            CircleAvatar(
              radius: 25,
              backgroundImage: NetworkImage(userModel.imgurl!, scale: 0.2),
              backgroundColor: Colors
                  .primaries[Random().nextInt(Colors.primaries.length - 1)]
                  .withAlpha(20),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(3.0),
                child: Text(
                  userModel.username!,
                  // 'data',
                  style: TxtStyles.blackwithSize(18),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
