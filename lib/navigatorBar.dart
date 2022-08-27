import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:futterspender_v1/FutterungsListSeite.dart';
import 'package:futterspender_v1/qrCodePage.dart';
import 'package:futterspender_v1/watchCameraPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'UserPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(NavigatorBar());
}

class NavigatorBar extends StatefulWidget {
  const NavigatorBar({Key? key}) : super(key: key);

  @override
  State<NavigatorBar> createState() => _NavigatorBarState();
}

class _NavigatorBarState extends State<NavigatorBar> {

    late String dateToday ;
    int index = 1;

    var new_root = "";

    Future<void> rootUser() async{
      var sp = await SharedPreferences.getInstance();
      String? root = sp.getString("qrCode1");
      new_root = root!;
      print("click rootUser find");
    }

    Future<void> todayDate() async{
      if(int.parse("${DateTime.now().month}") <10 ){
        dateToday = "${DateTime.now().year}-0${DateTime.now().month}-${DateTime.now().day}";
      }
      else{
        dateToday = "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}";
      }

      print(dateToday);
    }
    @override
  void initState() {
    // TODO: implement initState
      todayDate();
    super.initState();
  }


  late final screens = [
    FutterungsListSeite(dateToday: dateToday, userID: new_root,),
    UserPage_u(),
    WatchCameraPage(),
  ];

  @override
  Widget build(BuildContext context) {
    final items = <Widget>[
      Icon(Icons.access_time, size: 30,),
      Icon(Icons.home, size: 30,),
      Icon(Icons.camera_alt, size: 30,),
    ];


    return Scaffold(
      body: screens[index],
      bottomNavigationBar:  Theme(
        data: Theme.of(context).copyWith(
          iconTheme: IconThemeData(color: Colors.lightBlue.shade900),
        ),
        child: CurvedNavigationBar(items: items,
          color: Colors.lightBlue.shade100,
          buttonBackgroundColor: Colors.white,
          backgroundColor: Colors.blueGrey.shade900,
          height: 60,
          animationCurve: Curves.easeIn,
          animationDuration: Duration(milliseconds: 400),
          index: index,
          onTap: (index) {
            setState(() {
              this.index = index;
            });
          },
        ),
      )
    );
  }
}