import 'package:flutter/material.dart';

showSnack(BuildContext context, String msg, {Color? color}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
    msg,
    style: TextStyle(color: color),
  )));
}
