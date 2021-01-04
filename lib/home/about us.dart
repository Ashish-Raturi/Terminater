import 'package:expire_item/shared/constant.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:snappable/snappable.dart';

class AboutUs extends StatefulWidget {
  @override
  _AboutUsState createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: c1,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Stack(children: [
            Positioned(
              right: 10.0,
              top: 10.0,
              child: IconButton(
                onPressed: () {
                  print('yo');
                  Navigator.pop(context);
                },
                icon: Image.asset(
                  'assets/icons/cross.png',
                  fit: BoxFit.cover,
                  height: 20.0,
                  color: Colors.white,
                  width: 20.0,
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 50.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text('About Appliction',
                      style: GoogleFonts.archivo(
                          fontSize: 30.0,
                          color: Colors.white,
                          fontWeight: FontWeight.w500)),
                  SizedBox(
                    height: 30.0,
                  ),
                  Snappable(
                    snapOnTap: true,
                    child: Container(
                        alignment: Alignment.topCenter,
                        child: Image.asset(
                          'assets/icons/logo.png',
                          height: 150.0,
                          width: 150.0,
                        )),
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  Text('Terminate',
                      style: GoogleFonts.ubuntu(
                          fontSize: 30.0, color: Colors.amberAccent)),
                  SizedBox(
                    height: 30.0,
                  ),
                  Text(
                      'Terminate is a mobile app that keeps track of the expiry date of objects, and was built using flutter with cloud firebase. It allows user to add or delete objects and can upload or download pictures of objects and bill.',
                      style: GoogleFonts.ubuntu(
                        fontSize: 20.0,
                        color: Colors.white,
                      )),
                  SizedBox(
                    height: 30.0,
                  ),
                  Text('About Developer',
                      style: GoogleFonts.ubuntu(
                          fontSize: 30.0,
                          color: Colors.white,
                          fontWeight: FontWeight.w500)),
                  SizedBox(
                    height: 30.0,
                  ),
                  Text(
                      'Hi, I\'m Ashish Raturi, a Flutter App Developer this is my forth Project. I started this project on 07-Nov-2020 and completed it within one and a half progressive week.',
                      style: GoogleFonts.ubuntu(
                          fontSize: 20.0, color: Colors.white)),
                  SizedBox(
                    height: 30.0,
                  ),
                  Text('Thanks For Downloading it :)',
                      style: GoogleFonts.ubuntu(
                          fontSize: 25.0, color: Colors.white)),
                  SizedBox(
                    height: 30.0,
                  ),
                  Text(
                    '\nDevelop In\n',
                    style: GoogleFonts.ubuntu(
                      fontSize: 30.0,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      wordSpacing: 1.0,
                      letterSpacing: 2.0,
                    ),
                  ),
                  Snappable(
                    snapOnTap: true,
                    child: Container(
                      alignment: Alignment.bottomCenter,
                      child: Image.asset(
                        'assets/icons/flutter.png',
                        height: 100.0,
                        width: 200.0,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
