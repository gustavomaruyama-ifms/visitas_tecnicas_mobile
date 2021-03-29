import 'package:intl/intl.dart';
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

  String get formattedDate{
    return DateFormat("dd/MM/yyyy").format(visit.date.toLocal()).toString();
  }

  String get formattedtimeToArrive{
    return DateFormat("HH:mm").format(visit.timeToLeave.toLocal()).toString();
  }

  String get formattedtimeToLeave{
    return DateFormat("HH:mm").format(visit.timeToArrive.toLocal()).toString();
  }
}