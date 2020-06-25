import 'package:flutter/material.dart';

class CustomErrorDialog {
  Future showErrorDialog(context, String errorText) async {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
              padding: EdgeInsets.all(20),
              child: AlertDialog(
                actions: [
                  FlatButton(
                    onPressed: () async {
                      Navigator.of(context).pop();
                    },
                    child: Text('OK'),
                  )
                ],
                content: Text(errorText),
              )),
        );
      },
    );
  }
}
