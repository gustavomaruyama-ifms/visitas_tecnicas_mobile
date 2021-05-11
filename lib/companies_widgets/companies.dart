import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:visitas_tecnicas_mobile/companies_widgets/companies_list_view.dart';
import 'package:visitas_tecnicas_mobile/companies_widgets/search.dart';
import 'package:visitas_tecnicas_mobile/globals.dart' as globals;

class Companies extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CompaniesState();
  }
}

class _CompaniesState extends State<Companies> {
  final APP_BAR_TITLE = "Empresas/Instituições";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(APP_BAR_TITLE),
          actions: [
            IconButton(
                icon: Icon(Icons.search),
                  onPressed: () {
                    showSearch(context: context, delegate: Search());
                  }
                )
          ],
        ),
        body: CompaniesListView(onTapCompany: onTapCompany, maxSelectable: 0,),
      floatingActionButton: globals.user !=null && globals.user.role == "PROFESSOR"? FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: ()async{
          await Navigator.pushNamed(context,"/add-company");
          setState(() {

          });
        },
      ):null,
    );
  }

  void onTapCompany(context, companies){
    Navigator.pushNamed(context, '/company-detail',arguments: companies[0]);
  }
}
