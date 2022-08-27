// ignore_for_file: use_build_context_synchronously

import 'package:chat_demo1/constants.dart';
import 'package:chat_demo1/screens/UsersList_Screen.dart';
import 'package:chat_demo1/services/dataservice.dart';
import 'package:chat_demo1/services/userlilst_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../LocalDataService.dart';
import '../utils/checknet.dart';
import '../utils/snack.dart';

class FirebaseAuthClass {
  FirebaseAuth _auth;
  FirebaseAuthClass(this._auth);
  FirebaseAuth get auth => _auth;
  User get user => _auth.currentUser!;

  signUPwithEmailAndPassword(String email, String password, String phoneno,
      String name, BuildContext context) async {
    UserCredential _userCredential = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);

    Map<String, Map<String, String>> _userFullData = {
      'user': {
        'email': _userCredential.user!.email.toString(),
        'name': name,
        'img': profileimg,
        'phone': phoneno,
        'pass': password
      }
    };

    if (!await UserListService()
        .checkThisUserIdexistOrNot(_userCredential.user!.email.toString())) {
      DataService().usersInstance.add(_userFullData);
    }

    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (c) => UserListScreen()));
  }

  signinwithEmailAndPassword(
      String email, String password, BuildContext context) async {
    UserCredential _userCredential = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    // var token;
    // try {
    //    token = _userCredential.credential!.token;
    // } catch (e) {}
    // if (token != null) {
      
    // }
    Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (c) => UserListScreen()));
  }

  signInWithGoogle(BuildContext context) async {
    if (!await checkInternetConnection()) {
      showSnack(context, 'Check Internet Connection');
      return;
    } else {
      final GoogleSignInAccount? _currentUser =
          await GoogleSignIn(signInOption: SignInOption.standard).signIn();

      print(' email ${_currentUser!.email}');

      late GoogleSignInAuthentication googleAuth;
      try {
        googleAuth = await _currentUser.authentication;
      } catch (e) {}

      if (googleAuth.accessToken != null && googleAuth.idToken != null) {
        final credential = GoogleAuthProvider.credential(
            accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
        UserCredential _userCredential =
            await _auth.signInWithCredential(credential);

        Map<String, Map<String, String>> _userFullData = {
          'user': {
            'email': _userCredential.user!.email.toString(),
            'name': _userCredential.user!.displayName.toString(),
            'img': _userCredential.user!.providerData[0].photoURL.toString()
          }
        };
        if (!await UserListService().checkThisUserIdexistOrNot(
            _userCredential.user!.email.toString())) {
          DataService().usersInstance.add(_userFullData);
        }

        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (c) => UserListScreen()));
      }
    }
  }

  static String? validateEmail(TextEditingController emailController) {
    bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(emailController.text);
    String? errortext = emailValid ? null : 'Incorrect  EmailId';
    return errortext;
  }

  static String? validatePassword(TextEditingController passwordController) {
    if (passwordController.text.trim().length < 8) {
      return 'Password must have miniumum 8 characters';
    }
    return null;
  }

  static String? validateName(TextEditingController nameController) {
    // RegExp rex = RegExp(
    //   r"^\s*([A-Za-z]{1,}([\.,] |[-']| ))+[A-Za-z]+\.?\s*$",
    // );
    if (nameController.text.trim().isNotEmpty) {
      if (nameController.text.trim().contains(RegExp(r'[a-zA-Z]'))) {
        return null;
      }
      return 'Please enter valid name';
    } else {
      return 'Please enter valid name';
    }
  }

  static String? validatePhoneNo(TextEditingController phonenoController) {
    if (int.tryParse(phonenoController.text) != null) {
      if (phonenoController.text.length != 10) {
        return "Enter 10 digit phone no";
      }
      return null;
    }
    return "Enter valid phone no";
  }

  static validatePasswordForLogin(TextEditingController passwordController,
      TextEditingController emailController) async {
    if (await UserListService()
        .checkThisUserIdexistOrNot(emailController.text.trim())) {
      String password = await UserListService()
          .checkPasswordForthisUser(emailController.text.trim());
    }

    // DataService().usersInstance.
  }
}
