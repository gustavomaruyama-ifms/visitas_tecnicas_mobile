
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OpenVisits extends StatelessWidget{
  final APP_BAR_TITLE = "Visitas Técnicas Abertas";
  @override
  Widget build(BuildContext context) {
     return Scaffold(
       appBar: AppBar(title: Text(APP_BAR_TITLE)),
     );
  }
}