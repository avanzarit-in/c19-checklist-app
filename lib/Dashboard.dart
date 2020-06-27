import 'package:c19checklist/SubmitSuccess.dart';
import 'package:c19checklist/utils/PageTransition.dart';
import 'package:c19checklist/utils/Preferences.dart';
import 'package:flutter/material.dart';
import 'package:c19checklist/Login.dart';
import 'package:flutter/services.dart';
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
  String formattedDate;
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

  bool showForm = false;

  _checkTodayData() async {
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
    if (checkDoc.documents.length == 0) {
      setState(() {
        showForm = true;
        _loading = false;
      });
    } else {
      setState(() {
        showForm = false;
        _loading = false;
      });
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void initState() {
    _checkTodayData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return _moveOffScreen();
      },
      child: Scaffold(
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
      ),
    );
  }

  _moveOffScreen() {
    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
  }

  Widget dashboardLayout() {
    return (_loading)
        ? Container(
            padding: EdgeInsets.all(20),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : (showForm)
            ? Container(
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
                ))
            : Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/done.png',
                      fit: BoxFit.cover,
                      filterQuality: FilterQuality.high,
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                      child: Text(
                        'You have already submitted the details for today',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 20),
                      ),
                    )
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
                _submitForm(context);
              },
              child: Text(
                'Submit',
                style: TextStyle(color: Colors.white),
              ),
            ),
          );
  }

  _submitForm(context) async {
    Map storedValue = await _preferences.getPrefs();
    Map<String, dynamic> formData = {};
    formData['questionOne'] = qOne;
    formData['questionTwo'] = choice;
    formData['questionThree'] = choiceThree;
    formData['questionFour'] = choiceFour;
    formData['questionFive'] = choiceFive;
    formData['questionSix'] = choiceSix;
    formData['submittedDate'] = formattedDate.toString();
    formData['submittedBy'] = storedValue['number'];
    if (choiceThree == null ||
        choice == null ||
        choiceFour == null ||
        choiceFive == null ||
        choiceSix == null) {
      _qState.currentState.showSnackBar(SnackBar(
        content: Text('Select Radio button Options for all'),
        behavior: SnackBarBehavior.floating,
      ));
    } else
      _showAlertButton(context, formData);
  }

  _showAlertButton(context, submitableData) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("No"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Yes"),
      onPressed: () async {
        Navigator.pop(context);
        await _submitTheData(submitableData);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Confirm"),
      content: Text("Are you sure to submit ?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  _submitTheData(data) async {
    setState(() {
      _loading = true;
    });
    try {
      var formDoc = await _fireStore.addData(data, 'dailyStatus');
      if (formDoc.documentID != '') {
        setState(() {
          _loading = false;
        });
        await Navigator.push(context, PageTransition(SubmitSuccess()));
        setState(() {
          _checkTodayData();
        });
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
