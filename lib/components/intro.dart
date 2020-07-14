import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intro_views_flutter/Models/page_view_model.dart';
import 'package:intro_views_flutter/intro_views_flutter.dart';

class Intro extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final page1 = PageViewModel(
      pageColor: Colors.green,
      iconImageAssetPath: null, //'assets/images/temp_logo.png',
      iconColor: null,
      bubbleBackgroundColor: Color(0x4D757575),
      body: Text(
        'The most realistic stock simulator app in the play store.',
      ),
      title: Text(
        'Welcome to Toro',
        textAlign: TextAlign.center,
      ),
      mainImage: Image.asset(
        'assets/images/temp_logo.png',
        height: 285,
        width: 285,
        alignment: Alignment.center,
      ),
      titleTextStyle: GoogleFonts.raleway(fontSize: 40, color: Colors.white),
      bodyTextStyle: GoogleFonts.raleway(fontSize: 25, color: Colors.white),
    );
    final page2 = PageViewModel(
      pageColor: Colors.green[700],
      iconImageAssetPath: null, //'assets/images/temp_logo.png',
      iconColor: null,
      bubbleBackgroundColor: Color(0x4D757575),
      body: Text(
        'Trade stocks and ETFs in real time!',
      ),
      title: Text('Trading'),
      mainImage: Image.asset(
        'assets/images/temp_logo.png',
        height: 285.0,
        width: 285.0,
        alignment: Alignment.center,
      ),
      titleTextStyle: GoogleFonts.raleway(fontSize: 40, color: Colors.white),
      bodyTextStyle: GoogleFonts.raleway(fontSize: 25, color: Colors.white),
    );
    return IntroViewsFlutter([page1, page2], onTapDoneButton: () => Navigator.popAndPushNamed(context, 'signupScreen'),);
  }
}
