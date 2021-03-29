import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:visitas_tecnicas_mobile/models/subscription.dart';
import 'package:visitas_tecnicas_mobile/services/config.dart';
import 'package:visitas_tecnicas_mobile/storage/get_user_data.dart';

Future<void> removeSubscription(subscription) async{
  final user = await getUserData();

  final response = await http.delete(Uri.http(API_URL,"$SUBSCRIPTION_URI/id/${subscription.id}"),
      headers: <String,String>{
        'x-auth-token': user.token,
      }
  );

  if (response.statusCode != 200){
    throw Exception(response.body);
  }
}