import 'package:chat_demo1/screens/login_screen.dart';
import 'package:chat_demo1/utils/textstyles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../services/userlilst_service.dart';

class MyAppDrawer extends StatefulWidget {
  const MyAppDrawer({Key? key}) : super(key: key);

  @override
  State<MyAppDrawer> createState() => _MyAppDrawerState();
}

class _MyAppDrawerState extends State<MyAppDrawer> {
  @override
  void initState() {
    // TODO: implement initState
    loadUsername();
    super.initState();
  }

  String name = '';
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          SizedBox(
            height: 80,
          ),
          Center(
            child:
                Text(
                //  FirebaseAuth.instance.currentUser!.displayName ?? name  
               name ,
               style:const  TextStyle(
                color: Colors.purple,
                fontSize: 30,
                fontWeight: FontWeight.w700
               ),
                 )   
                  // FirebaseAuth.instance.currentUser!.displayName.toString() ?? ),
          ),

          Divider(),
          // Text(name),
          InkWell(
              onTap: () async {
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (c) => LoginScreen()));
                await FirebaseAuth.instance.signOut();
                try {
                     await GoogleSignIn().signOut();
                } catch (e) {
                  
                }
             
              },
              child: Text(
                'Sign Out',
                style: TxtStyles.blackwithSize(25),
              ))
        ],
      ),
    );
  }

  void loadUsername() async {
    name = await UserListService().getUserNameforthisemail(
        FirebaseAuth.instance.currentUser!.email!.trim());
    setState(() {});
  }
}
