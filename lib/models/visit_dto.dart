import 'package:intl/intl.dart';
import 'package:visitas_tecnicas_mobile/models/subscription.dart';
import 'package:visitas_tecnicas_mobile/models/visit.dart';

class VisitDTO{
  Visit visit;
  String statusSubscription;
  bool updatingSubscription;
  Subscription subscription;
  bool readyToFinalize;
  bool authorizedToEdit;

  VisitDTO({this.visit, this.statusSubscription, this.updatingSubscription=false, this.subscription, this.readyToFinalize, this.authorizedToEdit});

  factory VisitDTO.fromJson(Map<String,dynamic> json){
    return VisitDTO(
        visit: Visit.fromJson(json['visit']),
        statusSubscription: json['statusSubscription'],
        readyToFinalize:json['readyToFinalize'],
        authorizedToEdit: json['authorizedToEdit'],
        subscription:  json['subscription'] is Map? Subscription.fromJson(json['subscription']): Subscription(id:json['statusSubscription'])
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