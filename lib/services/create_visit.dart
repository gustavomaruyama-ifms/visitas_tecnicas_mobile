import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:visitas_tecnicas_mobile/models/visit.dart';
import 'package:visitas_tecnicas_mobile/services/config.dart';
import 'package:visitas_tecnicas_mobile/storage/get_user_data.dart';

Future<void> createVisit(visit) async{
  final user = await getUserData();

  final response = await http.post(Uri.https(API_URL,VISIT_URI),
      headers: <String,String>{
        'x-auth-token': user.token,
        'Content-Type':'application/json'
      },
      body: jsonEncode(visit.toJson())
  );

  if (response.statusCode == 200){
    //visit = Visit.fromJson(jsonDecode(response.body));
    //return visit;
  }else{
    throw Exception(response.body);
  }
}