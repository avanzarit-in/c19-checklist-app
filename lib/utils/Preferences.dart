import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  static Preferences _instance = Preferences.internal();
  Preferences.internal();
  factory Preferences() => _instance;

  ///set preferences
  Future<bool> setPrefs(data) async {
    print(data['deviceId'].toString());
    // print(data['documentId'].toString());
    print(data['phone'].toString());
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('c19checklist_deviceid', data['deviceId'].toString());
    // prefs.setString('c19checklist_documentId', data['documentId'].toString());
    prefs.setString('c19checklist_number', data['phone'].toString());
    return true;
  }

  ///get Preferences
  Map getterMap = {};
  Future<Map> getPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    getterMap['device_id'] = prefs.getString('c19checklist_deviceid');
    // getterMap['documentId'] = prefs.getString('c19checklist_documentId');
    getterMap['number'] = prefs.getString('c19checklist_number');
    return getterMap;
  }

  ///Remove
  Future<bool> removePrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('c19checklist_deviceid');
    prefs.remove('c19checklist_documentId');
    prefs.remove('c19checklist_number');
    return true;
  }

  ///Store additional preferences
  Future<bool> setIndPrefs(data, value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool retValue;
    if (value == 'entry') {
      prefs.setString('entryStatus', data['entryStatus']);
      retValue = true;
    }
    return retValue;
  }
}
