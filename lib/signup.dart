import 'package:flutter/material.dart';
import 'package:signup_firebase_app/auth.dart';

class SignUp extends StatelessWidget {
  TextEditingController emailcontroller = TextEditingController();

  TextEditingController passwordcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("sign up"),
      ),
      body: Column(
        children: [
          Container(
            height: 200,
            width: 500,
            color: const Color.fromARGB(255, 193, 229, 247),
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                      enabledBorder: OutlineInputBorder(),
                      hintText: "TYPE YOUR EMAIL"),
                  controller: emailcontroller,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                      enabledBorder: OutlineInputBorder(),
                      hintText: " YOUR Password"),
                  controller: passwordcontroller,
                ),
                ElevatedButton(
                    onPressed: () async {
                      await AuthenticationServices.signupMethod(context,
                          emailcontroller.text, passwordcontroller.text);
                    },
                    child: const Text("signup")),
              ],
            ),
          )
        ],
      ),
    );
  }
}
