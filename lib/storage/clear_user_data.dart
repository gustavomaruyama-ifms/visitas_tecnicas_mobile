import 'package:shared_preferences/shared_preferences.dart';

Future<void> clearUserData() async{
  final store = await SharedPreferences.getInstance();
  await store.clear();
}