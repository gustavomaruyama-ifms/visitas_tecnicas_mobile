import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:visitas_tecnicas_mobile/companies_widgets/companies.dart';
import 'package:visitas_tecnicas_mobile/companies_widgets/companies_list_view.dart';
import 'package:visitas_tecnicas_mobile/models/company.dart';
import 'package:visitas_tecnicas_mobile/models/user.dart';
import 'package:visitas_tecnicas_mobile/models/visit.dart';
import 'package:visitas_tecnicas_mobile/services/create_visit.dart';
import 'package:visitas_tecnicas_mobile/services/find_logo_by_company_id.dart';

class AddVisit extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _AddVisitState();
  }
}

class _AddVisitState extends State<AddVisit>{
  final APP_BAR_TITLE = "Nova Visita Técnica";
  Company _selectedCompany;
  DateTime _date;
  DateTime _timeToLeave;
  DateTime _timeToArrive;
  TextEditingController _vagasController;
  int _tabIndex = 0;
  bool creating = false;

  @override
  void initState() {
    super.initState();
    _vagasController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return
      DefaultTabController(
          length: 4,
          initialIndex: _tabIndex,
          child:
          creating? Scaffold(body:Center(child: CircularProgressIndicator())):
          Scaffold(
            appBar: AppBar(
              title: Text(APP_BAR_TITLE),
              bottom: TabBar(
                tabs: [
                  Tab(
                      text: "Empresa",
                      icon: Icon(Icons.business)
                  ),
                  Tab(
                      text: "Data/Hora",
                      icon: Icon(Icons.calendar_today)),
                  Tab(
                      text: "Vagas",
                      icon: Icon(Icons.people_alt)),
                  Tab(
                      text: "Finalização",
                      icon: Icon(Icons.check))
                ],
              ),
            ),
            body: TabBarView(
              children: [
                CompaniesListView(initialSelectedCompanies: [_selectedCompany],onTapCompany: onTapCompany, maxSelectable: 1,),
                _buildDateScreen(),
                _buildVagasScreen(),
                _buildFinalizacaoScreen()
              ],
            ),
          )
      );
  }

  void onTapCompany(context, companies){
    setState(() {
      this._selectedCompany = companies[0];
    });
  }

  Widget _buildDateScreen(){
      return ListView(
          children:[
            Padding(
                padding: EdgeInsets.only(left: 5.0, top: 20.0, right: 5.0, bottom: 5.0),
                child:Text("Data e Horários", style: Theme.of(context).textTheme.headline6)
            ),

            Divider(indent: 5.0, endIndent: 5.0,),

            Card(
            child: Padding(
              padding: EdgeInsets.only(left: 20.0, top: 20.0, right: 20.0, bottom: 20.0),
              child:Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                      _buildPadding(DateTimeField(
                      format: DateFormat("dd/MM/yyyy"),
                      initialValue: _date,
                      onChanged: (value) {
                      setState(() {
                        _date = value;
                      });
                    },
                      onShowPicker: (context, currentValue){
                        return showDatePicker(
                            helpText: "Selecione a data",
                            context: context,
                            firstDate: DateTime(1900),
                            initialDate: currentValue ?? DateTime.now(),
                            lastDate: DateTime(2100),
                        );
                      },
                      decoration: InputDecoration(
                        labelText: "Data",
                        border: _buildInputBorder(),
                      ),
                  )),
                  _buildPadding(DateTimeField(
                    format: DateFormat("HH:mm"),
                    initialValue: _timeToLeave,
                    onChanged: (value) {
                      setState(() {
                          _timeToLeave = value;
                      });
                    },
                    onShowPicker: (context, currentValue) async{
                      final time = await showTimePicker(
                        context: context,
                        helpText: "Escolha o horário",
                        initialTime: TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
                        builder: (context, child) =>
                            MediaQuery(data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true), child: child)
                      );
                      return DateTimeField.convert(time);
                    },
                    decoration: InputDecoration(
                      labelText: "Horário de Saída",
                      border: _buildInputBorder(),
                    ),
                  )),
                  _buildPadding(DateTimeField(
                    format: DateFormat("HH:mm"),
                    initialValue: _timeToArrive,
                    onChanged: (value) {
                      setState(() {
                        _timeToArrive = value;
                      });
                    },
                    onShowPicker: (context, currentValue) async{
                      final time = await showTimePicker(
                        helpText: "Escolha o horário",
                        context: context,
                        initialTime: TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
                        builder: (context, child) =>
                            MediaQuery(data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true), child: child)
                      );
                      return DateTimeField.convert(time);
                    },
                    decoration: InputDecoration(
                      labelText: "Horário de Retorno",
                      border: _buildInputBorder(),
                    ),
                  )
                  ),
                ],
              ),
          )
        )
      ]);
  }

  Widget _buildVagasScreen(){
    return ListView(
        children:[
          Padding(
              padding: EdgeInsets.only(left: 5.0, top: 20.0, right: 5.0, bottom: 5.0),
              child:Text("Vagas", style: Theme.of(context).textTheme.headline6)
          ),

          Divider(indent: 5.0, endIndent: 5.0,),

          Card(
              child: Padding(
                padding: EdgeInsets.only(left: 20.0, top: 20.0, right: 20.0, bottom: 20.0),
                child:Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                      TextFormField(
                        controller: _vagasController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        onChanged: (value) {
                          setState(() {

                          });
                        },
                        decoration: InputDecoration(
                          labelText: "Quantidade de Vagas",
                          border: _buildInputBorder(),
                        ),
                      )
                  ],
                ),
              )
          )
        ]);
  }

  OutlineInputBorder _buildInputBorder(){
    return OutlineInputBorder(
        borderRadius: BorderRadius.circular(10)
    );
  }

  Padding _buildPadding(child){
    return Padding(
        padding: EdgeInsets.only(top: 10),
        child: child
    );
  }

  Widget _buildFinalizacaoScreen(){
    return Scaffold(
      body:
        ListView(
          children: [
            Padding(
                padding: EdgeInsets.only(left: 5.0, top: 20.0, right: 5.0, bottom: 5.0),
                child:Text("Resumo", style: Theme.of(context).textTheme.headline6)
            ),

            Divider(indent: 5.0, endIndent: 5.0,),
            Padding(
                padding: EdgeInsets.only(left: 5.0,top: 10.0),
                child: Text("Empresa:")
            ),
            Card(child:_showSelectedCompany()),
            Padding(
                padding: EdgeInsets.only(left: 5.0,top: 10.0),
                child: Text("Data:")
            ),
            Card(child:_showDate()),
            Padding(
                padding: EdgeInsets.only(left: 5.0,top: 10.0),
                child: Text("Horário de Saída:")
            ),
            Card(child:_showHorarioSaida()),
            Padding(
                padding: EdgeInsets.only(left: 5.0,top: 10.0),
                child: Text("Horário de Retorno:")
            ),
            Card(child:_showHorarioRetorno()),
            Padding(
                padding: EdgeInsets.only(left: 5.0,top: 10.0),
                child: Text("Vagas:")
            ),
            Card(child:_showVagas()),
          ],
        ),
      floatingActionButton: validate()?FloatingActionButton(child: Icon(Icons.check), onPressed: finalizar):null,
    );
  }

  Widget _showSelectedCompany(){
    if(_selectedCompany == null){
      return ListTile(
        leading: Icon(Icons.dangerous,color: Colors.red,),
        title: Text("Empresa não selecionada.", style: TextStyle(color: Colors.red)),
      );
    }
    return ListTile(
      leading: FutureBuilder(
        future: findLogoByCompanyId(_selectedCompany.id,50.0,50.0),
        builder: (context,snapshot){
          if(snapshot.hasData){
            return snapshot.data;
          }else{
            return Container(child: Text(""),);
          }
        },
      ),
      title: Text(_selectedCompany.name),
      subtitle: Text(_selectedCompany.city+" - "+_selectedCompany.state+"\n"+_selectedCompany.sector.name),
      isThreeLine: true,
    );
  }

  Widget _showDate(){
    if(_date == null){
      return ListTile(
        leading: Icon(Icons.dangerous,color: Colors.red,),
        title: Text("Data não definida.", style: TextStyle(color: Colors.red)),
      );
    }

    return ListTile(
        leading: Icon(Icons.check_circle,color: Colors.green,),
        title: Text(DateFormat("dd/MM/yyyy").format(_date).toString())
    );
  }

  Widget _showHorarioSaida(){
    if(_timeToLeave == null){
      return ListTile(
        leading: Icon(Icons.dangerous,color: Colors.red,),
        title: Text("Horário de saída não definido.", style: TextStyle(color: Colors.red),),
      );
    }

    return ListTile(
      leading: Icon(Icons.check_circle,color: Colors.green,),
      title: Text(DateFormat("HH:mm").format(_timeToLeave).toString()),
    );
  }

  Widget _showHorarioRetorno(){
    if(_timeToArrive == null){
      return ListTile(
        leading: Icon(Icons.dangerous,color: Colors.red,),
        title: Text("Horário de retorno não definido.", style: TextStyle(color: Colors.red)),
      );
    }

    return ListTile(
        leading: Icon(Icons.check_circle,color: Colors.green,),
      title: Text(DateFormat("HH:mm").format(_timeToArrive).toString())
    );
  }

  Widget _showVagas(){
    if(_vagasController.text.isEmpty){
      return ListTile(
        leading: Icon(Icons.dangerous,color: Colors.red,),
        title: Text("Nº de vagas não definido.", style: TextStyle(color: Colors.red)),
      );
    }

    return ListTile(
      leading: Icon(Icons.check_circle,color: Colors.green,),
      title: Text(_vagasController.value.text),
    );
  }

  void finalizar() async{
    setState(() {
      creating = true;
    });
    Visit visit =  Visit(
        timeToLeave: _timeToLeave.toUtc(),
        timeToArrive: _timeToArrive.toUtc(),
        vacancies: _vagasController.text.isNotEmpty? int.parse(_vagasController.text):0,
        company: _selectedCompany,
        date: _date
    );
    await createVisit(visit);
    setState(() {
      creating = false;
    });
    Navigator.of(context).pop();
  }
  bool validate(){
    if(_selectedCompany==null){
      return false;
    }
    if(_date==null){
      return false;
    }
    if(_timeToArrive==null){
      return false;
    }
    if(_timeToLeave==null){
      return false;
    }
    if(_vagasController.text.isEmpty){
      return false;
    }
    return true;
  }
}