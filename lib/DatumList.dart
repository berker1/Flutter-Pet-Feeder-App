import 'package:firebase_auth/firebase_auth.dart';

class DatumList{

  String id;
  String datum;

  DatumList(this.id, this.datum);

  factory DatumList.fromJson( key, Map<dynamic, dynamic> json){
    return DatumList(key, json["datum"] as String);
  }
}
