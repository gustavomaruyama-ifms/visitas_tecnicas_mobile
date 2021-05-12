import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:visitas_tecnicas_mobile/models/subscription.dart';
import 'package:visitas_tecnicas_mobile/services/config.dart';
import 'package:visitas_tecnicas_mobile/storage/get_user_data.dart';

Future<Subscription> updateSubscriptionPresence(subscription) async{
  final user = await getUserData();

  final response = await http.put(Uri.http(API_URL,SUBSCRIPTION_URI+"/presence"),
      headers: <String,String>{
        'x-auth-token': user.token,
        'Content-Type':'application/json'
      },
      body: jsonEncode(subscription.toJson())
  );

  if (response.statusCode == 200){
    return Subscription.fromJson(jsonDecode(response.body));
  }else{
    throw Exception(response.body);
  }
}