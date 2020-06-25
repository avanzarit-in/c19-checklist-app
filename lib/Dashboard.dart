import 'package:c19checklist/utils/PageTransition.dart';
import 'package:c19checklist/utils/Preferences.dart';
import 'package:flutter/material.dart';
import 'package:c19checklist/Login.dart';
import 'package:intl/intl.dart';
import 'package:c19checklist/utils/FireStore.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  GlobalKey<FormState> _qForm = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> _qState = GlobalKey<ScaffoldState>();
  Preferences _preferences = new Preferences();
  FireStore _fireStore = new FireStore();
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

  bool _loading = false;

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

  Map<String, bool> qOne = {
    'Diabetes': false,
    'Hypertension': false,
    'Lung disease': false,
    'Heart Disease': false,
    'Kidney Disorder': false,
    'Severe chest pain': false,
    'Lost consciousness': false,
    'Fever of 100 F (37.8 C) or above, or possible fever symptoms like alternating chills and sweating':
        false,
    'Cough': false,
    'Trouble breathing, shortness of breath or severe wheezing': false,
    'Chills or repeated shaking with chills': false,
    'Muscle aches': false,
    'Sore throat': false,
    'Loss of smell or taste, or a change in taste': false,
    'Nausea, vomiting or diarrhea': false,
    'Headache': false
  };

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _qState,
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        // elevation: 0,
        title: Text(
          'Dashboard',
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
    return Container(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _qForm,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
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
              submitButton()
            ],
          ),
        ));
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
            style: TextStyle(fontSize: 12),
          ),
          value: qOne[key],
          activeColor: Colors.deepPurple,
          checkColor: Colors.white,
          dense: true,
          onChanged: (value) {
            setState(() {
              qOne[key] = value;
            });
          },
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
                  onChanged: radioButtonChanges,
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
                  onChanged: radioButtonChanges,
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
                  onChanged: radioButtonChangesThree,
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
                  onChanged: radioButtonChangesThree,
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
                  onChanged: radioButtonChangesFour,
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
                  onChanged: radioButtonChangesFour,
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
                  onChanged: radioButtonChangesFour,
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
                  onChanged: radioButtonChangesFive,
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
                  onChanged: radioButtonChangesFive,
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
                  onChanged: radioButtonChangesSix,
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
                  onChanged: radioButtonChangesSix,
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

  Widget submitButton() {
    return (_loading)
        ? Center(
            child: Padding(
            padding: EdgeInsets.all(10),
            child: CircularProgressIndicator(),
          ))
        : Container(
            padding: EdgeInsets.all(10),
            child: RaisedButton(
              color: Colors.deepOrange,
              onPressed: () {
                _submitForm();
              },
              child: Text(
                'Submit',
                style: TextStyle(color: Colors.white),
              ),
            ),
          );
  }

  _submitForm() async {
    Map storedValue = await _preferences.getPrefs();
    setState(() {
      _loading = true;
    });
    Map<String, dynamic> formData = {};
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);
    formData['questionOne'] = qOne;
    formData['questionTwo'] = choice;
    formData['questionThree'] = choiceThree;
    formData['questionFour'] = choiceFour;
    formData['questionFive'] = choiceFive;
    formData['questionSix'] = choiceSix;
    formData['submittedDate'] = formattedDate.toString();
    formData['submittedBy'] = storedValue['number'];
    try {
      var formDoc = await _fireStore.addData(formData, 'dailyStatus');
      if (formDoc.documentID != '') {
        setState(() {
          _loading = false;
        });
        _qState.currentState.showSnackBar(SnackBar(
          content: Text('Submitted Successfully'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ));
      } else {
        setState(() {
          _loading = false;
        });
        _qState.currentState.showSnackBar(SnackBar(
          content: Text('An Error occurred'),
          behavior: SnackBarBehavior.floating,
        ));
      }
    } catch (e) {
      print(e);
      setState(() {
        _loading = false;
      });
      _qState.currentState.showSnackBar(SnackBar(
        content: Text('An Error occurred'),
        behavior: SnackBarBehavior.floating,
      ));
    }
  }

  /// Function Handlers
  _logOutUser() async {
    _preferences.removePrefs();
    await Navigator.pushReplacement(context, PageTransition(Login()));
  }
}
