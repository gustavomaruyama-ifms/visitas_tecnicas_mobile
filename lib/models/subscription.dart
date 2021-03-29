import 'package:visitas_tecnicas_mobile/models/visit.dart';

class Subscription{
  String id;
  Visit visit;
  String status;

  Subscription({this.id, this.visit, this.status});

  factory Subscription.fromJson(Map<String, dynamic> json){
    return Subscription(
      id: json['_id'],
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