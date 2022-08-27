import 'dart:developer';

import 'package:chat_demo1/utils/textfieldborder.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../services/firebase_authentication.dart';
import '../widgets/textroundedbutton.dart';

class SignupPage extends StatefulWidget {
  SignupPage({Key? key}) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _nameController = TextEditingController();
  final _phonenoController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  final _nameFocus = FocusNode();
  final _phoneFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();
  final __confirmPasswordFocus = FocusNode();
  bool showpasswordmatching = false;

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
        child: Form(
          key: _formkey,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 60,
                  ),
                  _nameField(),
                  _emailField(),
                  _phoneField(),
                  _passwordField(),
                  _confirmPasswordField(),
                  const SizedBox(
                    height: 20,
                  ),
                  if (showpasswordmatching)
                    const Text(
                      'Password is not matched !!!',
                      style: TextStyle(
                          color: Colors.red,
                          fontSize: 20,
                          fontWeight: FontWeight.w600),
                    ),
                  const SizedBox(
                    height: 60,
                  ),
                  _signUPButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _signUPButton() {
    return InkWell(
      onTap: () {
        _formkey.currentState!.save();

        if (_formkey.currentState!.validate()) {
          if (_passwordController.text == _confirmPasswordController.text) {
            FirebaseAuthClass(FirebaseAuth.instance).signUPwithEmailAndPassword(
                _emailController.text,
                _passwordController.text,
                _phonenoController.text,
                _nameController.text,
                context);
          } else {
            setState(() {
              showpasswordmatching = true;
            });
            Future.delayed(Duration(seconds: 10)).then((value) {
              setState(() {
                showpasswordmatching = false;
              });
            });
          }
        }
      },
      child: RoundTextButton(
        'SignUp',
      ),
    );
  }

  _emailField() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: TextFormField(
        controller: _emailController,
        onChanged: (d) {
          if (d.characters.last == ' ') {
            _emailController.text = d.trim();
            _emailController.selection = TextSelection.fromPosition(
                TextPosition(offset: _emailController.text.length));
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
          disabledBorder: enabledBorder,
          enabledBorder: enabledBorder,
          focusedBorder: focusedBorder,
        ),
      ),
    );
  }

  _nameField() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: TextFormField(
        controller: _nameController,
        onChanged: (d) {},
        onFieldSubmitted: (d) {
          _nameFocus.unfocus();
        },
        validator: (d) {
          return FirebaseAuthClass.validateName(_nameController);
        },
        decoration: InputDecoration(
          hintText: 'Enter Name',
          label: Text('Name'),
          prefixIcon: const Icon(Icons.man),
          disabledBorder: enabledBorder,
          enabledBorder: enabledBorder,
          focusedBorder: focusedBorder,
        ),
      ),
    );
  }

  _phoneField() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: TextFormField(
        keyboardType: TextInputType.phone,
        controller: _phonenoController,
        onChanged: (d) {
          if (d.isNotEmpty) {
            if (d.characters.last == ' ') {
              _phonenoController.text = d.trim();
              _phonenoController.selection = TextSelection.fromPosition(
                  TextPosition(offset: _phonenoController.text.length));
            }
            setState(() {});
          }
        },
        onSaved: (d) {
          setState(() {});
        },
        onFieldSubmitted: (d) {
          // _formkey.currentState?.validate();
          _phoneFocus.unfocus();
        },
        maxLength: 10,
        validator: (d) {
          return FirebaseAuthClass.validatePhoneNo(_phonenoController);
        },
        decoration: InputDecoration(
          counter: Text('${_phonenoController.text.length}/10'),
          hintText: 'Enter phone number',
          label: Text('Phone Number'),
          prefixIcon: const Icon(Icons.phone),
          disabledBorder: enabledBorder,
          enabledBorder: enabledBorder,
          focusedBorder: focusedBorder,
        ),
      ),
    );
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
          disabledBorder: enabledBorder,
          enabledBorder: enabledBorder,
          focusedBorder: focusedBorder,
        ),
      ),
    );
  }

  _confirmPasswordField() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: TextFormField(
        controller: _confirmPasswordController,
        onChanged: (d) {
          if (d.characters.last == ' ') {
            _confirmPasswordController.text = d.trim();
            _confirmPasswordController.selection = TextSelection.fromPosition(
                TextPosition(offset: _confirmPasswordController.text.length));
          }
        },
        onFieldSubmitted: (d) {
          // _formkey.currentState?.validate();
          _passwordFocus.unfocus();
        },
        validator: (d) {
          return FirebaseAuthClass.validatePassword(_confirmPasswordController);
        },
        obscureText: true,
        decoration: InputDecoration(
          hintText: 'Enter Password Again',
          label: const Text('Confirm Password'),
          prefixIcon: const Icon(Icons.lock),
          disabledBorder: enabledBorder,
          enabledBorder: enabledBorder,
          focusedBorder: focusedBorder,
        ),
      ),
    );
    // _confirmPasswordController , __confirmPasswordFcus, 'Enter Password Again', 'Confirm Password'
  }
}
/*

 _nameField(_nameController, _nameFocus, 'Enter Name', 'Name'),
                _emailField(_emailController, _emailFocus, 'Enter Email', 'Email'),
                _phoneField(_phonenoController, _phoneFocus, 'Enter phone number','Phone Number'),
                _passwordField(_passwordController, _passwordFocus, 'Enter Password', 'Password'),
                  _confirmPasswordField(_confirmPasswordController , __confirmPasswordFocus, 'Enter Password Again', 'Confirm Password'),
             

             */