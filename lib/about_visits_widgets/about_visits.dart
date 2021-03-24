import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:visitas_tecnicas_mobile/about_visits_widgets/video_player_screen.dart';

class AboutVisits extends StatelessWidget{
  final APP_BAR_TITLE = "O que é Visita Técnica";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(APP_BAR_TITLE),),
      body: SingleChildScrollView(
          child: _buildCard(context)
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
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 10, right: 10, left: 10 ,),
                child:VideoPlayerScreen()
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
                Text("Visitas Técnica",
                  textAlign: TextAlign.justify,
                  overflow: TextOverflow.visible,
                  softWrap: true,
                ),
                Text("Tudo sobre...",
                  style: descriptionStyle.copyWith(color: Colors.black54),
                ),
                Divider(),
                Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 20),
                  child:Text("A visita técnica tem por objetivo promover a integração entre a teoria e a prática no que se refere aos conhecimentos adquiridos pelos alunos na instituição de ensino; propiciar ao aluno a vivência do mercado de trabalho, produtos, processos e serviços in loco e a integração entre os mesmos; e, propiciar ao estudante a oportunidade de aprimorar a sua formação profissional e pessoal.",
                    textAlign: TextAlign.justify,
                    overflow: TextOverflow.visible,
                    softWrap: true
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}