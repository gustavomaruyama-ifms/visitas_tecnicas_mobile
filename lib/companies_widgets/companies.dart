import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:visitas_tecnicas_mobile/companies_widgets/companies_list_view.dart';
import 'package:visitas_tecnicas_mobile/companies_widgets/search.dart';


class Companies extends StatelessWidget {
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
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
      ),
    );
  }

  void onTapCompany(context, companies){
    Navigator.pushNamed(context, '/company-detail',arguments: companies[0]);
  }
}
