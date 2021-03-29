import 'package:visitas_tecnicas_mobile/models/visit.dart';

class Subscription{
  Visit visit;
  String status;

  Subscription({this.visit, this.status});

  factory Subscription.fromJson(Map<String, dynamic> json){
    return Subscription(
      visit: Visit.fromJson(json['visit']),
      status: json['status']
    );
  }

  Map<String, dynamic> toJson(){
    return{
      'visit': visit.toJson()
    };
  }
}