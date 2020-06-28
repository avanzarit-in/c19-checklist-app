import 'package:c19checklist/Dashboard.dart';
import 'package:c19checklist/utils/FireStore.dart';
import 'package:c19checklist/utils/PageTransition.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:c19checklist/utils/Errordialog.dart';
import 'package:device_info/device_info.dart';
import 'package:c19checklist/utils/Preferences.dart';
import 'package:flutter/services.dart';

class CodeVerification extends StatefulWidget {
  final String verificationId;
  final List<int> code;
  final String type;
  final Map<String, dynamic> regData;
  CodeVerification(this.verificationId, this.code, this.type, [this.regData]);

  @override
  _CodeVerificationState createState() => _CodeVerificationState();
}

class _CodeVerificationState extends State<CodeVerification> {
  final GlobalKey<FormState> _codeKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _codeState = GlobalKey<ScaffoldState>();
  TextEditingController _codeController = TextEditingController();
  CustomErrorDialog _customErrorDialog = new CustomErrorDialog();
  Preferences _preferences = new Preferences();
  FireStore _fireStore = new FireStore();
  bool _codeValidate = false;
  bool _codeloading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _codeState,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text('Verify Code'),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: codeLayout(),
      ),
    );
  }

  Widget codeLayout() {
    return Container(
      padding: EdgeInsets.all(20),
      child: Form(
        key: _codeKey,
        autovalidate: _codeValidate,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [codeBlock(), valButton()],
        ),
      ),
    );
  }

  Widget codeBlock() {
    return Container(
      child: TextFormField(
        controller: _codeController,
        decoration: InputDecoration(
            labelText: 'Code',
            labelStyle: TextStyle(fontWeight: FontWeight.w800),
            errorStyle: TextStyle(
                color: Colors.red, fontSize: 16, fontWeight: FontWeight.w800)),
        keyboardType: TextInputType.number,
        validator: (value) {
          if (value.isEmpty) {
            return 'Enter code to validate';
          }
          return null;
        },
        onSaved: (value) {
          _codeController.text = value;
        },
      ),
    );
  }

  Widget valButton() {
    return (_codeloading)
        ? Container(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Container(
            child: RaisedButton(
              color: Colors.deepOrange,
              onPressed: () {
                verifyProcess();
              },
              child: Text('Verify'),
            ),
          );
  }

  verifyProcess() async {
    if (_codeKey.currentState.validate()) {
      _codeKey.currentState.save();
      setState(() {
        _codeloading = true;
        _codeValidate = false;
      });
      try {
        AuthCredential credential = PhoneAuthProvider.getCredential(
            verificationId: widget.verificationId,
            smsCode: _codeController.text.trim());
        AuthResult result =
            await FirebaseAuth.instance.signInWithCredential(credential);
        FirebaseUser user = result.user;
        if (user != null) {
          if (widget.type == 'reg') {
            widget.regData['deviceId'] =
                await _getDeviceId(await DeviceInfoPlugin().androidInfo);
            var doc =
                await _fireStore.addData(widget.regData, 'registeredUser');
            if (doc.documentID != '') {
              widget.regData['documentId'] = doc.documentID;
              if (await _preferences.setPrefs(widget.regData)) {
                Navigator.pushReplacement(context, PageTransition(Dashboard()));
              }
            }
          } else {
            if (await _preferences.setPrefs(widget.regData)) {
              Navigator.pushReplacement(context, PageTransition(Dashboard()));
            }
          }
        } else {
          _customErrorDialog.showErrorDialog(
              context, 'An error occurred while validating');
        }
      } on PlatformException catch (e) {
        setState(() {
          _codeloading = false;
        });
        _codeState.currentState.showSnackBar(SnackBar(
          content: Text(e.message.toString()),
          behavior: SnackBarBehavior.fixed,
        ));
      }
    } else {
      setState(() {
        _codeValidate = true;
        _codeloading = false;
      });
    }
  }

  _getDeviceId(AndroidDeviceInfo build) async {
    return build.androidId;
  }
}
