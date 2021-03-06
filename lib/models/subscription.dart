import 'package:visitas_tecnicas_mobile/models/user.dart';
import 'package:visitas_tecnicas_mobile/models/visit.dart';

class Subscription{
  String id;
  Visit visit;
  String status;
  User user;
  int assessment;
  bool presence;
  bool updatingSubscription = false;

  Subscription({this.id, this.visit, this.status, this.user,this.presence, this.assessment});

  factory Subscription.fromJson(Map<String, dynamic> json){
    return Subscription(
      id: json['_id'],
      visit: json['visit'] is Map ? Visit.fromJson(json['visit']): Visit(id: json['visit']),
      user: json['user'] is Map? User.fromJson(json['user']): User(id: json['user']),
      status: json['status'],
      presence: json['presence'],
      assessment: json['assessment']
    );
  }

  Map<String, dynamic> toJson(){
    return{
      '_id': id,
      'status': status,
      'visit': visit ==null? null:visit,
      'assessment': assessment
    };
  }
}