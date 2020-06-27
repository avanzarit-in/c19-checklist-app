import 'package:flutter/material.dart';

class SubmitSuccess extends StatefulWidget {
  @override
  _SubmitSuccessState createState() => _SubmitSuccessState();
}

class _SubmitSuccessState extends State<SubmitSuccess> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Success',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepOrange,
      ),
      body: SingleChildScrollView(
        child: successLayout(),
      ),
    );
  }

  Widget successLayout() {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          Center(
            child: Icon(
              Icons.done,
              size: 40,
              color: Colors.green,
            ),
          ),
          Center(
            child: Text('Your details for today was registered successfully'),
          )
        ],
      ),
    );
  }
}
