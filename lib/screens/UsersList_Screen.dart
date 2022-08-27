import 'dart:math';

import 'package:chat_demo1/services/firebase_authentication.dart';
import 'package:chat_demo1/utils/textstyles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../constants.dart';
import '../models/usermodel.dart';
import '../services/userlilst_service.dart';
import '../widgets/app_drawer.dart';
import '../widgets/usericonnamecard.dart';

class UserListScreen extends StatefulWidget {
  UserListScreen({Key? key}) : super(key: key);

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    String? imgpath =
        FirebaseAuth.instance.currentUser!.providerData[0].photoURL;
    return Scaffold(
        key: key,
        drawer: MyAppDrawer(),
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                key.currentState!.openDrawer();
              },
              icon: const Icon(Icons.menu)),
          title: Text(
            "Chat Room",
            style: TxtStyles.whitetextwithSize(25),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                radius: 25,
                backgroundImage: NetworkImage(FirebaseAuth
                    .instance.currentUser!.providerData.first.photoURL ??profileimg),
                backgroundColor: Colors
                    .primaries[Random().nextInt(Colors.primaries.length - 1)]
                    .withAlpha(20),
              ),
            ),
          ],
          //  CircleAvatar(radius: 20,
          // backgroundColor: Colors.white, child: Image.network(imgpath, fit: BoxFit.contain,)),
        ),
        body: RefreshIndicator(
                onRefresh: ()async{
      setState(() {
        
      });
    },
          child: FutureBuilder<List<UserModel>>(
            future: UserListService().getUsersFromDatabaseORcache(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData) {
                return ListView.separated(
                    separatorBuilder: (context, index) {
                      return Divider(height: 2,thickness: 2,);
                    },
                    itemCount: snapshot.data!.length,
                    itemBuilder: (c, i) {
                      return UserNameiconCard(snapshot.data![i]);
                    });
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ));
  }
}
