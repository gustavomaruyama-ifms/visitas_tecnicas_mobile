import 'package:shared_preferences/shared_preferences.dart';
import 'package:visitas_tecnicas_mobile/models/user.dart';

Future<User> getUserData() async{
  final store = await SharedPreferences.getInstance();
  User user = User(
      name: await store.get("user_name"),
      email: await store.getString("user_email"),
      token: await store.getString("user_token"),
      role: await store.getString("user_role"),
  );
  return user;
}