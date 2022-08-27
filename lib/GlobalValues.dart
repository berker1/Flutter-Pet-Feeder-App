
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GlobalValues{

  static showSnackbar(_scaffoldKey, String msg, int seconds) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
        duration: Duration(seconds: seconds),
        content: new Text(msg),
        backgroundColor: Colors.grey[800]));
  }

}