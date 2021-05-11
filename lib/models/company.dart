import 'dart:convert';

import 'package:visitas_tecnicas_mobile/models/discipline.dart';
import 'package:visitas_tecnicas_mobile/models/sector.dart';

class Company{
  String id;
  String name;
  String about;
  String city;
  String state;
  String address;
  Sector sector;
  String img;
  String number;
  List<Discipline> discipline;
  bool selected;

  Company({this.id, this.name, this.about, this.city, this.state, this.address, this.sector, this.img, this.discipline, this.number, this.selected = false});

  factory Company.fromJson(Map<String, dynamic> json){
    return Company(
      id : json['_id'],
      name: json['name'] ,
      about:json['about'],
      city: json['city'],
      state: json['state'],
      number: json['number'].toString(),
      sector: Sector.fromJson(json['sector']),
      img: json['img'],
      address: json['address'],
      discipline: json['discipline'] == null? null: json['discipline'].cast<Map<String,dynamic>>().map<Discipline>((json) => Discipline.fromJson(json)).toList()
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'about':about,
      'city': city,
      'state': state,
      'number': number,
      'sector': sector== null?null:sector.id,
      'img': img,
      'address': address,
      'discipline': discipline.map((obj){
        return obj.id;
      }).toList()
    };
  }

}