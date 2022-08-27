import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:futterspender_v1/DatumList.dart';
import 'package:futterspender_v1/DetaillierteFutterungsSeite.dart';
import 'package:futterspender_v1/Futterung.dart';
import 'package:futterspender_v1/speichernNeuFutterung.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'GlobalValues.dart';

class FutterungsListSeite extends StatefulWidget {

  String dateToday;
  String userID;
  FutterungsListSeite({required this.dateToday, required this.userID});


  @override
  _FutterungsListState createState() => _FutterungsListState();
}

class _FutterungsListState extends State<FutterungsListSeite> {

  var new_root = "";

  Future<void> rootUser() async{
    var sp = await SharedPreferences.getInstance();
    String? root = sp.getString("qrCode1");
    setState(() {
      new_root = root!;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    rootUser();
    dateShow = widget.dateToday;
    super.initState();
  }

  var refDatums = FirebaseDatabase.instance.ref();
  //var refDatums = FirebaseDatabase.instance.ref().child("user1/datumList");
  var refFutterung = FirebaseDatabase.instance.ref();
  //var refFutterung = FirebaseDatabase.instance.ref().child("user1/futterung");

  var dateNew;
  var dateShow;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  Future<void> datePick(String inputDate) async{
    dateNew = inputDate;
    if(dateNew != dateShow){
      dateShow = dateNew;
    }
    setState(() {
    });
  }

  Future <void> delete(String futterung_id, futterung_datum) async{
    refFutterung.child(new_root).child("futterung").child(futterung_id).remove();
  }

  int selectedCard = -1;


  Future<void> eliminationFunction(String datum, int count) async{

    for(int i = 0; i< count; i ++){
      var start = 1 + (i * 39);
      var end = 11 + (i * 39);
      var reverseDate = datum.substring(start, end);
      
      if(reverseDate[8] == '1' || reverseDate[8] == '2' ){
      }else{
        reverseDate = reverseDate.substring(0,8) + "0" + reverseDate[8];
      }
      var refDate = DateTime.parse(reverseDate);
      var dateParameter = DateTime.now();
      final difference = dateParameter.difference(refDate).inDays;

      if(difference > 10){
        //refDatums.child(new_root).child("datumList").child("2022-04-12").remove();
        print("dateToday: $dateParameter");
        print("deleting date: $refDate");
        print("date difference: $difference");
        refDatums.child(new_root).child("datum_list").child(reverseDate).remove();
        print("deleted");

      }

    }

  }

  Future<void> delete10Tage() async{
    print("10 tage delete func");
    refDatums.child(new_root).child("datum_list").get().then((values) {
      var fields = values.value;
      String deneme = fields.toString();
      print(deneme);

      var say = "id".allMatches(deneme).length;
      print("say: $say");

      eliminationFunction(deneme, say);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      extendBody: true,
      appBar: AppBar(
        leading: IconButton(
          color: Colors.lightBlue.shade900,
          icon: Icon(Icons.auto_delete),
          onPressed: (){
            deleteTage(context);
          },
        ),
        backgroundColor: Colors.lightBlue.shade100,
          title: Text("Alle Futterungszeiten", style: TextStyle(color: Colors.lightBlue.shade900,),),
        centerTitle: true,
      ),
      body:
      Container( color: Colors.blueGrey.shade900,
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8, left: 12, bottom: 8),
                child: Row(mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("Alle Datums:", style: TextStyle(color: Colors.white, fontSize: 20),),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                   height: MediaQuery.of(context).size.height * .30,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.blue.shade900,
                        border: Border.all(
                            color: Colors.black,
                            width: 3.0
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(12.0))
                    ),
                    child: StreamBuilder<DatabaseEvent>(
                      stream: refDatums.child(new_root).child("datum_list").orderByKey().onValue,
                      builder: (context, event){
                        if(event.hasData){
                          var datumList = <DatumList>[];
                          var gelenDegerler = event.data!.snapshot.value as dynamic;
                          if(gelenDegerler != null) {
                            gelenDegerler.forEach((key, nesne) {
                              var gelenDatum = DatumList.fromJson(key, nesne);
                              datumList.add(gelenDatum);
                              print("there is value for root: $new_root");
                            });
                          }
                          return GridView.builder(
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              childAspectRatio: 2 / 1,
                            ),
                            itemCount: datumList.length,
                            itemBuilder: (context, indeks){
                              var datum = datumList[indeks];
                              return GestureDetector(
                                onTap: (){
                                  //Navigator.push(context, MaterialPageRoute(builder: (context) => taegigeSeite(datumList: datum)));
                                  datePick(datum.datum);
                                  setState(() {
                                    selectedCard = indeks;
                                  });
                                },
                                child: Card(
                                  color: selectedCard == indeks ?  Colors.deepOrange.shade300: Colors.blue.shade50,
                                  shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                  child: SizedBox( height: 50,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(datum.datum),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        }else{
                          return Center();
                        }
                      },
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left:12, top: 8,bottom: 8),
                child: Row( mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("Details:", style: TextStyle(color: Colors.white, fontSize: 20),),
                  ],
                ),
              ),
              Row( mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(width: 60,),
                  Text("Zeit:", style: TextStyle(fontSize: 18, color: Colors.deepOrange.shade300),),
                  SizedBox(width: 40,),
                  Text("Portion:", style: TextStyle(fontSize: 18, color: Colors.deepOrange.shade300),),
                  SizedBox(width: 40,),
                  Text("Extra:", style: TextStyle(fontSize: 18, color: Colors.deepOrange.shade300),),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * .25,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.blue.shade900,
                        border: Border.all(
                            color: Colors.black,
                            width: 3.0
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(12.0))
                    ),
                    child: StreamBuilder<DatabaseEvent>(
                      //stream: refFutterung.orderByChild("datum").equalTo(widget.datumList.datum).onValue,
                      stream: refFutterung.child(new_root).child("futterung").orderByChild("datum").equalTo(dateShow).onValue,
                      builder: (context, event){

                        if(event.hasData){
                          var futterungList = <Futterung>[];
                          var gelenDegerler = event.data!.snapshot.value as dynamic;
                          if(gelenDegerler != null) {
                            gelenDegerler.forEach((key, nesne) {
                              var gelenDatum = Futterung.fromJson(key, nesne);
                              futterungList.add(gelenDatum);
                            });
                          }

                          return ListView.builder(
                            itemCount: futterungList.length,
                            itemBuilder: (context, indeks){
                              var futterung = futterungList[indeks];
                              return GestureDetector(
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => DetaillierteFutterungsSeite(futterung: futterung)));
                                  print("to detail page");
                                },
                                child: SingleChildScrollView(
                                  child: Card(color: Colors.blue.shade300, shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                    child: SizedBox( height: 50,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          SizedBox(width: 45,),
                                          Text(futterung.zeit, style: TextStyle(color: Colors.white),),
                                          SizedBox(width: 70,),
                                          Text(futterung.portion.toString(), style: TextStyle(color: Colors.white),),
                                          SizedBox(width: 80,),
                                          Text(futterung.medikamente.toString(), style: TextStyle(color: Colors.white),),
                                          SizedBox(width: 60,),
                                          GestureDetector( onTap: (){ delete(futterung.id, futterung.datum); },
                                              child: Icon(Icons.delete, color: Colors.red.shade900,)),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        }else{
                          return Center();
                        }
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (builder) => SpeichernNeuFutterung()));
        },
        tooltip: 'Füge neu Fütterung',
        icon: Icon(Icons.add),
        backgroundColor: Colors.blue.shade900,
        label: Text("NEU"),
      ),

    );
  }
  void deleteTage(context){
    showModalBottomSheet(context: context, builder: (BuildContext bc){
      return Container( height: MediaQuery.of(context).size.height * .25,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text("Lösche letzte 10 Tage", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
                  Spacer(),
                  IconButton(onPressed: (){
                    Navigator.of(context).pop();
                  },
                      icon: Icon(Icons.cancel, color: Colors.redAccent,size: 25,))
                ],
              ),
            ),
            Column(
              children: [
                SizedBox( width: 250,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.deepOrange,
                        shadowColor: Colors.black,
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          side: BorderSide(color: Colors.black),
                        ),
                      ),
                      onPressed: (){
                        Navigator.of(context).pop();
                        delete10Tage();
                        GlobalValues.showSnackbar(_scaffoldKey, "Letzte 10 Tage wurden gelöscht", 3);
                      }, child: Text("JA")),
                ),
                SizedBox(height: 3,),
                SizedBox( width: 250,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.deepOrange,
                        shadowColor: Colors.black,
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          side: BorderSide(color: Colors.black),
                        ),
                      ),
                      onPressed: (){
                        Navigator.of(context).pop();
                      }, child: Text("NEIN")),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}
