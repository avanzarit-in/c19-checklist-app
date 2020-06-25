import 'package:c19checklist/Login.dart';
import 'package:c19checklist/utils/PageTransition.dart';
import 'package:flutter/material.dart';
import 'package:c19checklist/utils/FireStore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:c19checklist/Dashboard.dart';
import 'package:c19checklist/utils/Errordialog.dart';
import 'package:c19checklist/CodeVerification.dart';
import 'package:intl/intl.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  GlobalKey<FormState> _regKey = new GlobalKey<FormState>();
  GlobalKey<ScaffoldState> _regState = new GlobalKey<ScaffoldState>();
  final FireStore _fireStore = new FireStore();
  final CustomErrorDialog _customErrorDialog = new CustomErrorDialog();
  TextEditingController _mobileNumber = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _validate = false;
  bool _loading = false;
  String selectedOrganization;

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void initState() {
    _getOrgName();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _regState,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Register',
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: registerLayout(),
      ),
    );
  }

  Widget registerLayout() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Image.asset(
            'assets/images/reg.jpg',
            fit: BoxFit.cover,
          ),
          formUI()
        ],
      ),
    );
  }

  Widget formUI() {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: Form(
        key: _regKey,
        autovalidate: _validate,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            orgBlock(),
            phoneBlock(),
            registerButton(),
            orText(),
            goLogin()
          ],
        ),
      ),
    );
  }

  Widget orgBlock() {
    return (orgList == null)
        ? Container(
            child: Text('Loading...'),
          )
        : Container(
            padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
            child: DropdownButtonFormField(
              isDense: true,
              decoration: InputDecoration(
                errorStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.red),
              ),
              value: selectedOrganization,
              hint: Text(
                'Organization',
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Colors.grey[700]),
              ),
              onChanged: (type) {
                FocusScope.of(context).requestFocus(FocusNode());
                setState(() {
                  selectedOrganization = type;
                });
              },
              validator: (value) {
                if (value == null) {
                  return 'Select your organization';
                }
                return null;
              },
              items: orgList.map((uType) {
                return DropdownMenuItem(
                  value: uType['name'],
                  child: Text(uType['name']),
                );
              }).toList(),
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
            return 'Should have + and country code';
          }
          return null;
        },
        onSaved: (value) {
          _mobileNumber.text = value;
        },
      ),
    );
  }

  Widget registerButton() {
    return (_loading)
        ? Container(
            padding: EdgeInsets.all(10),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Container(
            padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
            child: RaisedButton(
              color: Colors.deepPurple,
              onPressed: () {
                _registerUser();
                FocusScope.of(context).requestFocus(FocusNode());
              },
              child: Text(
                'Register',
                style: TextStyle(color: Colors.white),
              ),
            ),
          );
  }

  Widget orText() {
    return Row(children: [
      Expanded(
        child: new Container(
            margin: const EdgeInsets.only(left: 10.0, right: 15.0),
            child: Divider(
              color: Colors.black,
              height: 50,
            )),
      ),
      Text("OR"),
      Expanded(
        child: new Container(
            margin: const EdgeInsets.only(left: 15.0, right: 10.0),
            child: Divider(
              color: Colors.black,
              height: 50,
            )),
      ),
    ]);
  }

  Widget goLogin() {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
      child: RaisedButton(
        color: Colors.deepOrange,
        onPressed: () {
          Navigator.push(context, PageTransition(Login()));
        },
        child: Text(
          'Login',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  ///Function Handlers
  ///
  ///get organization names
  ///[orgList] holds the data in a list
  List orgList;
  _getOrgName() async {
    orgList = List();
    var retDoc = await _fireStore.getDocumentFromCollectionWithParams(
        'a', 'organization');
    retDoc.documents.map((doc) {
      setState(() {
        orgList.add(doc.data);
      });
    }).toList();
    print(orgList);
  }

  ///Submit for registering
  ///
  ///[regData] to hold the data to be submitted
  Map<String, dynamic> _regData = {};
  _registerUser() async {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);
    _regData['organizationName'] = selectedOrganization;
    _regData['registrationDate'] = formattedDate.toString();
    _regData['phone'] = _mobileNumber.text.toString();
    if (_regKey.currentState.validate()) {
      _regKey.currentState.save();
      setState(() {
        _loading = true;
      });

      ///check if number already exist
      var docCheck = await _fireStore.getDataFromSingleClause(
          _mobileNumber.text.toString(), 'phone', 'registeredUser');
      if (docCheck.documents.length > 0) {
        _regState.currentState.showSnackBar(SnackBar(
          content: Text('Mobile number is already registered'),
          behavior: SnackBarBehavior.floating,
        ));
        setState(() {
          _loading = false;
        });
      } else {
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
        _loading = false;
        _validate = true;
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
    Navigator.push(
        context,
        PageTransition(
            CodeVerification(verificationId, code, 'reg', _regData)));
  }
}
