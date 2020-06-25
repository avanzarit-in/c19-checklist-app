import 'package:c19checklist/Register.dart';
import 'package:c19checklist/utils/PageTransition.dart';
import 'package:flutter/material.dart';
import 'package:c19checklist/utils/Preferences.dart';
import 'package:c19checklist/Dashboard.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Preferences _preferences = new Preferences();
  var _alignment = Alignment.bottomCenter;

  Map storedData;
  _autoLogin() async {
    storedData = await _preferences.getPrefs();
    if (storedData['device_id'] != null) {
      Navigator.pushReplacement(context, PageTransition(Dashboard()));
    }
  }

  @override
  void initState() {
    _autoLogin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: stackedLayout(),
      ),
    );
  }

  Widget stackedLayout() {
    return Stack(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Image.asset('assets/images/home.jpg', fit: BoxFit.cover),
        ),
        imageContainer(),
        productName()
      ],
    );
  }

  Widget imageContainer() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color.fromARGB(180, 0, 0, 0), Color.fromARGB(0, 0, 0, 0)],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
        ),
      ),
    );
  }

  Widget productName() {
    return Positioned(
      bottom: 0,
      child: AnimatedContainer(
        duration: Duration(seconds: 2),
        alignment: _alignment,
        padding: EdgeInsets.all(20),
        // color: Colors.red,
        width: MediaQuery.of(context).size.width,
        height: 180,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Text(
                'C19 Checklist',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 40,
                    fontWeight: FontWeight.w800,
                    shadows: [
                      Shadow(
                          blurRadius: 5.0,
                          color: Colors.black,
                          offset: Offset(1.0, 2.0))
                    ]),
              ),
            ),
            Center(
              child: Text(
                'Self-assess System',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    shadows: [
                      Shadow(
                          blurRadius: 1.0,
                          color: Colors.black,
                          offset: Offset(0.3, 0.3))
                    ]),
              ),
            ),
            startedButton()
          ],
        ),
      ),
    );
  }

  Widget startedButton() {
    return Container(
      // padding: EdgeInsets.fromLTRB(0, top, right, bottom),
      child: RaisedButton(
        onPressed: () {
          Navigator.push(context, PageTransition(Register()));
        },
        color: Colors.deepOrange,
        child: Text(
          'Get Started',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.w700, fontSize: 18),
        ),
      ),
    );
  }

  ///Function Handler
  // _autoLogin() async {
  //   var entryStatus = await _preferences.getPrefs('entryStatus');
  //   var services = await _preferences.getPrefs('services');
  //   if (entryStatus != null) {
  //     if (entryStatus == 'partial') {
  //       Navigator.pushReplacement(context, PageTransition(UserEntry()));
  //     } else if (entryStatus == 'done') {
  //       if (services == 'checklist')
  //         Navigator.pushReplacement(context, PageTransition(Board()));
  //     }
  //   }
  // }
}
