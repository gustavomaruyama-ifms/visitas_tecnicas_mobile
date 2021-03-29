import 'package:visitas_tecnicas_mobile/models/company.dart';
import 'package:visitas_tecnicas_mobile/models/course.dart';
import 'package:visitas_tecnicas_mobile/models/user.dart';

class Visit{
  String id;
  Company company;
  String userId;
  int vacancies;
  Course course;
  DateTime date;
  DateTime timeToLeave;
  DateTime timeToArrive;
  String status;

  Visit({this.id, this.company, this.userId, this.vacancies, this.course, this.date,
      this.timeToLeave, this.timeToArrive, this.status});

  factory Visit.fromJson(Map<String,dynamic> json){
    return Visit(
      id : json['_id'],
      company: Company.fromJson(json['company']),
      userId: json['user'],
      vacancies: json['vacancies'],
      course : Course.fromJson(json['course']),
      date: DateTime.parse(json['date']),
      timeToArrive: DateTime.parse(json['timeToLeave']),
      timeToLeave: DateTime.parse(json['timeToArrive']),
      status: json['status']
    );
  }
}