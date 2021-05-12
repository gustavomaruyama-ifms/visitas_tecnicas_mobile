import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:visitas_tecnicas_mobile/globals.dart' as globals;
import 'package:visitas_tecnicas_mobile/storage/clear_user_data.dart';

class MainDrawer extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _MainDrawerState();
  }
}

class _MainDrawerState extends State<MainDrawer>{
  @override
  Widget build(BuildContext context) {
    return Drawer(child: ListView(
        children: [
          DrawerHeader(
            child: FutureBuilder(
              future: _userData(),
              builder: (context, snapshot){
                if (snapshot.hasData){
                  return Center(child: Text(snapshot.data, style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),), );

                }else{
                  return Container(child: CircularProgressIndicator(), padding: const EdgeInsets.all(20.0));
                }
              },
            ),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),
          ListTile(title: Text("O que é Visita Técnica?"),leading: Icon(Icons.help), onTap: _navigateToAboutTechnicaVisit, ),
          ListTile(title: Text("Empresas/Instituições"),leading: Icon(Icons.business), onTap: _navigateToCompanies, ),
          ListTile(title: Text("Visitas Técnicas Abertas"),leading: Icon(Icons.campaign), onTap: _navigateToOpenVisits, ),
          globals.user.role == "ESTUDANTE"?
          ListTile(title: Text("Minhas Visitas"),leading: Icon(Icons.fact_check), onTap: _navigateToMyVisits, ):
          ListTile(title: Text("Visitas Técnicas Finalizadas"),leading: Icon(Icons.fact_check), onTap: _navigateToFinalizedVisits, ),
          ListTile(title: Text("Logout"),leading: Icon(Icons.logout), onTap: _logout, ),
        ]
    ));
  }

  Future<String> _userData() async{
    final store = await SharedPreferences.getInstance();
    return await store.getString("user_name");
  }

  void _navigateToAboutTechnicaVisit(){
    Navigator.pop(context);
    Navigator.pushNamed(context, '/about-visits');
  }

  void _navigateToCompanies(){
    Navigator.pop(context);
    Navigator.pushNamed(context, '/companies');
  }

  void _navigateToOpenVisits(){
    Navigator.pop(context);
    Navigator.pushNamed(context, '/open-visits');
  }

  void _navigateToMyVisits(){
    Navigator.pop(context);
    Navigator.pushNamed(context, '/my-visits');
  }

  void _navigateToFinalizedVisits(){
    Navigator.pop(context);
    Navigator.pushNamed(context, '/finalized-visits');
  }

  void _logout() async {
   await clearUserData();
   globals.user = null;
   Navigator.pop(context);
   Navigator.pushNamed(context, '/');
  }

}