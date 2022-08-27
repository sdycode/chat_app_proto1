import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TxtStyles {
  static const loginbtntext = TextStyle(color: Colors.white, fontSize: 25);
    static const darktext = TextStyle(color: Colors.black, fontSize: 20);
    static TextStyle whitetextwithSize(double d){ 
return TextStyle(color: Colors.white, fontSize: d, fontWeight: FontWeight.w600);
    }


    static TextStyle blackwithSize(double d){ 
return TextStyle(color: Colors.black, fontSize: d, fontWeight: FontWeight.w600);
    }
}
