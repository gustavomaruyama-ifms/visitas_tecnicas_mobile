import 'package:visitas_tecnicas_mobile/models/discipline.dart';
import 'package:visitas_tecnicas_mobile/models/sector.dart';

class Company {
  String id;
  String name;
  String about;
  String city;
  String state;
  String address;
  Sector sector;
  String img;
  List<Discipline> disciplines;

  Company({this.id, this.name, this.about, this.city, this.state, this.address, this.sector, this.img, this.disciplines});

  factory Company.fromJson(Map<String, dynamic> json){
    return Company(
      id : json['_id'],
      name: json['name'] ,
      about:json['about'],
      city: json['city'],
      state: json['state'],
      sector: Sector.fromJson(json['sector']),
      img: json['img'],
      address: json['address'],
      disciplines: json['discipline'].cast<Map<String,dynamic>>().map<Discipline>((json) => Discipline.fromJson(json)).toList()
    );
  }
}