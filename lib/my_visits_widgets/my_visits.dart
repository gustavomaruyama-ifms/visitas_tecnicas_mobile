import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:visitas_tecnicas_mobile/models/subscription.dart';
import 'package:visitas_tecnicas_mobile/services/find_logo_by_company_id.dart';
import 'package:visitas_tecnicas_mobile/services/list_user_subscription.dart';
import 'package:visitas_tecnicas_mobile/services/update_assesment.dart';


class MyVisits extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _MyVisitsState();
  }
}

class _MyVisitsState extends State<MyVisits>{

  final APP_BAR_TITLE = "Minhas Visitas Técnicas";

  List<Subscription> _subscriptions;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(APP_BAR_TITLE),),
      body: _buildListViewMyVisits(),
    );
  }

  Widget _buildListViewMyVisits(){
    return FutureBuilder(
      future: listUserSubscription(1, 10),
      builder: (context, snapshot) {
        if(snapshot.hasData){
          this._subscriptions = snapshot.data;
          return ListView.builder(
            itemCount: _subscriptions.length,
            itemBuilder: _itemBuilder);
        }else{
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _itemBuilder(context, i) {
    Subscription subscription = _subscriptions[i];
    return Card(
        key: Key(subscription.id),
        child: Padding(
            padding: EdgeInsets.only(left: 10, top: 10, bottom: 10, right: 10),
            child: Row(

              children: [
                Container(
                    child:
                    FutureBuilder(
                      future: findLogoByCompanyId(subscription.visit.company.id,80.0,80.0),
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
                                  child: Text(subscription.visit.company.name, style: TextStyle(fontWeight: FontWeight.bold)),
                                ),
                                Text('${subscription.visit.company.city} - ${subscription.visit.company.state}'),
                                Text("Data: ${subscription.visit.formattedDate}"),
                                _buildPresenceStatus(subscription),
                                subscription.presence?
                                Text("Dê uma nota:"):
                                Text("Não é possível atribuir nota")
                                ,
                                _buildRating(subscription),
                                ElevatedButton(onPressed: (){
                                  Navigator.pushNamed(context, "/certificate-screen", arguments: subscription);
                                }, child: Text('Certificado'))
                              ]
                          ),

                          Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child:
                              Row(
                                  children: [

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

  Widget _buildPresenceStatus(subscription){
    if(!subscription.presence){
      return Text("Presença não confirmada", style: TextStyle(color: Colors.red),);
    }
    return Text("Presença confirmada", style: TextStyle(color: Colors.green),);
  }

  Widget _buildRating(subscription){
     if(!subscription.presence){
       return Row();
     }

     List<Widget> stars = [];
     for(var i = 1; i <= 5; i++){
       stars.add(_buildStar(i, subscription));
     }
     return Row(
       children: stars
     );
  }

  Widget _buildStar(index, subscription){
    int note = subscription.assessment;
    return IconButton(
      icon: index<=note?Icon(Icons.star):Icon(Icons.star_border),
      color: index<=note?Colors.yellow:Colors.black26,
      onPressed: () async{
        subscription.assessment = index;
        await updateAssesment(subscription);
        setState(() {

        });
      }
    );
  }

}