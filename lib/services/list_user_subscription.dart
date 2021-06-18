import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:visitas_tecnicas_mobile/models/subscription.dart';
import 'package:visitas_tecnicas_mobile/services/config.dart';
import 'package:visitas_tecnicas_mobile/storage/get_user_data.dart';

Future<List<Subscription>> listUserSubscription(page, quantityPerPage) async{
  final user = await getUserData();
  final response = await http.get(Uri.https(API_URL, "$SUBSCRIPTION_URI/page/$page/quantityPerPage/$quantityPerPage"), headers: <String,String>{
    'x-auth-token': user.token
  },);

  if(response.statusCode == 200){
    return compute(parseSubscription, response.body);
  }else{
    throw Exception(response.body);
  }
}

List<Subscription> parseSubscription(String responseBody){
  final parsed = jsonDecode(responseBody).cast<Map<String,dynamic>>();
  List<Subscription> list = parsed.map<Subscription>((json) => Subscription.fromJson(json)).toList();
  return list;
}