
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:visitas_tecnicas_mobile/models/subscription.dart';
import 'package:visitas_tecnicas_mobile/models/visit.dart';
import 'package:visitas_tecnicas_mobile/models/visit_dto.dart';
import 'package:visitas_tecnicas_mobile/services/create_subscription.dart';
import 'package:visitas_tecnicas_mobile/services/find_logo_by_company_id.dart';
import 'package:visitas_tecnicas_mobile/services/list_open_visits.dart';
import 'package:visitas_tecnicas_mobile/services/remove_subscription.dart';

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
          if(_openVisits == null) {
            _openVisits = snapshot.data;
          }
          return ListView.builder(
            itemBuilder: _itemBuilder,
            itemCount: _openVisits.length,
            shrinkWrap: true,
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
        key: Key(dto.visit.id),
        child: Padding(
            padding: EdgeInsets.only(left: 10, top: 10, bottom: 10, right: 10),
            child: Row(

              children: [
                Container(
                  child:
                    FutureBuilder(
                      future: findLogoByCompanyId(dto.visit.company.id,80.0,80.0),
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
                                  child: Text(dto.visit.company.name, style: TextStyle(fontWeight: FontWeight.bold)),
                                ),
                                Text(dto.visit.company.city+" "+dto.visit.company.state),
                                Text("Data: ${dto.formattedDate}"),
                                Text("Saída/Retorno: ${dto.formattedtimeToLeave } Hs / ${dto.formattedtimeToArrive} Hs"),
                                Text("Nº de vagas: ${dto.visit.vacancies}"),
                                Text("Status: ${dto.statusSubscription}"),
                              ]
                           ),

                          Padding(
                               padding: const EdgeInsets.only(top: 10),
                               child: Container(
                                   height: 32,
                                   child: _buildButtons(dto)
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
  
  Widget _buildButtons(dto){
    if(dto.updatingSubscription){
      return Container(
          width: 32,
          height: 32,
          child:Center(child: CircularProgressIndicator())
      );
    }
    
    if(dto.statusSubscription=='NAO_INSCRITO') {
      return _buildCreateSubscriptionButton(dto);
    }

    return _buildRemoveSubscription(dto);
  }
  
  Widget _buildCreateSubscriptionButton(dto){
    return Container(
        child:ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.lightGreen,
            ),
            child: Text("Inscrever-se"),
            onPressed: () async {
              setState(() {
                dto.updatingSubscription = true;
              });
              Subscription subscription = await createSubscription(dto.visit);
              setState(() {
                dto.subscription = subscription;
                dto.statusSubscription = subscription.status;
                dto.updatingSubscription = false;
              });
            }
        )
    );
  }
  
  Widget _buildRemoveSubscription(dto) {
    return
      Container(
        child:ElevatedButton(
          child: Text("Cancelar Inscrição"),
          style: ElevatedButton.styleFrom(
            primary: Colors.redAccent,
          ),
          onPressed: () async{
            setState(() {
              dto.updatingSubscription = true;
            });
            await removeSubscription(dto.subscription);
            setState(() {
              dto.subscription = null;
              dto.statusSubscription = "NAO_INSCRITO";
              dto.updatingSubscription = false;
            });
          }
       )
    );
  }
}