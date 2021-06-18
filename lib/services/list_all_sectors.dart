import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:visitas_tecnicas_mobile/models/company.dart';
import 'package:visitas_tecnicas_mobile/models/sector.dart';
import 'package:visitas_tecnicas_mobile/services/config.dart';
import 'package:visitas_tecnicas_mobile/storage/get_user_data.dart';

Future<List<Sector>> listAllSectors(page, quantityPerPage) async{
  final user = await getUserData();
  final response = await http.get(Uri.https(API_URL, "$SECTOR_URI/page/$page/quantityPerPage/$quantityPerPage"), headers: <String,String>{
    'x-auth-token': user.token
  },);

  if(response.statusCode == 200){
    return compute(parseSector, response.body);
  }else{
    throw Exception(response.body);
  }
}

List<Sector> parseSector(String responseBody){
  final parsed = jsonDecode(responseBody).cast<Map<String,dynamic>>();
  return parsed.map<Sector>((json) => Sector.fromJson(json)).toList();
}