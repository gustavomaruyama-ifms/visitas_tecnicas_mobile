
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
    final theme = Theme.of(context);
    final titleStyle = theme.textTheme.headline5.copyWith(color: Colors.white);
    final descriptionStyle = theme.textTheme.subtitle1;

    VisitDTO dto = _openVisits[i];

    return Card(
        child: Container(
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child:
                FutureBuilder(
                  future: findLogoByCompanyId(dto.visit.company.id,70.0,70.0),
                  builder: (context,snapshot){
                    if(snapshot.hasData){
                      return snapshot.data;
                    }else{
                      return Container(child: Text(""),);
                    }
                  },
                )
              ) ,

              Container(height: 140, child: VerticalDivider(),),

              Padding(
                padding: const EdgeInsets.only(left:10, right: 10, top: 10, bottom: 10),
                  child:Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                      child:Text(dto.visit.company.name, style: TextStyle(fontWeight: FontWeight.bold),)
                    ),
                    Text("${dto.visit.company.city} - ${dto.visit.company.state}"),
                    Text("Data: ${dto.formattedDate}"),
                    Text("Saída/Retorno: ${dto.formattedtimeToLeave } Hs / ${dto.formattedtimeToArrive} Hs"),
                    Text("Nº de vagas: ${dto.visit.vacancies}"),
                    Text("Status: ${dto.statusSubscription}"),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child:
                      dto.statusSubscription?
                      ElevatedButton(
                        child: Text("Cancelar Inscrição"),
                        style: ElevatedButton.styleFrom(
                            primary: Colors.redAccent,
                        ),
                        onPressed: () {

                        },
                      ):
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.lightGreen,
                        ),
                        child: Text("Inscrever-se"),
                        onPressed: (){

                        },
                      )
                    )
                  ],)
              )
            ],
          )
        )
    );
  }
}