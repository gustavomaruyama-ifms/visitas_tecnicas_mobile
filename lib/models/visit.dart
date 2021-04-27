import 'dart:convert';

import 'package:visitas_tecnicas_mobile/models/company.dart';
import 'package:visitas_tecnicas_mobile/models/course.dart';
import 'package:visitas_tecnicas_mobile/models/user.dart';

class Visit{
  String id;
  Company company;
  User user;
  int vacancies;
  Course course;
  DateTime date;
  DateTime timeToLeave;
  DateTime timeToArrive;
  String status;

  Visit({this.id, this.company, this.user, this.vacancies, this.course, this.date,
      this.timeToLeave, this.timeToArrive, this.status});

  factory Visit.fromJson(Map<String,dynamic> json){
    return Visit(
      id : json['_id'],
      company: json['company'] is Map? Company.fromJson(json['company']): Company(id:json['company']),
      user: json['user'] is Map? User.fromJson(json['user']): User (id : json['user']),
      vacancies: json['vacancies'],
      course : json['course'] is Map? Course.fromJson(json['course']): Course(id:json['course']),
      date: DateTime.parse(json['date']),
      timeToArrive: DateTime.parse(json['timeToLeave']),
      timeToLeave: DateTime.parse(json['timeToArrive']),
      status: json['status']
    );
  }

  Map<String, String> toJson(){
    return {
      '_id':id,
      'date':date.toString(),
      'timeToLeave':timeToLeave.toString(),
      'timeToArrive': timeToArrive.toString(),
      'vacancies': vacancies.toString(),
      'company': company.id
    };
  }
}