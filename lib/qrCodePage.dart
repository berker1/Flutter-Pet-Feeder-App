
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:futterspender_v1/sign_up_widget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/platform_interface.dart';

import 'GlobalValues.dart';
import 'UserPage.dart';
import 'navigatorBar.dart';
import 'google_sign_in.dart';

class qrCodePage extends StatefulWidget {

  @override
  _qrCodePageState createState() => _qrCodePageState();
}

class _qrCodePageState extends State<qrCodePage> {

  //String qrCode = "user1";
  String qrCode = "";
  final qrKey = GlobalKey(debugLabel: 'QR') ;
  bool fromHome = true;

  @override
  void initState() {
    // TODO: implement initState
    fromWhere();
    getQR();
    super.initState();
  }

  Future <void> fromWhere() async{
    var sp = await SharedPreferences.getInstance();
    bool? fromPage = sp.getBool("fromHome");
    fromHome = fromPage!;
    print("signdan true, userdan false $fromHome" );
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

   bool b1 = false;

  Future<String> getQR() async{
    final sp = await SharedPreferences.getInstance();
    final qrGet = sp.getString("qrCode1");
    print("get qr (qr page): ${qrGet}");
    final pageNo = sp.getBool("fromHome");
    //if(qrGet!.contains('user') && qrGet.contains('futterSpender2022') ){
    if(qrGet!.contains('user') ){
      b1 = true;
      if(pageNo == true){
        Navigator.push(context,MaterialPageRoute(builder: (context) => NavigatorBar()));
      }
    }else{
      b1 = false;
    }
    return qrGet;
  }

  Future<void> setQR(String inputQR) async{
    final sp = await SharedPreferences.getInstance();
    sp.setString("qrCode1", inputQR);
    print("set qr $inputQR");

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.lightBlue.shade100,
        //leading: fromHome == false ?
        leading: b1 == false ?
            IconButton(
          color: Colors.lightBlue.shade900,
          icon: Icon(Icons.arrow_back),
          tooltip: "QR Scannen",
          onPressed: (){
            fromWhere();
            Navigator.pop(context);
            },
        ): IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.lightBlue.shade900,
          onPressed: (){
            fromWhere();
            final provider = Provider.of<GoogleSignInProvider>(context, listen: false);
            provider.logout();
          },
          //child: Text("Logout", style: TextStyle(color: Colors.orange),)
        ),
        title: Text("Scan System's QR Code", style: TextStyle(color: Colors.blue.shade900),),
      ),
      body: Container( color: Colors.blueGrey.shade900,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Zum QR Scannen,                                            "
                  "Klicken Sie QR Code ", style: TextStyle(fontSize: 24,
                  color: Colors.white54, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
              SizedBox(height: 50,),
              GestureDetector(
                onTap: (){ scanQRCode();
                print("qr code b1 değeri = $b1");
                if(b1){
                  //Navigator.of(context).maybePop(MaterialPageRoute(builder: (builder) => UserPage_u()));
                  Navigator.push(context,MaterialPageRoute(builder: (context) => NavigatorBar()),
                  );
                  print("qr true but no navigation to page");
                }
                else{
                  GlobalValues.showSnackbar(_scaffoldKey, "QR Code ist nich gültig", 5);
                }
                },
                child: Icon(Icons.qr_code_scanner_rounded, color: Colors.white,
                size: 300,),
              ),
              SizedBox(height: 50,),
              //Text("data: $qrCode" , style: TextStyle(fontSize: 24, color: Colors.white),),
            ],
          ),
        ),
      ),
    );
  }


  Future <void> scanQRCode() async{
    print("wr code");
    try {
      final qrCode = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "Cancel",
          true, ScanMode.QR);

      if (!mounted) return;

      setState(() {
        this.qrCode = qrCode;
        setQR(qrCode);
        getQR();
      });
    } on PlatformException{
      qrCode = "Failed to get platform version ";
    }
  }

}

