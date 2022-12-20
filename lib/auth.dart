import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:signup_firebase_app/login.dart';
import 'package:signup_firebase_app/main.dart';

class AuthenticationServices {
  static signupMethod(context, email, password) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    try {
      await auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) {
        print("success");
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => const Login()));
      });
    } catch (e) {
      print("Ans_Error=$e");
    }
  }

  static sigin(context, email, password) async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    try {
      UserCredential userCredential = await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => const HomePage()));
    } catch (e) {
      print(e);
    }
  }
}
