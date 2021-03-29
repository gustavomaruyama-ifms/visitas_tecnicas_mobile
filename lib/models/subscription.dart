import 'package:visitas_tecnicas_mobile/models/visit.dart';

class Subscription{
  Visit visit;
  String status;

  Subscription({this.visit, this.status});

  factory Subscription.fromJson(Map<String, dynamic> json){
    return Subscription(
      visit: json['visit'] is Map ? Visit.fromJson(json['visit']): Visit(id: json['visit']),
      status: json['status']
    );
  }

  Map<String, dynamic> toJson(){
    return{
      'visit': visit.toJson()
    };
  }
}