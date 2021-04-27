import 'package:shared_preferences/shared_preferences.dart';
import 'package:visitas_tecnicas_mobile/models/user.dart';

Future<void> setUserData(User user) async{
  final store = await SharedPreferences.getInstance();
  await store.setString("user_name", user.name);
  await store.setString( "user_email", user.email);
  await store.setString("user_role", user.role);
  await store.setString("user_token", user.token);
}