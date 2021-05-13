
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:visitas_tecnicas_mobile/models/subscription.dart';
import 'package:visitas_tecnicas_mobile/models/visit_dto.dart';
import 'package:visitas_tecnicas_mobile/services/create_subscription.dart';
import 'package:visitas_tecnicas_mobile/services/find_logo_by_company_id.dart';
import 'package:visitas_tecnicas_mobile/services/list_open_visits.dart';
import 'package:visitas_tecnicas_mobile/services/remove_subscription.dart';
import 'package:visitas_tecnicas_mobile/globals.dart' as globals ;

class OpenVisits extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _OpenVisitsState();
  }
}

class _OpenVisitsState extends State<OpenVisits>{
  final APP_BAR_TITLE = "Visitas Técnicas Abertas";
  List<VisitDTO> _openVisits;

  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(APP_BAR_TITLE)),
      body: _buildListViewOpenVisits(),
      floatingActionButton: globals.user.role == "PROFESSOR"? FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async{
          await Navigator.pushNamed(context, '/add-visit');
          setState(() {

          });
        },
      ): null,
    );
  }

  @override
  Widget _buildListViewOpenVisits() {
    return FutureBuilder(
      future: listOpenVisits(1, 20),
      builder: (context, snapshot) {
        if (snapshot.hasError) print(snapshot.error);

        if(snapshot.hasData){
          if(_openVisits == null || snapshot.data.length != _openVisits.length) {
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
                                Text(dto.visit.company.city),
                                Text(dto.visit.company.state),
                                Text("Data: ${dto.visit.formattedDate}"),
                                Text("Saída/Retorno: ${dto.visit.formattedtimeToLeave } Hs / ${dto.visit.formattedtimeToArrive} Hs"),
                                Text("Nº de vagas: ${dto.visit.vacancies}"),
                                globals.user.role == "PROFESSOR"?
                                Text("Status: ${dto.visit.status}"):
                                Text("Status: ${dto.statusSubscription}"),
                              ]
                           ),

                          Padding(
                               padding: const EdgeInsets.only(top: 10.0),
                               child:
                               globals.user.role == "PROFESSOR" && dto.authorizedToEdit?
                               Row(
                                   children: [
                                     dto.readyToFinalize?
                                     _buildFinalizeButton(dto):
                                     _buildListSubscribesButton(dto),
                                     _buildRemoveButton()
                                   ]
                               ):
                               globals.user.role == "ESTUDANTE"?
                               Row(
                                   children: [
                                     dto.readyToFinalize?Container():
                                     _buildUserButtons(dto)
                                   ]
                               ):
                               Container()
                           )
                        ]
                    )
                )
              ],
            )
        )
    );
  }

  Widget _buildFinalizeButton(dto){
    return Container(
        child:Padding(padding: EdgeInsets.only(right: 5.0), child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.orange,
            ),
            child: Text("Finalizar"),
            onPressed: () async {
              await Navigator.pushNamed(context, '/visit-finalize',arguments: dto);
              setState(() {

              });
            }
        )
        )
    );
  }

  Widget _buildUserButtons(dto){
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
        child:Padding(padding: EdgeInsets.only(right: 5.0), child:ElevatedButton(
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
                print(subscription.id);
                dto.statusSubscription = subscription.status;
                dto.updatingSubscription = false;
              });
            }
        )
        )
    );
  }
  
  Widget _buildRemoveSubscription(dto) {
    return
      Container(
          child:Padding(padding: EdgeInsets.only(right: 5.0), child:ElevatedButton(
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
        )
    );
  }

  Widget _buildRemoveButton(){
    return Container(
        child:Padding(padding: EdgeInsets.only(right: 5.0), child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.redAccent,
            ),
            child: Text("Remover"),
            onPressed: () async {

            }
        )
        )
    );
  }

  Widget _buildListSubscribesButton(dto){
    return Container(
        child:Padding(padding: EdgeInsets.only(right: 5.0), child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.blueAccent,
            ),
            child: Text("Inscritos"),
            onPressed: () async {
              Navigator.pushNamed(context, '/visit-subscriptions',arguments: dto);
            }
        )
        )
    );
  }

  Widget _buildEditButton(){
    return Container(
        child:Padding(padding: EdgeInsets.only(right: 5.0), child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.lightBlueAccent,
            ),
            child: Text("Editar"),
            onPressed: () async {

            }
        )
        )
    );
  }
}