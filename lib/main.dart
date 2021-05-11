import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:visitas_tecnicas_mobile/about_visits_widgets/about_visits.dart';
import 'package:visitas_tecnicas_mobile/companies_widgets/add_company.dart';
import 'package:visitas_tecnicas_mobile/companies_widgets/company_detail.dart';
import 'package:visitas_tecnicas_mobile/login_widgets/login.dart';
import 'package:visitas_tecnicas_mobile/main_widgets/home.dart';
import 'package:visitas_tecnicas_mobile/my_visits_widgets/my_visits.dart';
import 'package:visitas_tecnicas_mobile/open_visits_widgets/add_visit.dart';
import 'package:visitas_tecnicas_mobile/open_visits_widgets/visit_subscriptions.dart';
import 'package:visitas_tecnicas_mobile/storage/get_user_data.dart';

import 'companies_widgets/companies.dart';
import 'models/user.dart';
import 'open_visits_widgets/open_visits.dart';

import 'globals.dart' as globals;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
        title: "Visitas Técnicas",
        initialRoute: '/',
        onGenerateRoute: Router.generateRoute,
    );
  }
}

class Router{
  static Route<dynamic> generateRoute(RouteSettings settings){
    switch(settings.name){
      case '/':{
        return MaterialPageRoute(builder: (_) => checkAuth(Home()));
      }
      //case '/login':{
      //  return MaterialPageRoute(builder: (_) => Login());
      //}
      case '/about-visits':{
        return MaterialPageRoute(builder: (_) => checkAuth(AboutVisits()));
      }
      case '/companies':{
        return MaterialPageRoute(builder: (_) => checkAuth(Companies()));
      }
      case '/company-detail':{
        var company = settings.arguments;
        return MaterialPageRoute(builder: (_) => checkAuth(CompanyDetails(company)));
      }
      case '/open-visits':{
        return MaterialPageRoute(builder: (_) => checkAuth(OpenVisits()));
      }
      case '/my-visits':{
        return MaterialPageRoute(builder: (_) => checkAuth(MyVisits()));
      }
      case '/add-visit':{
        return MaterialPageRoute(builder: (_) => checkAuth(AddVisit()));
      }
      case '/visit-subscriptions':{
        var visitDTO = settings.arguments;
        return MaterialPageRoute(builder: (_) => checkAuth(VisitSubscriptions(visitDTO)));
      }
      case '/add-company':{
        return MaterialPageRoute(builder: (_) => checkAuth(AddCompany()));
      }
    }
  }

  static Widget checkAuth(widget){
    return FutureBuilder(
      future: getUserData(),
      builder: (context, snapshot){
        if(snapshot.hasData){
          globals.user = snapshot.data;
          if(globals.user == null || globals.user.token == null){
            return Login();
          }
          return widget;
        }
        return Center(child: CircularProgressIndicator());
      }
    );
  }
}

