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
                padding: const EdgeInsets.only(top: 10, right: 10, left: 10 ,),
                child:VideoPlayerScreen()
              )
            ],
          ),
        ),
        // Description and share/explore buttons.
        Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
          child: DefaultTextStyle(
            softWrap: false,
            overflow: TextOverflow.ellipsis,
            style: descriptionStyle,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Visitas Técnicas",
                  textAlign: TextAlign.justify,
                  overflow: TextOverflow.visible,
                  softWrap: true,
                ),
                Divider(),
                Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 20),
                  child:Text("Entenda o que é uma visita técnica assistindo ao vídeo, que foi feito especialmente para explicar de uma forma rápida o que é uma visita técnica, o que acontece durante uma visita e onde ocorre.",
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