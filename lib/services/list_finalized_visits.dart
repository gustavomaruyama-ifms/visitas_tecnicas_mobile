import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:visitas_tecnicas_mobile/models/visit.dart';
import 'package:visitas_tecnicas_mobile/services/config.dart';
import 'package:visitas_tecnicas_mobile/storage/get_user_data.dart';

Future<List<Visit>> listFinalizedVisits(page, quantityPerPage) async{
  final user = await getUserData();
  final response = await http.get(Uri.https(API_URL, "$VISIT_URI/list-closed-prof/page/$page/quantityPerPage/$quantityPerPage"), headers: <String,String>{
    'x-auth-token': user.token
  },);

  if(response.statusCode == 200){
    final parsed = await jsonDecode(response.body).cast<Map<String,dynamic>>();
    return compute(parseVisit, response.body);
  }else{
    throw Exception(response.body);
  }
}

List<Visit> parseVisit(String responseBody){
  final parsed = jsonDecode(responseBody).cast<Map<String,dynamic>>();
  return parsed.map<Visit>((json) => Visit.fromJson(json)).toList();
}