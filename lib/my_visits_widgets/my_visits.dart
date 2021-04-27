import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:visitas_tecnicas_mobile/models/subscription.dart';
import 'package:visitas_tecnicas_mobile/services/list_user_subscription.dart';

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
          return ListView.separated(
            itemCount: _subscriptions.length,
            separatorBuilder:(context, index) => Divider(),
            itemBuilder: (context, index) => ListTile(title: Text(_subscriptions[index].id),),);
        }else{
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}