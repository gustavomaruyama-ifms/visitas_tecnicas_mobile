import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:visitas_tecnicas_mobile/models/company.dart';
import 'package:visitas_tecnicas_mobile/models/visit.dart';
import 'package:visitas_tecnicas_mobile/models/visit_dto.dart';
import 'package:visitas_tecnicas_mobile/services/config.dart';
import 'package:visitas_tecnicas_mobile/storage/get_user_data.dart';

Future<List<VisitDTO>> listOpenVisits(page, quantityPerPage) async{
  final user = await getUserData();
  final response = await http.get(Uri.http(API_URL, "$VISIT_URI/list-by-course/page/$page/quantityPerPage/$quantityPerPage"), headers: <String,String>{
    'x-auth-token': user.token
  },);

  if(response.statusCode == 200){
    final parsed = await jsonDecode(response.body).cast<Map<String,dynamic>>();
    return compute(parseVisit, response.body);
  }else{
    throw Exception(response.body);
  }
}

List<VisitDTO> parseVisit(String responseBody){
  final parsed = jsonDecode(responseBody).cast<Map<String,dynamic>>();
  return parsed.map<VisitDTO>((json) => VisitDTO.fromJson(json)).toList();
}