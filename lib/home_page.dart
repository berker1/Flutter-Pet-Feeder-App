

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:futterspender_v1/FutterungsListSeite.dart';
import 'package:futterspender_v1/GlobalValues.dart';
import 'package:futterspender_v1/UserPage.dart';
import 'package:futterspender_v1/qrCodePage.dart';
import 'package:futterspender_v1/sign_up_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'navigatorBar.dart';

class HomePageAuth extends StatefulWidget {
  const HomePageAuth({Key? key}) : super(key: key);

  @override
  _HomePageAuth createState() => _HomePageAuth();
  }

class _HomePageAuth extends State<HomePageAuth> {

  bool b1 = false;

  Future<void> getQR() async{
    final sp = await SharedPreferences.getInstance();
    final qrGet = sp.getString("qrCode1");
    print("get qr from home page : ${qrGet}");
    //if(qrGet!.contains('user') && qrGet.contains('futterSpender2022') ){
    if(qrGet!.contains('user') ){
      b1 = true;
      print("user correct b1 = true");
    }else{
      b1 = false;
      print("user not correct b1 = false");
    }
  }


  Future<void> setFromWhere() async{
    var sp = await SharedPreferences.getInstance();
    sp.setBool("fromHome", true);
    print("set From Home = true, b1 = $b1");
  }

  @override
  void initState() {
    // TODO: implement initState
    getQR();
    super.initState();
  }

  @override
  Widget build(BuildContext context) =>
      Scaffold(
          body: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              else if (snapshot.hasData) {
                //return NavigatorBar();

                getQR();
                if(b1){
                  print("to navigatorBar.dart");
                  return NavigatorBar();
                }else{
                  setFromWhere();
                  print("to QR page");
                  return qrCodePage();
                }


              }
              else if (snapshot.hasError) {
                return Center(child: Text("Something went wrong"));
              }
              else {
                return SignUpWidget();
              }
            },
          )
      );
}