import 'dart:convert';

class User{
  String email;
  String name;
  String role;
  String token;

  User({this.email,this.name, this.role, this.token});

  factory User.fromJson(Map<String, dynamic> json){
    return User(
        email:json['email'],
        name:json['name'],
        role:json['role']);
  }

  Map<String, dynamic> toJson(){
    return{
      'name':name,
      'email':email,
      'role':role,
      'token':token
    };
  }

  factory User.fromAuthenticationJson(Map<String, dynamic> json){
    print(json);
    Map<String, dynamic> userJson = json['user'];
    print(userJson);
    return User(
        email:userJson['email'],
        name:userJson['name'],
        role:userJson['role'],
        token:json['token']);
  }
}