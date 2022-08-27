class Futterung{

  String datum;
  String zeit;
  int portion;
  int medikamente;
  String id;

  Futterung(this.datum, this.zeit, this.portion, this.medikamente, this.id);

  factory Futterung.fromJson(String key, Map<dynamic,dynamic> json){
    return Futterung(
        json["datum"] as String,
        json["zeit"] as String,
        json["portion"] as int,
        json["medikamente"] as int,
        key
    );
  }
}