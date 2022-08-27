import 'package:chat_demo1/utils/textstyles.dart';
import 'package:flutter/material.dart';

class RoundTextButton extends StatelessWidget {
  String text;


  RoundTextButton(this.text, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      margin: EdgeInsets.all(30),
      decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color.fromARGB(255, 97, 199, 192),
              Color.fromARGB(255, 62, 182, 226)
            ],
          ),
          borderRadius: BorderRadius.circular(30)),
      child: Center(
        child: Text(text, style: TxtStyles.loginbtntext),
      ),
    );
  }
}
