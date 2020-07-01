import 'package:flutter/material.dart';
import 'package:c19checklist/utils/Preferences.dart';
import 'package:c19checklist/utils/PageTransition.dart';
import 'package:c19checklist/Login.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:c19checklist/utils/FireStore.dart';

class Details extends StatefulWidget {
  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  Preferences _preferences = new Preferences();
  FireStore _fireStore = new FireStore();
  String formattedDate;
  bool _loading = false;
  String _radioValue; //Initial definition of radio button value
  String choice;

  String _radioValueThree;
  String choiceThree;

  String _radioValueFour;
  String choiceFour;

  String _radioValueFive;
  String choiceFive;

  String _radioValueSix;
  String choiceSix;

  Map detailData;
  Map<String, dynamic> qOne = {};
  _getDetails() async {
    Map storedValue = await _preferences.getPrefs();
    setState(() {
      _loading = true;
    });
    DateTime now = DateTime.now();
    formattedDate = DateFormat('yyyy-MM-dd').format(now);
    var checkDoc = await _fireStore.getDataFromDualClause(
        {'date': formattedDate.toString(), 'userNumber': storedValue['number']},
        'submittedDate',
        'submittedBy',
        'dailyStatus');
    if (checkDoc.documents.length > 0) {
      checkDoc.documents.map((doc) {
        setState(() {
          detailData = doc.data;
          qOne = detailData['questionOne'];
          radioButtonChanges(detailData['questionTwo']);
          radioButtonChangesThree(detailData['questionThree']);
          radioButtonChangesFour(detailData['questionFour']);
          radioButtonChangesFive(detailData['questionFive']);
          radioButtonChangesSix(detailData['questionSix']);
          _loading = false;
        });
      }).toList();
      print(detailData);
    }
  }

  void radioButtonChanges(String value) {
    setState(() {
      _radioValue = value;
      switch (value) {
        case 'Yes':
          choice = value;
          break;
        case 'No':
          choice = value;
          break;
        default:
          choice = null;
      }
    });
  }

  void radioButtonChangesThree(String value) {
    setState(() {
      _radioValueThree = value;
      switch (value) {
        case 'Yes':
          choiceThree = value;
          break;
        case 'No':
          choiceThree = value;
          break;
        default:
          choiceThree = null;
      }
    });
  }

  void radioButtonChangesFour(String value) {
    setState(() {
      _radioValueFour = value;
      switch (value) {
        case 'Home':
          choiceFour = value;
          break;
        case 'Office':
          choiceFour = value;
          break;
        case 'Field':
          choiceFour = value;
          break;
        default:
          choiceFour = null;
      }
    });
  }

  void radioButtonChangesFive(String value) {
    setState(() {
      _radioValueFive = value;
      switch (value) {
        case 'Yes':
          choiceFive = value;
          break;
        case 'No':
          choiceFive = value;
          break;
        default:
          choiceFive = null;
      }
    });
  }

  void radioButtonChangesSix(String value) {
    setState(() {
      _radioValueSix = value;
      switch (value) {
        case 'Yes':
          choiceSix = value;
          break;
        case 'No':
          choiceSix = value;
          break;
        default:
          choiceSix = null;
      }
    });
  }

  @override
  void initState() {
    _getDetails();
    super.initState();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        // elevation: 0,
        title: Text(
          'Details',
          style: TextStyle(color: Colors.white),
        ),
        automaticallyImplyLeading: false,
        actions: [
          FlatButton(
            onPressed: () {
              _logOutUser();
            },
            child: Icon(
              Icons.power_settings_new,
              color: Colors.white,
            ),
          )
        ],
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: dashboardLayout(),
      ),
    );
  }

  Widget dashboardLayout() {
    return (_loading)
        ? Container(
            padding: EdgeInsets.all(20),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Container(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                questionOne(),
                questionOneOptions(),
                questionTwo(),
                questionTwoOptions(),
                questionThree(),
                questionThreeOptions(),
                questionFour(),
                questionFourOptions(),
                questionFive(),
                questionFiveOptions(),
                questionSix(),
                questionSixOptions(),
              ],
            ),
          );
  }

  Widget questionOne() {
    return Container(
      padding: EdgeInsets.all(10),
      child: Text(
        'Have you ever had any of the following ?',
        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
      ),
    );
  }

  Widget questionOneOptions() {
    return ListView(
      shrinkWrap: true,
      physics: ScrollPhysics(),
      children: qOne.keys.map((key) {
        return CheckboxListTile(
          controlAffinity: ListTileControlAffinity.leading,
          title: Text(
            key,
            style: TextStyle(fontSize: 12, color: Colors.black),
          ),
          value: qOne[key],
          activeColor: Colors.deepPurple,
          checkColor: Colors.white,
          dense: true,
          onChanged: null,
        );
      }).toList(),
    );
  }

  Widget questionTwo() {
    return Container(
      padding: EdgeInsets.all(10),
      child: Text(
        'In the last 14 days, have you been in close physical contact with someone who tested positive for COVID-19?',
        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
      ),
    );
  }

  Widget questionTwoOptions() {
    return Container(
      padding: EdgeInsets.all(10),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                Radio(
                  value: 'Yes',
                  groupValue: _radioValue,
                  onChanged: null,
                ),
                Text(
                  "Yes",
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Radio(
                  value: 'No',
                  groupValue: _radioValue,
                  onChanged: null,
                ),
                Text(
                  "No",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget questionThree() {
    return Container(
      padding: EdgeInsets.all(10),
      child: Text(
        'Do you have any travel history in the last 14 days ?',
        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
      ),
    );
  }

  Widget questionThreeOptions() {
    return Container(
      padding: EdgeInsets.all(10),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                Radio(
                  value: 'Yes',
                  groupValue: _radioValueThree,
                  onChanged: null,
                ),
                Text(
                  "Yes",
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Radio(
                  value: 'No',
                  groupValue: _radioValueThree,
                  onChanged: null,
                ),
                Text(
                  "No",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget questionFour() {
    return Container(
      padding: EdgeInsets.all(10),
      child: Text(
        'I shall be working from',
        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
      ),
    );
  }

  Widget questionFourOptions() {
    return Container(
      padding: EdgeInsets.all(10),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                Radio(
                  value: 'Home',
                  groupValue: _radioValueFour,
                  onChanged: null,
                ),
                Text(
                  "Home",
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Radio(
                  value: 'Office',
                  groupValue: _radioValueFour,
                  onChanged: null,
                ),
                Text(
                  "Office",
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Radio(
                  value: 'Field',
                  groupValue: _radioValueFour,
                  onChanged: null,
                ),
                Text(
                  "Field",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget questionFive() {
    return Container(
      padding: EdgeInsets.all(10),
      child: Text(
        'I shall not be travelling in public transport',
        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
      ),
    );
  }

  Widget questionFiveOptions() {
    return Container(
      padding: EdgeInsets.all(10),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                Radio(
                  value: 'Yes',
                  groupValue: _radioValueFive,
                  onChanged: null,
                ),
                Text(
                  "Yes",
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Radio(
                  value: 'No',
                  groupValue: _radioValueFive,
                  onChanged: null,
                ),
                Text(
                  "No",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget questionSix() {
    return Container(
      padding: EdgeInsets.all(10),
      child: Text(
        'I have Arogya Setu installed in my smart phone',
        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
      ),
    );
  }

  Widget questionSixOptions() {
    return Container(
      padding: EdgeInsets.all(10),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                Radio(
                  value: 'Yes',
                  groupValue: _radioValueSix,
                  onChanged: null,
                ),
                Text(
                  "Yes",
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Radio(
                  value: 'No',
                  groupValue: _radioValueSix,
                  onChanged: null,
                ),
                Text(
                  "No",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Function Handlers
  _logOutUser() async {
    _preferences.removePrefs();
    await Navigator.pushReplacement(context, PageTransition(Login()));
  }
}
