import 'dart:collection';
import 'dart:ffi';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:futterspender_v1/Futterung.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'GlobalValues.dart';

class DetaillierteFutterungsSeite extends StatefulWidget {

  Futterung futterung;
  DetaillierteFutterungsSeite({required this.futterung});

  @override
  _DetaillierteFutterungsSeiteState createState() => _DetaillierteFutterungsSeiteState();
}

class _DetaillierteFutterungsSeiteState extends State<DetaillierteFutterungsSeite> {

  var tf_datum = TextEditingController();
  var tf_zeit = TextEditingController();
  var tf_portion = TextEditingController();
  var tf_medikamente = TextEditingController();
  late int radioValue ;

  var root_user;
  //var oldID;

  Future<void> rootUser() async{
    var sp = await SharedPreferences.getInstance();
    String? root = sp.getString("qrCode1");
    root_user = root;
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  //var refFutterung = FirebaseDatabase.instance.ref().child("user1/futterung");
  var refFutterung = FirebaseDatabase.instance.ref();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    rootUser();
    var details = widget.futterung;
    tf_datum.text = details.datum;
    tf_zeit.text = details.zeit;
    tf_portion.text = details.portion.toString();
    radioValue = details.medikamente;
    //oldID = tf_datum.text + "-" + tf_zeit.text;
  }

  Future<void> updateFutterungszeit(String oldID) async{

    String refChild = tf_datum.text + "-" + tf_zeit.text;

    var futterung = HashMap<String, dynamic>();
    futterung["datum"] = widget.futterung.datum;
    futterung["zeit"] = widget.futterung.zeit;
    futterung["portion"] = int.parse(tf_portion.text);
    futterung["medikamente"] = radioValue;
    futterung["id"] = refChild;
/*
    refFutterung.child(root_user).child("futterung").child(oldID).remove();
    refFutterung.child(root_user).child("futterung").child(refChild).set(futterung);

 */
    print("root user: $root_user");
    refFutterung.child(root_user).child("futterung").child(oldID).update(futterung);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Detaillierte Futterung", style: TextStyle(color: Colors.lightBlue.shade900),),
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
                    //labelText: "Datum",
                    hintText: "geben Sie Datum an",
                    //labelStyle: TextStyle(color: Colors.deepOrange.shade300, fontSize: 30),
                    hintStyle: TextStyle(
                      color: Colors.blue.shade900,
                      fontSize: 16, ),
                    filled: true,
                    fillColor: Colors.blue.shade300,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    prefixIcon: Icon(Icons.date_range, size: 42,)
                  ),
                  onTap: (){
                    showDatePicker(context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2050),
                    ).then((valueDatum){
                      setState(() {
                        if(int.parse("${valueDatum!.month}") <10 ){
                          tf_datum.text = "${valueDatum.year}-0${valueDatum.month}-${valueDatum.day}";
                        }
                        else{
                          tf_datum.text = "${valueDatum.year}-${valueDatum.month}-${valueDatum.day}";
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
                    //labelText: "Zeit",
                    hintText: "geben Sie Zeit an",
                    //labelStyle: TextStyle(color: Colors.deepOrange.shade300, fontSize: 30),
                    hintStyle: TextStyle(
                      color: Colors.red,
                      fontSize: 16, ),
                    filled: true,
                    fillColor: Colors.blue.shade300,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    prefixIcon: Icon(Icons.more_time_outlined, size: 42,),
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
                      //labelText: "Portion",
                      hintText: "geben Sie Portionerung an",
                      //labelStyle: TextStyle(color: Colors.deepOrange.shade300, fontSize: 30),
                  hintStyle: TextStyle(
                    color: Colors.red,
                    fontSize: 16, ),
                  filled: true,
                  fillColor: Colors.blue.shade300,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                    prefixIcon: Icon(Icons.restaurant_menu, size: 42,),
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
                            Text("JA", style: TextStyle(fontSize: 20, color: Colors.white),),
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
                            Text("NEIN", style: TextStyle(fontSize: 20, color: Colors.white),),
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
          updateFutterungszeit(widget.futterung.id);
          GlobalValues.showSnackbar(_scaffoldKey, "Neue Daten werden aktualisiert", 5);
        },
        tooltip: 'Aktualisiere die Zeit',
        icon: Icon(Icons.update),
        label: Text("Aktualisieren"),
      ),
    );
  }
}
