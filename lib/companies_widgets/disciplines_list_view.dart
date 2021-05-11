import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:visitas_tecnicas_mobile/models/discipline.dart';
import 'package:visitas_tecnicas_mobile/services/list_all_disciplines.dart';

class DisciplinesListView extends StatefulWidget {
  final int maxSelectable;
  final onTapDiscipline;
  List<Discipline> initialSelectedDisciplines;

  DisciplinesListView({this.initialSelectedDisciplines, this.onTapDiscipline, this.maxSelectable = 0});

  @override
  _DisciplinesListViewState createState() {
    return _DisciplinesListViewState(initialSelectedDisciplines: initialSelectedDisciplines, onTapDiscipline: onTapDiscipline, maxSelectable: maxSelectable);
  }
}

class _DisciplinesListViewState extends State<DisciplinesListView> {
  List<Discipline> _disciplines;
  List<Discipline> _selectedDisciplines = [];
  List<Discipline> initialSelectedDisciplines = [];
  int maxSelectable;

  final onTapDiscipline;

  _DisciplinesListViewState({this.initialSelectedDisciplines, this.onTapDiscipline, this.maxSelectable = 0});

  @override
  void initState() {
    if(this.initialSelectedDisciplines!=null && this.initialSelectedDisciplines.isNotEmpty){
      for( Discipline discipline in initialSelectedDisciplines){
        if(discipline == null){
          continue;
        }
        _selectedDisciplines.add(discipline);
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Discipline>>(
        future: listAllSDisciplines(1,10),
        builder: (context, snapshot){
          if (snapshot.hasError) print(snapshot.error);
          if(snapshot.hasData) {

            this._disciplines = snapshot.data;

            return ListView.builder(
              itemCount: this._disciplines.length,
              itemBuilder: _itemBuilder,
            );
          }else{
            return Center(child: CircularProgressIndicator());
          }
        });
  }

  Widget _itemBuilder(context, i) {
    Discipline discipline = _disciplines[i];
    return Card(
        child: ListTile(
          tileColor: _buildTileColor(discipline),
          onTap: (){
            if(maxSelectable <= 1){
                _selectedDisciplines.clear();
                _selectedDisciplines.add(discipline);
            }else {
              _updateSelectedCompanies(discipline);
            }
            onTapDiscipline(context, _selectedDisciplines);
            setState(() {

            });
          },
          title: Text(discipline.name),
          //subtitle: Text(discipline.city+" - "+discipline.state+"\n"+discipline.sector.name),

        )
    );
  }

  Color _buildTileColor(discipline){
    if(maxSelectable == 0){
        return Colors.white;
    }
    for(Discipline selectedDiscipline in _selectedDisciplines ){
      if(discipline.id == selectedDiscipline.id){
        return Colors.lightBlueAccent;
      }
    }
    return Colors.white;
  }

  void _updateSelectedCompanies(discipline){
    for(Discipline selectedDiscipline in _selectedDisciplines ){
      if(discipline.id == selectedDiscipline.id) {
        _selectedDisciplines.remove(selectedDiscipline);
        return;
      }
    }

    if(_selectedDisciplines.length < maxSelectable) {
      _selectedDisciplines.add(discipline);
    }
  }
}
