import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyVisits extends StatelessWidget{

  final APP_BAR_TITLE = "Minhas Visitas Técnicas";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(APP_BAR_TITLE),)
    );
  }
}