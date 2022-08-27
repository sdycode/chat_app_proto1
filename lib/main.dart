import 'dart:developer';

import 'package:chat_demo1/screens/UsersList_Screen.dart';
import 'package:chat_demo1/constants.dart';
import 'package:chat_demo1/firebase_options.dart';
import 'package:chat_demo1/screens/login_screen.dart';
import 'package:chat_demo1/provider.dart';
import 'package:chat_demo1/screens/signup_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ).catchError((d) {
    log(
      'catcherr $d',
    );
  });
  FirebaseAuth.instance.authStateChanges();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => ProviderData())
        ],
        child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            theme: ThemeData(
              primarySwatch: Colors.deepPurple,
            ),
            home: Builder(builder: (context) {
              h = MediaQuery.of(context).size.height;
              w = MediaQuery.of(context).size.width;
              return StreamBuilder<User?>(
                stream: FirebaseAuth.instance.authStateChanges(),
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if (snapshot.hasData) {
                    User _user = snapshot.data as User;
                    log('_user $_user');
                    return UserListScreen();
                  } else {
                    return 
                    // SignupPage();
                    LoginScreen();
                  }
                },
              );
            })));
  }
}
