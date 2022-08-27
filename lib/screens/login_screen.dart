// ignore_for_file: use_build_context_synchronously

import 'package:chat_demo1/screens/signup_screen.dart';
import 'package:chat_demo1/services/firebase_authentication.dart';
import 'package:chat_demo1/utils/snack.dart';
import 'package:chat_demo1/utils/textstyles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../services/userlilst_service.dart';
import '../utils/textfieldborder.dart';
import '../widgets/textroundedbutton.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();
  bool showloginloading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              Color.fromARGB(255, 150, 220, 211),
              Color.fromARGB(255, 210, 242, 240),
            ],
          ),
        ),
        child: Stack(children: [
          Center(
            child: Form(
              key: _formkey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Spacer(),
                  Container(
                    margin: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: const LinearGradient(
                        begin: Alignment.bottomLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color.fromARGB(255, 140, 226, 220),
                          Color.fromARGB(255, 169, 192, 206),
                        ],
                      ),
                    ),
                    child: Column(
                      children: [
                        _emailField(),
                        SizedBox(
                          height: 8,
                        ),
                        _passwordField(),
                      ],
                    ),
                  ),
                  Spacer(),
                  InkWell(
                    onTap: () async {
                      _formkey.currentState!.save();
                      if (_formkey.currentState!.validate()) {
                        String pass = await UserListService()
                            .checkPasswordForthisUser(_emailController.text);
                        if (pass == _passwordController.text) {
                          setState(() {
                            showloginloading = true;
                          });
                          FirebaseAuthClass(FirebaseAuth.instance)
                              .signinwithEmailAndPassword(_emailController.text,
                                  _passwordController.text, context);
                          Future.delayed(Duration(seconds: 10)).then((value) {
                            showloginloading = false;
                          });
                        } else {
                          showSnack(context, 'Email or Password is not correct',
                              color: Colors.red);
                        }
                      }
                    },
                    child: RoundTextButton(
                      'Login',
                    ),
                  ),
                  signupText(),
                  Divider(),
                  Text('OR'),
                  Divider(),
                  InkWell(
                    onTap: () async {
                      showloginloading = true;
                      setState(() {});
                      FirebaseAuthClass(FirebaseAuth.instance)
                          .signInWithGoogle(context);
                      await Future.delayed(Duration(seconds: 5));
                      showloginloading = false;
                    },
                    child: RoundTextButton(
                      'SignIn with Google',
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (showloginloading)
            Center(
              child: CircularProgressIndicator(),
            )
        ]),
      ),
    );
  }

  Future<Function> login() async {
    return () async {};
  }

  _passwordField() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: TextFormField(
        controller: _passwordController,
        onChanged: (d) {
          if (d.characters.last == ' ') {
            _passwordController.text = d.trim();
            _passwordController.selection = TextSelection.fromPosition(
                TextPosition(offset: _passwordController.text.length));
          }
        },
        onFieldSubmitted: (d) {
          // _formkey.currentState?.validate();
          _passwordFocus.unfocus();
        },
        validator: (d) {
          return FirebaseAuthClass.validatePassword(_passwordController);
        },
        decoration: InputDecoration(
          hintText: 'Enter Password',
          label: const Text('Password'),
          prefixIcon: const Icon(Icons.lock),
          disabledBorder: loginenableborder,
          enabledBorder: loginenableborder,
          focusedBorder: focusedBorder,
        ),
      ),
    );
  }

  _emailField() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: TextFormField(
        controller: _emailController,
        onChanged: (d) {
          if (d.isNotEmpty) {
            if (d.characters.last == ' ') {
              _emailController.text = d.trim();
              _emailController.selection = TextSelection.fromPosition(
                  TextPosition(offset: _emailController.text.length));
            }
          }
        },
        onFieldSubmitted: (d) {
          // _formkey.currentState?.validate();
          _emailFocus.unfocus();
        },
        validator: (d) {
          return FirebaseAuthClass.validateEmail(_emailController);
        },
        decoration: InputDecoration(
          hintText: 'Enter Email',
          label: Text('Email'),
          prefixIcon: const Icon(Icons.email),
          disabledBorder: loginenableborder,
          enabledBorder: loginenableborder,
          focusedBorder: focusedBorder,
        ),
      ),
    );
  }

  signupText() {
    return RichText(
      text: TextSpan(
          text: "Don't have an account?",
          style: TxtStyles.blackwithSize(16),
          children: <InlineSpan>[
            TextSpan(
              text: " SignUp",
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => SignupPage()));
                },
              style: TxtStyles.blackwithSize(20),
            )
          ]),
    );
  }
}
