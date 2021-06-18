import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:visitas_tecnicas_mobile/models/user.dart';
import 'package:visitas_tecnicas_mobile/services/config.dart';
import 'package:visitas_tecnicas_mobile/storage/set_user_data.dart';

Future<User> authenticate (email, password) async {
  Map<String,dynamic> json = {
    'email':email,
    'password':password
  };

  final response = await http.post(
      Uri.https(API_URL, "$USER_URI/authenticate"),
      headers: <String,String>{
        'Content-Type':'application/json'
      },
      body: jsonEncode(json)
  );

  if (response.statusCode == 200){
    User user = User.fromAuthenticationJson(jsonDecode(response.body));
    await setUserData(user);
    return user;
  }else{
    throw Exception(response.body);
  }
}