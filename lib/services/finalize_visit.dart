import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:visitas_tecnicas_mobile/models/subscription.dart';
import 'package:visitas_tecnicas_mobile/models/visit.dart';
import 'package:visitas_tecnicas_mobile/services/config.dart';
import 'package:visitas_tecnicas_mobile/storage/get_user_data.dart';

Future<Visit> finalizeVisit(visit) async{
  final user = await getUserData();

  final response = await http.put(Uri.http(API_URL,VISIT_URI+"/finalize"),
      headers: <String,String>{
        'x-auth-token': user.token,
        'Content-Type':'application/json'
      },
      body: jsonEncode(visit.toJson())
  );

  if (response.statusCode == 200){
    return Visit.fromJson(jsonDecode(response.body));
  }else{
    throw Exception(response.body);
  }
}