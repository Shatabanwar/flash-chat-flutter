import 'package:firebase_core/firebase_core.dart';
import 'package:flash_chat/components/rounded_button.dart';
import 'package:flutter/material.dart';

import 'login_screen.dart';
import 'registration_screen.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WelcomeScreen extends StatefulWidget {

  static const String id = 'welcome';


  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}



class _WelcomeScreenState extends State<WelcomeScreen> {

  @override
  void initState() {

    super.initState();
    Firebase.initializeApp();
    setState(() {

    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(
                  tag: 'logo',
                  child: Container(
                    child: Image.asset('images/logo.png'),
                    height: 60.0,
                  ),
                ),
                TypewriterAnimatedTextKit(
                  text :['Flash Chat'],
                  textStyle: TextStyle(
                    fontSize: 45.0,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            RoundedButton(
              onPressed: (){
                Navigator.pushNamed(context, LoginScreen.id);
              },
              colour: Colors.lightBlueAccent,
              text: 'Log In',
            ),
            RoundedButton(
              colour: Colors.blueAccent,
              text: 'Register',
              onPressed: (){
                Navigator.pushNamed(context, RegistrationScreen.id);
              },
            ),
          ],
        ),
      ),
    );
  }
}


