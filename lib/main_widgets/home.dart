import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:visitas_tecnicas_mobile/main_widgets/main_drawer.dart';

class Home extends StatelessWidget{

  final APP_BAR_TITLE = "Home";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(APP_BAR_TITLE)),
        drawer: MainDrawer(),
    );
  }
}