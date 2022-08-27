import 'dart:collection';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:futterspender_v1/Futterung.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'GlobalValues.dart';

class SpeichernNeuFutterung extends StatefulWidget {

  @override
  _SpeichernNeuFutterungState createState() => _SpeichernNeuFutterungState();
}

class _SpeichernNeuFutterungState extends State<SpeichernNeuFutterung> {

  var tf_datum = TextEditingController();
  var tf_zeit = TextEditingController();
  var tf_portion = TextEditingController();
  var tf_medikamente = TextEditingController();
  int radioValue  = 0;

  var root_user;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  Future<void> rootUser() async{
    var sp = await SharedPreferences.getInstance();
    String? root = sp.getString("qrCode1");
    root_user = root;
  }
  //var refFutterung = FirebaseDatabase.instance.ref().child("user1/futterung");
  var refFutterung = FirebaseDatabase.instance.ref();

  //var refDatums = FirebaseDatabase.instance.ref().child("user1/datumList"); //mainden kopya
  var refDatums = FirebaseDatabase.instance.ref();

  //String ref_firebase = ""; //mainden kopya

  Future<void> toFireBase() async{ // mainden kopya

    String refChild = tf_datum.text + "-" + tf_zeit.text;

    var futterung = HashMap<String, dynamic>();
    futterung["datum"] = tf_datum.text;
    futterung["zeit"] = tf_zeit.text;
    futterung["portion"] = int.parse(tf_portion.text);
    futterung["medikamente"] = radioValue;
    futterung["id"] = refChild;

    //refFutterung.child(ref_firebase).child(refChild).set(futterung);
    refFutterung.child(root_user).child("futterung").child(refChild).set(futterung);

    var datums = HashMap<String, dynamic>();
    datums["datum"] = tf_datum.text;
    datums["id"] = "";
    //refDatums.child(tf_datum.text).set(datums);
    refDatums.child(root_user).child("datum_list").child(tf_datum.text).set(datums);
  }

  @override
  void initState() {
    // TODO: implement initState
    rootUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Neue Futterung", style: TextStyle(color: Colors.lightBlue.shade900),),
        centerTitle: true,
        leading: IconButton(
          color: Colors.lightBlue.shade900,
          icon: Icon(Icons.arrow_back),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.lightBlue.shade100,
      ),
      body: Container(color: Colors.blueGrey.shade900,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(right: 30.0, left: 30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextField(
                  controller: tf_datum,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 24),
                  decoration: InputDecoration(
                    labelText: "Datum",
                    hintText: "geben Sie bitte Datum an",
                    labelStyle: TextStyle(color: Colors.white, fontSize: 20),
                    hintStyle: TextStyle(
                      color: Colors.blue.shade900,
                      fontSize: 18, ),
                    filled: true,
                    fillColor: Colors.blue.shade300,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                      prefixIcon: Icon(Icons.date_range),
                  ),
                  onTap: (){
                    showDatePicker(context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2050),
                    ).then((valueDatum){
                      setState(() {
                        if(int.parse("${valueDatum!.month}") <10 ){
                          if(int.parse("${valueDatum.day}") <10 ){
                            tf_datum.text = "${valueDatum.year}-0${valueDatum.month}-0${valueDatum.day}";
                          }
                          else{
                            tf_datum.text = "${valueDatum.year}-0${valueDatum.month}-${valueDatum.day}";
                          }
                        }
                        else{
                          if(int.parse("${valueDatum.day}") <10 ){
                            tf_datum.text = "${valueDatum.year}-${valueDatum.month}-0${valueDatum.day}";
                          }
                          else{
                            tf_datum.text = "${valueDatum.year}-${valueDatum.month}-${valueDatum.day}";
                          }
                        }
                      });
                    });
                  },
                ),
                TextField(
                  controller: tf_zeit,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 24),
                  decoration: InputDecoration(
                    labelText: "Zeit",
                    hintText: "geben Sie Zeit an",
                    labelStyle: TextStyle(color: Colors.white, fontSize: 20),
                    hintStyle: TextStyle(
                      color: Colors.blue.shade900,
                      fontSize: 18, ),
                    filled: true,
                    fillColor: Colors.blue.shade300,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    prefixIcon: Icon(Icons.more_time_outlined),
                  ),
                  onTap: (){
                    showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.fromDateTime(DateTime.now()),
                    ).then((valueZeit){
                      setState(() {
                        if(int.parse("${valueZeit!.hour}") <10 ){
                          if(int.parse("${valueZeit.minute}") <10 ){
                            tf_zeit.text = "0${valueZeit.hour}:0${valueZeit.minute}";
                          }else{
                            tf_zeit.text = "0${valueZeit.hour}:${valueZeit.minute}";
                          }
                        }else{
                          if(int.parse("${valueZeit.minute}") <10 ){
                            tf_zeit.text = "${valueZeit.hour}:0${valueZeit.minute}";
                          }else{
                            tf_zeit.text = "${valueZeit.hour}:${valueZeit.minute}";
                          }
                        }


                        //tf_zeit.text = "Fütterungs Zeit: ${valueZeit.format(context)}";
                      });
                    });
                  },
                ),
                TextField(
                  controller: tf_portion,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 24),
                  decoration: InputDecoration(
                    labelText: "Portion",
                    hintText: "geben Sie Portionerung an",
                    labelStyle: TextStyle(color: Colors.white, fontSize: 20),
                    hintStyle: TextStyle(
                      color: Colors.blue.shade900,
                      fontSize: 18, ),
                    filled: true,
                    fillColor: Colors.blue.shade300,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    prefixIcon: Icon(Icons.restaurant_menu),
                  ),
                ),
                Column(
                  children: [
                    Text("Extra", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 22, color: Colors.white),),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [

                        Row(
                          children: [
                            Text("True", style: TextStyle(fontSize: 20, color: Colors.white),),
                            Theme( data: Theme.of(context).copyWith(
                              unselectedWidgetColor: Colors.white,
                            ),
                              child: Radio(
                                  value: 1,
                                  groupValue: radioValue,
                                  activeColor: Colors.lightGreen,
                                  onChanged: (value){
                                    setState(() {
                                      radioValue = 1;
                                    });
                                  }
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text("False", style: TextStyle(fontSize: 20, color: Colors.white),),
                            Theme( data: Theme.of(context).copyWith(
                              unselectedWidgetColor: Colors.white,
                            ),
                              child: Radio(
                                  value: 0,
                                  groupValue: radioValue,
                                  activeColor: Colors.red,
                                  onChanged: (value){
                                    setState(() {
                                      radioValue = 0;
                                    });
                                  }
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: (){
          if(tf_datum.text != "" && tf_zeit.text != ""){
            //Navigator.pop(context);
            if(tf_portion.text == ""){
              tf_portion.text = "1";
              toFireBase();
            }
            else{
              toFireBase();
            }
            GlobalValues.showSnackbar(_scaffoldKey, "Neue Daten werden gespeichert", 5);
          }else{
            GlobalValues.showSnackbar(_scaffoldKey, "Datum oder Zeit darf nicht leer sein", 5);
          }

        },
        tooltip: 'NEU',
        icon: Icon(Icons.save),
        label: Text("Speichern"),
      ),
    );
  }
}
