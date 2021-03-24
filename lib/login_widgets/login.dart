import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:visitas_tecnicas_mobile/models/error_list.dart';
import 'package:visitas_tecnicas_mobile/services/authenticate.dart';

class Login extends StatefulWidget{
  @override
  _LoginState createState() {
    return _LoginState();
  }
}

class _LoginState extends State<Login>{
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _loading = false;

  @override
  void initState() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          child: _buildForm()
        )
    );
  }

  Form _buildForm(){
    return Form(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildPadding(_buildEmailField()),
          _buildPadding(_buildPasswordField()),
          _loading? CircularProgressIndicator() : _buildPadding(_buildLoginButton())
        ]
      ),
    );
  }

  Padding _buildPadding(child){
    return Padding(
      padding: EdgeInsets.only(bottom: 10, left: 10, right: 10, top: 10),
      child: child
    );
  }

  TextFormField _buildEmailField(){
    return TextFormField(
      controller: emailController,
      decoration: InputDecoration(
          labelText: "E-mail",
          border: _buildInputBorder(),
      ),
    );
  }

  TextFormField _buildPasswordField(){
    return  TextFormField(
        controller: passwordController,
        decoration: InputDecoration(
            labelText: "Senha",
            border: _buildInputBorder()
        ),
        obscureText: true
    );
  }

  ElevatedButton _buildLoginButton(){
    return ElevatedButton(
        onPressed: _onPressed,
        child: Text("Login"),
        style: ButtonStyle(
          padding: MaterialStateProperty.all( EdgeInsets.symmetric(horizontal: 50, vertical: 20)),
          shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100)
              )
          )
        ),
    );
  }

  OutlineInputBorder _buildInputBorder(){
    return OutlineInputBorder(
        borderRadius: BorderRadius.circular(100)
    );
  }

  void _onPressed() async {
    try {
      setState(() {
        _loading = true;
      });
      await authenticate(emailController.text.trim(), passwordController.text.trim());
      Navigator.pop(context);
      Navigator.pushNamed(context, '/');
    } catch(ex){
      Map<String,dynamic> json  = jsonDecode(ex.message);
      final errorList = ErrorList.fromJson(json);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorList.toString()),
          behavior: SnackBarBehavior.floating
        ),
      );
    }finally{
      setState(() {
        _loading = false;
      });
    }
  }
}

