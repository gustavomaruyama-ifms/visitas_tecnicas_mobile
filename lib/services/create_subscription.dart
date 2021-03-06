import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:visitas_tecnicas_mobile/models/subscription.dart';
import 'package:visitas_tecnicas_mobile/services/config.dart';
import 'package:visitas_tecnicas_mobile/storage/get_user_data.dart';

Future<Subscription> createSubscription(visit) async{
  final user = await getUserData();

  Subscription subscription = Subscription(visit: visit);

  final response = await http.post(Uri.https(API_URL,SUBSCRIPTION_URI),
      headers: <String,String>{
        'x-auth-token': user.token,
        'Content-Type':'application/json'
      },
      body: jsonEncode(subscription.toJson())
  );

  if (response.statusCode == 200){
    subscription = Subscription.fromJson(jsonDecode(response.body));
    return subscription;
  }else{
    throw Exception(response.body);
  }
}