import 'package:c19checklist/CodeVerification.dart';
import 'package:c19checklist/Dashboard.dart';
import 'package:c19checklist/utils/Errordialog.dart';
import 'package:c19checklist/utils/FireStore.dart';
import 'package:c19checklist/utils/PageTransition.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  GlobalKey<ScaffoldState> _loginKey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> _loginForm = GlobalKey<FormState>();
  TextEditingController _mobileNumber = TextEditingController();

  FireStore _fireStore = new FireStore();
  CustomErrorDialog _customErrorDialog = new CustomErrorDialog();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _logValidate = false;
  bool _logLoading = false;

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _loginKey,
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: loginLayout(),
      ),
    );
  }

  Widget loginLayout() {
    return Container(
      padding: EdgeInsets.all(20),
      height: MediaQuery.of(context).size.height,
      child: Form(
        key: _loginForm,
        autovalidate: _logValidate,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [phoneBlock(), buttonBlock()],
        ),
      ),
    );
  }

  Widget phoneBlock() {
    return Container(
      child: TextFormField(
        controller: _mobileNumber,
        decoration: InputDecoration(
            prefixText: '+',
            labelText: 'Mobile Number',
            labelStyle: TextStyle(fontWeight: FontWeight.w800),
            errorStyle: TextStyle(
                color: Colors.red, fontSize: 16, fontWeight: FontWeight.w800)),
        keyboardType: TextInputType.number,
        validator: (value) {
          if (value.isEmpty) {
            return 'Enter your Mobile Number';
          } else if (value.length != 12) {
            return '12 digits including rcountry code';
          }
          return null;
        },
        onSaved: (value) {
          _mobileNumber.text = value;
        },
      ),
    );
  }

  Widget buttonBlock() {
    return (_logLoading)
        ? Container(
            padding: EdgeInsets.all(10),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Container(
            padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
            child: RaisedButton(
              color: Colors.deepOrange,
              onPressed: () {
                _logUser();
                FocusScope.of(context).requestFocus(FocusNode());
              },
              child: Text(
                'Login',
                style: TextStyle(color: Colors.white),
              ),
            ),
          );
  }

  ///Function handlers
  Map userData = {};
  _logUser() async {
    if (_loginForm.currentState.validate()) {
      _loginForm.currentState.save();
      setState(() {
        _logValidate = false;
        _logLoading = true;
      });
      var docs = await _fireStore.getDataFromSingleClause(
          _mobileNumber.text.toString(), 'phone', 'registeredUser');
      if (docs.documents.length == 0) {
        _loginKey.currentState.showSnackBar(SnackBar(
          content: Text('Mobile number is not registered'),
          behavior: SnackBarBehavior.floating,
        ));
        setState(() {
          _logLoading = false;
        });
      } else {
        docs.documents.map((doc) {
          setState(() {
            userData = doc.data;
          });
        }).toList();
        await _auth.verifyPhoneNumber(
            phoneNumber: '+' + _mobileNumber.text.toString(),
            timeout: Duration(seconds: 0),
            verificationCompleted: (authCredential) =>
                _verificationComplete(authCredential),
            verificationFailed: (authException) =>
                _verificationFailed(authException),
            codeAutoRetrievalTimeout: null,
            // called when the SMS code is sent
            codeSent: (verificationId, [code]) =>
                _smsCodeSent(verificationId, [code]));
      }
    } else {
      setState(() {
        _logLoading = false;
        _logValidate = true;
      });
    }
  }

  _verificationComplete(authCredential) async {
    AuthResult result = await _auth.signInWithCredential(authCredential);
    FirebaseUser user = result.user;
    if (user != null) {
      Navigator.pushReplacement(context, PageTransition(Dashboard()));
    } else {
      _customErrorDialog.showErrorDialog(context, 'Error in Validating');
    }
  }

  _verificationFailed(authException) async {
    print("Exception $authException");
    print(authException.message);
    _customErrorDialog.showErrorDialog(
        context, 'An Exception occurred while validating');
  }

  _smsCodeSent(verificationId, code) async {
    print("sending Code");
    setState(() {
      _logLoading = false;
    });
    Navigator.push(
        context,
        PageTransition(
            CodeVerification(verificationId, code, 'login', userData)));
  }
}
