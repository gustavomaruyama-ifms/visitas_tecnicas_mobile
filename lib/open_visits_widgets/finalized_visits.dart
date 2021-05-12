import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:visitas_tecnicas_mobile/models/visit.dart';
import 'package:visitas_tecnicas_mobile/services/find_logo_by_company_id.dart';
import 'package:visitas_tecnicas_mobile/services/list_finalized_visits.dart';
import 'package:visitas_tecnicas_mobile/services/list_open_visits.dart';
import 'package:visitas_tecnicas_mobile/globals.dart' as globals ;

class FinalizedVisits extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _FinalizedVisitsState();
  }
}

class _FinalizedVisitsState extends State<FinalizedVisits>{
  final APP_BAR_TITLE = "Visitas Técnicas Finalizadas";
  List<Visit> _finalizedVisits;

  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(APP_BAR_TITLE)),
      body: _buildListViewOpenVisits()
    );
  }

  @override
  Widget _buildListViewOpenVisits() {
    return FutureBuilder(
      future: listFinalizedVisits(1, 20),
      builder: (context, snapshot) {
        if (snapshot.hasError) print(snapshot.error);

        if(snapshot.hasData){
          if(_finalizedVisits == null || snapshot.data.length != _finalizedVisits.length) {
            _finalizedVisits = snapshot.data;
          }
          return ListView.builder(
            itemBuilder: _itemBuilder,
            itemCount: _finalizedVisits.length,
            shrinkWrap: true,
          );
        }else{
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _itemBuilder(context, i) {
    Visit visit = _finalizedVisits[i];
    return Card(
        key: Key(visit.id),
        child: Padding(
            padding: EdgeInsets.only(left: 10, top: 10, bottom: 10, right: 10),
            child: Row(

              children: [
                Container(
                  child:
                    FutureBuilder(
                      future: findLogoByCompanyId(visit.company.id,80.0,80.0),
                      builder: (context,snapshot){
                        if(snapshot.hasData){
                          return snapshot.data;
                        }else{
                          return Container(child: Text(""),);
                        }
                      },
                    )
                ),

                Container(
                    height: 180,
                    child: Padding(
                      padding: EdgeInsets.only(left: 5, right: 5),
                      child: VerticalDivider(),
                    )
                ),

                Container(
                    child:
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:[
                           Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(bottom: 10),
                                  child: Text(visit.company.name, style: TextStyle(fontWeight: FontWeight.bold)),
                                ),
                                Text(visit.company.city),
                                Text(visit.company.state),
                                Text("Data: ${visit.formattedDate}"),
                                Text("Saída/Retorno: ${visit.formattedtimeToLeave } Hs / ${visit.formattedtimeToArrive} Hs"),
                                Text("Nº de vagas: ${visit.vacancies}"),
                                Text("Status: ${visit.status}"),
                              ]
                           ),

                          Padding(
                               padding: const EdgeInsets.only(top: 10.0),
                               child:
                               Row(
                                   children: [
                                     _buildPresenceList(visit)
                                   ]
                               )
                           )
                        ]
                    )
                )
              ],
            )
        )
    );
  }

  Widget _buildPresenceList(visit){
    return Container(
        child:Padding(padding: EdgeInsets.only(right: 5.0), child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.orange,
            ),
            child: Text("Lista de Presença"),
            onPressed: () async {
              Navigator.pushNamed(context, '/presence-list',arguments: visit);
            }
        )
        )
    );
  }
}