import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:visitas_tecnicas_mobile/companies_widgets/search.dart';
import 'package:visitas_tecnicas_mobile/models/company.dart';
import 'package:visitas_tecnicas_mobile/services/find_logo_by_company_id.dart';
import 'package:visitas_tecnicas_mobile/services/list_all_companies.dart';

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
        body: CompaniesListView(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
      ),
    );
  }
}

class CompaniesListView extends StatefulWidget {
  @override
  _CompaniesListViewState createState() {
    return _CompaniesListViewState();
  }
}

class _CompaniesListViewState extends State<CompaniesListView> {
  List<Company> _companies;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Company>>(
      future: listAllCompanies(1,10),
      builder: (context, snapshot){
        if (snapshot.hasError) print(snapshot.error);
        if(snapshot.hasData) {
          this._companies = snapshot.data;
          return ListView.builder(
            itemCount: this._companies.length,
            itemBuilder: _itemBuilder,
          );
        }else{
          return Center(child: CircularProgressIndicator());
        }
      });
  }

  Widget _itemBuilder(context, i) {
    Company company = _companies[i];
    return Card(
      child: ListTile(
        leading: FutureBuilder(
          future: findLogoByCompanyId(company.id,50.0,50.0),
          builder: (context,snapshot){
            if(snapshot.hasData){
              return snapshot.data;
            }else{
              return Container(child: Text(""),);
            }
          },
        ),
        onTap: (){
          Navigator.pushNamed(context, '/company-details',arguments: company);
        },
        title: Text(company.name),
        subtitle: Text(company.city+" - "+company.state+"\n"+company.sector.name),
        isThreeLine: true,
      )
    );
  }
}
