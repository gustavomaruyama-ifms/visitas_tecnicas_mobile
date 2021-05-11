import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:visitas_tecnicas_mobile/models/company.dart';
import 'package:visitas_tecnicas_mobile/models/ufc.dart';
import 'package:visitas_tecnicas_mobile/services/config.dart';
import 'package:visitas_tecnicas_mobile/storage/get_user_data.dart';

Future<List<UF>> listAllUFs() async{
  final response = await http.get(Uri.http(IBGE_URL_LOCALIDADES, '/estados'));
  if(response.statusCode == 200){
    return compute(parseUF, response.body);
  }else{
    throw Exception(response.body);
  }
}

List<UF> parseUF(String responseBody){
  final parsed = jsonDecode(responseBody).cast<Map<String,dynamic>>();
  return parsed.map<UF>((json) => UF.fromJson(json)).toList();
}