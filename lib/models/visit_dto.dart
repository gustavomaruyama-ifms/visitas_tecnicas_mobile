import 'package:visitas_tecnicas_mobile/models/visit.dart';

class VisitDTO{
  Visit visit;
  bool statusSubscription;


  VisitDTO({this.visit, this.statusSubscription});

  factory VisitDTO.fromJson(Map<String,dynamic> json){
    return VisitDTO(
        visit: Visit.fromJson(json['visit']),
        statusSubscription: json['statusSubscription']
    );
  }
}