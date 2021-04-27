import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:visitas_tecnicas_mobile/models/company.dart';
import 'package:visitas_tecnicas_mobile/services/find_logo_by_company_id.dart';
import 'package:visitas_tecnicas_mobile/services/list_all_companies.dart';

class CompaniesListView extends StatefulWidget {
  final int maxSelectable;
  final onTapCompany;
  List<Company> initialSelectedCompanies;

  CompaniesListView({this.initialSelectedCompanies, this.onTapCompany, this.maxSelectable = 0});

  @override
  _CompaniesListViewState createState() {
    return _CompaniesListViewState(initialSelectedCompanies: initialSelectedCompanies, onTapCompany: onTapCompany, maxSelectable: maxSelectable);
  }
}

class _CompaniesListViewState extends State<CompaniesListView> {
  List<Company> _companies;
  List<Company> _selectedCompanies = [];
  List<Company> initialSelectedCompanies = [];
  int maxSelectable;

  final onTapCompany;

  _CompaniesListViewState({this.initialSelectedCompanies, this.onTapCompany, this.maxSelectable = 0});

  @override
  void initState() {
    if(this.initialSelectedCompanies!=null && this.initialSelectedCompanies.isNotEmpty){
      for( Company company in initialSelectedCompanies){
        if(company == null){
          continue;
        }
        _selectedCompanies.add(company);
      }
    }
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
          tileColor: _buildTileColor(company),
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
            if(maxSelectable <= 1){
                _selectedCompanies.clear();
                _selectedCompanies.add(company);
            }else {
              _updateSelectedCompanies(company);
            }
            onTapCompany(context, _selectedCompanies);
            setState(() {

            });
          },
          title: Text(company.name),
          subtitle: Text(company.city+" - "+company.state+"\n"+company.sector.name),
          isThreeLine: true,
        )
    );
  }

  Color _buildTileColor(company){
    if(maxSelectable == 0){
        return Colors.white;
    }
    for(Company selectedCompany in _selectedCompanies ){
      if(company.id == selectedCompany.id){
        return Colors.lightBlueAccent;
      }
    }
    return Colors.white;
  }

  void _updateSelectedCompanies(company){
    for(Company selectedCompany in _selectedCompanies ){
      if(company.id == selectedCompany.id) {
        _selectedCompanies.remove(selectedCompany);
        return;
      }
    }

    if(_selectedCompanies.length < maxSelectable) {
      _selectedCompanies.add(company);
    }
  }
}
