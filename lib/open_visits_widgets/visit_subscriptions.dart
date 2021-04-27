
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:visitas_tecnicas_mobile/models/subscription.dart';
import 'package:visitas_tecnicas_mobile/models/visit_dto.dart';
import 'package:visitas_tecnicas_mobile/services/list_visit_subscriptions.dart';
import 'package:visitas_tecnicas_mobile/services/updateSubscriptionStatus.dart';

class VisitSubscriptions extends StatefulWidget{
  VisitDTO visitDTO;

  VisitSubscriptions(this.visitDTO);

  @override
  State<StatefulWidget> createState() {
     return _VisitSubscriptionsState(visitDTO);
  }
}

class _VisitSubscriptionsState extends State<VisitSubscriptions>{
  final APP_BAR_TITLE = "Inscrições";

  VisitDTO visitDTO;
  List<Subscription> _subscriptions;

  _VisitSubscriptionsState(this.visitDTO);

  @override
  Widget build(context) {
     return Scaffold(
        appBar: AppBar(title: Text(APP_BAR_TITLE),),
         body:FutureBuilder(
         future: listVisitSubscriptions(visitDTO.visit.id, 1, 20),
         builder: (context, snapshot) {
            //if (snapshot.hasError) print(snapshot.error);
            if(snapshot.hasData){
              if(this._subscriptions == null || snapshot.data.length != this._subscriptions.length) {
                this._subscriptions  = snapshot.data;
              }
              return ListView.separated(
                  itemCount: _subscriptions.length,
                  itemBuilder: _itemBuilder,
                  separatorBuilder: (context, index) => Divider(),
              );
            }else{
              return Center(child: CircularProgressIndicator());
            }
         },
      )
     );
  }

  Widget _itemBuilder(context, index){
    Subscription subscription = _subscriptions[index];

    return ListTile(
      title: Text(subscription.user.name),
      trailing: _buildIcon(subscription),
      subtitle: _buildSubtitle(subscription),
      onTap: () async {
          setState(() {
            subscription.updatingSubscription = true;
          });
          Subscription subscriptionUpdated = await updateSubscriptionStatus(subscription);
          setState(() {
            subscription.status = subscriptionUpdated.status;
            subscription.updatingSubscription = false;
          });
      },
    );
  }
  
  Widget _buildIcon(subscription){
      if(subscription.updatingSubscription){
        return  CircularProgressIndicator();
      }

      if(subscription.status == "EM_ANALISE"){
        return  Icon(Icons.check_box_outline_blank, color: Colors.amber,);
      }else if(subscription.status == "APROVADA"){
        return Icon(Icons.check_box_outlined, color: Colors.green,);
      }else{
        return Icon(Icons.clear, color: Colors.redAccent,);
      }
  }

  Text _buildSubtitle(subscription){
    if(subscription.status == "EM_ANALISE"){
      return Text("Inscrição em Analise", style: TextStyle(color: Colors.amber),);
    }else if(subscription.status == "APROVADA"){
      return Text("Inscrição Aprovada", style: TextStyle(color: Colors.green),);
    }else{
      return Text("Inscrição Recusada", style: TextStyle(color: Colors.red),);
    }
  }
}