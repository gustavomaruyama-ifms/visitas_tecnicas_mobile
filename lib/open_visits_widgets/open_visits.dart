
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:visitas_tecnicas_mobile/models/visit.dart';
import 'package:visitas_tecnicas_mobile/models/visit_dto.dart';
import 'package:visitas_tecnicas_mobile/services/find_logo_by_company_id.dart';
import 'package:visitas_tecnicas_mobile/services/list_open_visits.dart';

class OpenVisits extends StatelessWidget{
  final APP_BAR_TITLE = "Visitas Técnicas Abertas";
  @override
  Widget build(BuildContext context) {
     return Scaffold(
       appBar: AppBar(title: Text(APP_BAR_TITLE)),
       body: ListViewOpenVisits(),
     );
  }
}

class ListViewOpenVisits extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return _ListViewOpenVisitsState();
  }
}

class _ListViewOpenVisitsState extends State<ListViewOpenVisits>{
  List<VisitDTO> _openVisits;
  
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: listOpenVisits(1, 10),
      builder: (context, snapshot) {
        if (snapshot.hasError) print(snapshot.error);

        if(snapshot.hasData){
          _openVisits = snapshot.data;
          return ListView.builder(
              itemBuilder: _itemBuilder,
              itemCount: _openVisits.length,
          );
        }else{
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _itemBuilder(context, i) {
    VisitDTO dto = _openVisits[i];
    return Card(
        child: ListTile(
          leading: FutureBuilder(
            future: findLogoByCompanyId(dto.visit.company.id,50.0,50.0),
            builder: (context,snapshot){
              if(snapshot.hasData){
                return snapshot.data;
              }else{
                return Container(child: Text(""),);
              }
            },
          ),
          title: Text(dto.visit.company.name),
          subtitle: Text("Status: ${dto.visit.status}"),
          isThreeLine: true,
        )
    );
  }
}