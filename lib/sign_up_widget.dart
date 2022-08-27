

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:futterspender_v1/google_sign_in.dart';
import 'package:provider/provider.dart';

class SignUpWidget extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        backgroundColor: Colors.lightBlue.shade100,
        title: Text("Sign-up", style: TextStyle(color: Colors.lightBlue.shade900, fontSize: 24),),
        centerTitle: true,
      ),
      body: Container(
          color: Colors.blueGrey.shade900,
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 32,),
              Text("Hallo! Wilkommen!", style: TextStyle(fontSize: 30,
                  color: Colors.white54, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
              SizedBox(height: 35,),
              Row( mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FaIcon(FontAwesomeIcons.cat, color: Colors.white, size: 100,),
                  SizedBox(width: 8,),
                  FaIcon(FontAwesomeIcons.dog, color: Colors.white, size: 100,),
                ],
              ),

              Padding(
                padding: const EdgeInsets.only(top: 60, bottom: 4, right: 8, left: 8),
                child: Text("Zum Login Wenden Sie Ihre Google Konto", style: TextStyle(fontSize: 30,
                    color: Colors.white54, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
              ),
              SizedBox(height: 60,),
              Container(
                child: Column(
                children: [
                  FaIcon(FontAwesomeIcons.google,size: 100, color: Colors.red,),
                  SizedBox(height: 20,),
                  SizedBox( width: 200, height: 60,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.lightBlue.shade900,
                          shadowColor: Colors.lightBlue.shade300,
                          elevation: 10,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            side: BorderSide(color: Colors.black),
                          ),
                        ),
                        onPressed: (){
                          final provider = Provider.of<GoogleSignInProvider>(context, listen: false);
                          provider.googleLogin();
                          print("sign up");
                        },
                        child: Text("Sign-up / Log-in", style: TextStyle(fontSize: 20),)
                    ),
                  ),
                ],
              )
              ),

            ],
          ),
        ),
      ),
    );
  }

}