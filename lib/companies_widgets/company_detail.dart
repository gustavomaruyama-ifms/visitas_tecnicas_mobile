import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:visitas_tecnicas_mobile/models/company.dart';
import 'package:visitas_tecnicas_mobile/services/find_logo_by_company_id.dart';

class CompanyDetails extends StatelessWidget{
  final APP_BAR_TITLE = "Detalhes da Empresa";
  Company company;

  CompanyDetails(company){
    this.company = company;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(APP_BAR_TITLE),

        ),
        body: ListView(
            children:[
              _buildCard(context)
            ]
        )
    );
  }

  Widget _buildCard(context){
    return Card(
      clipBehavior: Clip.antiAlias,
      child: _buildCardContent(context),
    );
  }

  Widget _buildCardContent(context){
    final theme = Theme.of(context);
    final titleStyle = theme.textTheme.headline5.copyWith(color: Colors.white);
    final descriptionStyle = theme.textTheme.subtitle1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 184,
          child: Stack(
            children: [
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                  gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                      Colors.blue,
                      Colors.lightBlueAccent,
                  ],
                  )
                ),
              )),
              Positioned(
                bottom: 16,
                left: 16,
                right: 16,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    company.name,
                    style: titleStyle,
                  ),
                ),
              ),
              Positioned(
                bottom: 50,
                left: 50,
                right: 50,
                child:
                  FutureBuilder(
                      future: findLogoByCompanyId(company.id, 100.0, 100.0),
                      builder: (context, snapshot){
                      if(snapshot.hasData){
                        return snapshot.data;
                      }else{
                        return Text("");
                      }
                   },
                  ),
              )
            ],
          ),
        ),
        // Description and share/explore buttons.
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: DefaultTextStyle(
            softWrap: false,
            overflow: TextOverflow.ellipsis,
            style: descriptionStyle,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(company.city+" - "+company.state,
                  style: descriptionStyle.copyWith(color: Colors.black54),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 20),
                  child:Text(company.about,
                    textAlign: TextAlign.justify,
                    overflow: TextOverflow.visible,
                    softWrap: true,
                  ),
                ),
                Divider(),
                Text("Disciplinas relacionadas com a empresa:",
                  style: descriptionStyle.copyWith(color: Colors.black54),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: company.discipline.length,
                  itemBuilder: (context, index) {
                    final discipline = company.discipline[index];

                    return Padding(
                      padding: const EdgeInsets.only(top: 5, bottom: 5),
                      child:Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100)
                        ),
                        color: Colors.blueAccent,

                        child:  Padding(
                            padding: const EdgeInsets.only(top: 10, bottom: 10),
                            child:Center(child:Text(discipline.name, style: TextStyle(color: Colors.white)))
                        )
                      )
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}

