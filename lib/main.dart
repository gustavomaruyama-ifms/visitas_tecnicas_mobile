import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:visitas_tecnicas_mobile/about_visits_widgets/about_visits.dart';
import 'package:visitas_tecnicas_mobile/companies_widgets/company_detail.dart';
import 'package:visitas_tecnicas_mobile/login_widgets/login.dart';
import 'package:visitas_tecnicas_mobile/main_widgets/home.dart';
import 'package:visitas_tecnicas_mobile/my_visits_widgets/my_visits.dart';
import 'package:visitas_tecnicas_mobile/register_widgets/register.dart';

import 'companies_widgets/companies.dart';
import 'open_visits_widgets/open_visits.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Visitas Técnicas",
        initialRoute: "/login",
        routes: {
          '/': (context)=> Home(),
          '/login': (context)=> Login(),
          '/about-visits': (context)=>AboutVisits(),
          '/companies': (context)=> Companies(),
          '/company-details':(context)=>CompanyDetails(),
          '/open-visits': (context)=>OpenVisits(),
          '/my-visits': (context)=> MyVisits(),
          '/register':(context)=>Register(),
        }
    );
  }
}