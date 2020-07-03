import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import '../models/user.dart';
import '../constants.dart';

import 'welcome_page_button.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool showSpinner = false;
  String username;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[700],
        actions: <Widget>[
          FlatButton(
            child: Text(
              'Login',
              style: GoogleFonts.raleway(color: Colors.white),
            ),
            onPressed: () {
              Navigator.pushNamed(context, 'loginScreen');
            },
          ),
        ],
      ),
      backgroundColor: Colors.green,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // Flexible(
              //   child: Hero(
              //     tag: 'logo',
              //     child: Container(
              //       height: 200.0,
              //       child: Image.asset('assets/images/temp_logo.png'),
              //     ),
              //   ),
              // ),

              SizedBox(
                child: Center(
                  child: Text(
                    'Enter your username for Toro',
                    style:
                        GoogleFonts.raleway(fontSize: 24, color: Colors.white),
                  ),
                ),
                height: 48.0,
              ),
              SizedBox(height: 50),
              TextField(
                textAlign: TextAlign.center,
                onChanged: (value) {
                  username = value;
                },
                style: TextStyle(color: Colors.white),
                decoration: kSignUpTextFieldDecoration,
                cursorWidth: 1,
                cursorColor: Colors.white,
              ),
              SizedBox(
                height: size.height/6,
              ),
              WelcomePageButton(
                text: 'Sign Up',
                color: Colors.pink,
                onPressed: () async {
                  setState(() {
                    showSpinner = true;
                  });
                  try {
                    bool successful = await User.signUp(username: username);
                    print(successful);
                    if (successful) {
                      print(successful);
                      Navigator.pushNamedAndRemoveUntil(
                          context, 'summary', ModalRoute.withName('/'));
                    }

                    setState(() {
                      showSpinner = false;
                    });
                  } catch (e) {
                    print(e);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
