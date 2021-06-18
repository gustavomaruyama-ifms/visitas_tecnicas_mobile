import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:visitas_tecnicas_mobile/models/visit.dart';
import 'package:visitas_tecnicas_mobile/services/config.dart';
import 'package:visitas_tecnicas_mobile/storage/get_user_data.dart';

Future<void> createCompany(company) async{
  final user = await getUserData();

  String json = jsonEncode(company.toJson());
  print(json);
  final response = await http.post(Uri.https(API_URL,COMPANY_URI),
      headers: <String,String>{
        'x-auth-token': user.token,
        'Content-Type':'application/json'
      },
      body: jsonEncode(company.toJson())
  );

  if (response.statusCode == 200){
    //visit = Visit.fromJson(jsonDecode(response.body));
    //return visit;
  }else{
    throw Exception(response.body);
  }
}