import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:visitas_tecnicas_mobile/models/location.dart';
import 'package:visitas_tecnicas_mobile/models/ufc.dart';
import 'package:visitas_tecnicas_mobile/services/config.dart';

Future<Location> listLocationByCep(String cep) async{
  final response = await http.get(Uri.https(VIACEP_URL, '/ws/$cep/json'));
  if(response.statusCode == 200){
    return Location.fromJson(jsonDecode(response.body));
  }else{
    throw Exception(response.body);
  }
}