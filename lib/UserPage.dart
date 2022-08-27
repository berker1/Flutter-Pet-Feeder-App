import 'dart:io';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:futterspender_v1/navigatorBar.dart';
import 'package:futterspender_v1/qrCodePage.dart';
import 'package:futterspender_v1/sign_up_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'DetaillierteFutterungsSeite.dart';
import 'Futterung.dart';
import 'FutterungsListSeite.dart';
import 'google_sign_in.dart';

class UserPage_u extends StatefulWidget {
  const UserPage_u({Key? key}) : super(key: key);

  @override
  _UserPage_uState createState() => _UserPage_uState();
}

class _UserPage_uState extends State<UserPage_u> {

  @override
  void initState() {
    // TODO: implement initState
    todayDate();
    getQR();
    setFromWhere();
    rootUser();
    var a = shared();
    if(a != null){
      getSaveImage();
      print("a not empty");
    }
    super.initState();
  }

  Future<void> getQR() async{
    var sp = await SharedPreferences.getInstance();
    String? qrGet = sp.getString("qrCode1");
    print("get qr from user page: ${qrGet}");
  }

  Future<void> setFromWhere() async{
    var sp = await SharedPreferences.getInstance();
    sp.setBool("fromHome", false);
    print("set From Home = false");
  }

    Future <String?> shared() async{
    var sp = await SharedPreferences.getInstance();
    var image = sp.getString("imageSave");
    return image;
  }

  final user = FirebaseAuth.instance.currentUser!;

  Future<void> rootUser() async{
    var sp = await SharedPreferences.getInstance();
    String? root = sp.getString("qrCode1");
    print("new root: $root");
    new_root = root!;
  }

  var refDatums = FirebaseDatabase.instance.ref().child("user1/datumList");
  //var refFutterung = FirebaseDatabase.instance.ref().child("user1/futterung");
  var refFutterung = FirebaseDatabase.instance.ref();

  var dateNew;
  var dateShow;
  var dateToday = "";

  File? image;

  var new_root = "";

  Future getSaveImage() async{
    final directory = await getApplicationDocumentsDirectory();
    var sp = await SharedPreferences.getInstance();
    var image = sp.getString("imageSave");
    final name = basename(image!);
    setState(() {
      this.image = File("${directory.path}/$name");
    });

    print("control iamge");
      }
      Future <void> deneme(String imagePath) async{
        final directory = await getApplicationDocumentsDirectory();
        final name = basename(imagePath);
        final image = File("${directory.path}/$name");
        print("komple: ${File(imagePath).copy(image.path)}");
        print("imagePath: ${imagePath}");
        print("path: ${image.path}");

      }

  Future pickImage() async{
    try{
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if(image == null) return;
      final imageTemporary = File(image.path);
      //final imagePermenant = await saveImagePermanently(image.path);
      deneme(image.path);
      var sp = await SharedPreferences.getInstance();
      sp.setString("imageSave", image.path);
      setState(() {
        this.image = imageTemporary;
        //this.image = imagePermenant;
      });
      //print(imagePermenant);
    } on PlatformException catch (e){
      print("failed to pick image $e");
    }
  }

  Future <File> saveImagePermanently (String imagePath) async{
/*
    final directory = await getApplicationDocumentsDirectory();
    final name = basename(imagePath);
    final image = File("${directory.path}/$name");

 */
    return File(imagePath);//File(imagePath).copy(image.path);
  }

  Future<void> existenceCheck() async{

/*
      db.once().then((function(snapshot)){
        var a = snapshot.exists();
    }

 */
  }


  Future pickCamera() async{

    try{
      final image = await ImagePicker().pickImage(source: ImageSource.camera);
      if(image == null) return;
      final imageTemporary = File(image.path);
      //final imagePermenant = await saveImagePermanently(image.path);
      deneme(image.path);
      var sp = await SharedPreferences.getInstance();
      sp.setString("imageSave", image.path);
      setState(() {
        this.image = imageTemporary;
        //this.image = imagePermenant;
      });
      //print(imagePermenant);
    } on PlatformException catch (e){
      print("failed to pick image $e");
    }
  }


  Future<void> todayDate() async{
    if(int.parse("${DateTime.now().month}") <10 ){
      dateToday = "${DateTime.now().year}-0${DateTime.now().month}-${DateTime.now().day}";
    }
    else{
      dateToday = "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
        appBar: AppBar(
          backgroundColor: Colors.lightBlue.shade100,
          leading: IconButton(
            color: Colors.lightBlue.shade900,
              icon: Icon(Icons.qr_code),
            tooltip: "QR Scannen",
            onPressed: (){
              setFromWhere();
              Navigator.push(context, MaterialPageRoute(builder: (builder) => qrCodePage()),);
              },
          ),
          title: Text('FutterSpender', style: TextStyle(color:Colors.lightBlue.shade900 ),),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(Icons.exit_to_app),
                color: Colors.lightBlue.shade900,
                onPressed: (){
              final provider = Provider.of<GoogleSignInProvider>(context, listen: false);
              provider.logout();
            },
                //child: Text("Logout", style: TextStyle(color: Colors.orange),)
            )
          ],

        ),
        body: Container(
          alignment: Alignment.center,
          color: Colors.blueGrey.shade900,
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 24, bottom: 24),
                child: Container( color: Colors.transparent, width: MediaQuery.of(context).size.height,
                  child: Column( crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text("Welcome Back! ", style: TextStyle(color: Colors.white, fontSize: 24),),
                      ),
                      /*
                      Padding(
                        padding: const EdgeInsets.only( top: 8, bottom: 12),
                        child: Text(user.displayName!, style: TextStyle(color: Colors.white, fontSize: 24),),
                      ),
                      */
                    ],
                  ),
                ),
              ),

              Stack(
                children: [
                  GestureDetector( onTap: (){
                    existenceCheck();
                    editProfileImage(context);
                  },
                    child: image != null ? //Image.file(image!, width: 200, height: 200,) : FlutterLogo(size: 160,),
                    ClipOval(
                      child: Image.file(image!, width: 230, height: 230,fit:  BoxFit.cover,),
                    ): FlutterLogo(size: 180,),
                  ),
                  Positioned( bottom: 0, right: 4,
                      child: GestureDetector( onTap: (){
                        editProfileImage(context);
                      },
                        child: ClipOval(
                          child: Container( color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: ClipOval(
                                child: Container( color: Colors.blue,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(Icons.edit, size: 30,color: Colors.white,),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ))
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16,bottom: 8, top: 46),
                child: Container( color: Colors.transparent, width: MediaQuery.of(context).size.height,
                  child: Text("Heutige Fütterungen:", style: TextStyle(fontSize: 18, color: Colors.white),),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Column(
                  children: [
                    Row( mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text("Zeit:", style: TextStyle(fontSize: 18, color: Colors.deepOrange.shade300),),
                        Text("Portion:", style: TextStyle(fontSize: 18, color: Colors.deepOrange.shade300),),
                        Text("Extra:", style: TextStyle(fontSize: 18, color: Colors.deepOrange.shade300),),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8, right: 8,bottom: 8, top: 8),
                      child: Container(
                        //color: Colors.blueGrey.shade900, height: 150, width: 400,
                        color: Colors.transparent, height: 150, width: 400,
                        child: StreamBuilder<DatabaseEvent>(
                          stream: refFutterung.child(new_root).child("futterung").orderByChild("datum").equalTo(dateToday).onValue,
                          builder: (context, event){
                            if(event.hasData){
                              print("date today: $dateToday");
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
                                      child: Card( color: Colors.blueGrey, shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                        child: SizedBox( height: 40,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              children: [
                                                SizedBox(width: 45,),
                                                Text(futterung.zeit, style: TextStyle(color: Colors.white),),
                                                SizedBox(width: 90,),
                                                Text(futterung.portion.toString(), style: TextStyle(color: Colors.white),),
                                                SizedBox(width: 105,),
                                                Text(futterung.medikamente.toString(), style: TextStyle(color: Colors.white),),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                 );
                                },
                              );
                            }else{
                              print("no data");
                              return Container(
                                  color: Colors.blueGrey.shade900, height: 150, width: 200,
                                  child: Text("Loading", style: TextStyle(color: Colors.white, fontSize: 24),));
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            ],
          ),
        ),
    );
  }





  Future <bool> hasDataOnDate() async{
   refFutterung.orderByChild("datum").equalTo("2022-0-29").onValue.isEmpty;
   return true;

  }


  void editProfileImage(context){
    showModalBottomSheet(context: context, builder: (BuildContext bc){
      return Container( height: MediaQuery.of(context).size.height * .25,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text("Change Profile Photo", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
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
                    pickImage();
                  }, child: Text("Select a image ")),
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
                    pickCamera();
                  }, child: Text("Take a new Photo")),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}
