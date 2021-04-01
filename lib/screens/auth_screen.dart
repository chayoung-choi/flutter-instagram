import 'package:flutter/material.dart';
import 'package:instagram/screens/profile_screen.dart';
import 'package:instagram/widget/sign_in_form.dart';
import 'package:instagram/widget/sign_up_form.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  Widget signUpForm = SignUpForm();
  Widget signInForm = SignInForm();
  Widget currentWidget = SignUpForm();

  @override
  void initState() {
    if (currentWidget == null) currentWidget = signUpForm;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            AnimatedSwitcher(
              child: currentWidget,
              duration: duration,
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                color: Colors.white,
                child: FlatButton(
                  onPressed: () {
                    setState(() {
                      if (currentWidget is SignUpForm) {
                        currentWidget = signInForm;
                      } else {
                        currentWidget = signUpForm;
                      }
                    });
                  },
                  child: RichText(
                      text: TextSpan(
                          text: (currentWidget is SignUpForm) ? "Alreay have an account? " : "Don't have an account? ",
                          style: TextStyle(color: Colors.grey),
                          children: [
                        TextSpan(
                            text: "sdfs",
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ))
                      ])),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
