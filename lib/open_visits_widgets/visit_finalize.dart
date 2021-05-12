
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:visitas_tecnicas_mobile/models/subscription.dart';
import 'package:visitas_tecnicas_mobile/models/visit_dto.dart';
import 'package:visitas_tecnicas_mobile/services/finalize_visit.dart';
import 'package:visitas_tecnicas_mobile/services/list_approved_visit_subscriptions.dart';
import 'package:visitas_tecnicas_mobile/services/list_visit_subscriptions.dart';
import 'package:visitas_tecnicas_mobile/services/updateSubscriptionPresence.dart';
import 'package:visitas_tecnicas_mobile/services/updateSubscriptionStatus.dart';

class VisitFinalize extends StatefulWidget{
  VisitDTO visitDTO;

  VisitFinalize(this.visitDTO);

  @override
  State<StatefulWidget> createState() {
     return _VisitFinalizeState(visitDTO);
  }
}

class _VisitFinalizeState extends State<VisitFinalize>{
  final APP_BAR_TITLE = "Finalizar/Presentes";

  VisitDTO visitDTO;
  List<Subscription> _subscriptions;

  _VisitFinalizeState(this.visitDTO);
  bool _finalizing = false;
  @override
  Widget build(context) {
     return Scaffold(
        appBar: AppBar(title: Text(APP_BAR_TITLE)),
         body:_finalizing?Center(child: CircularProgressIndicator()):FutureBuilder(
         future: listApprovedVisitSubscriptions(visitDTO.visit.id, 1, 20),
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
      ),
       floatingActionButton: FloatingActionButton(
         child: Icon(Icons.check),
         onPressed: () async {
           setState(() {
             _finalizing = true;
           });
           await finalizeVisit(visitDTO.visit);
           setState(() {
             _finalizing = false;
           });
           Navigator.of(context).pop();
         },
       ),
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
          Subscription subscriptionUpdated = await updateSubscriptionPresence(subscription);
          setState(() {
            subscription.status = subscriptionUpdated.status;
            subscription.presence = subscriptionUpdated.presence;
            subscription.updatingSubscription = false;
          });
      },
    );
  }
  
  Widget _buildIcon(subscription){
      if(subscription.updatingSubscription){
        return  CircularProgressIndicator();
      }

      if(!subscription.presence){
        return Icon(Icons.check_box_outline_blank_outlined, color: Colors.redAccent,);
      }else {
        return Icon(Icons.check_box_outlined, color: Colors.green,);
      }
  }

  Text _buildSubtitle(subscription){
    if(!subscription.presence){
      return Text("Não compareceu", style: TextStyle(color: Colors.red),);
    }else {
      return Text("Presente", style: TextStyle(color: Colors.green),);
    }
  }
}