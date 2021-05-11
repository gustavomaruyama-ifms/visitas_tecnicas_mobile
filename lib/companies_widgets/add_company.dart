import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:visitas_tecnicas_mobile/models/company.dart';
import 'package:visitas_tecnicas_mobile/models/discipline.dart';
import 'package:visitas_tecnicas_mobile/models/location.dart';
import 'package:visitas_tecnicas_mobile/models/sector.dart';
import 'package:visitas_tecnicas_mobile/services/create_company.dart';
import 'package:visitas_tecnicas_mobile/services/list_all_sectors.dart';
import 'package:visitas_tecnicas_mobile/services/list_location_by_cep.dart';

import 'disciplines_list_view.dart';

class AddCompany extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AddCompanyState();
  }
}

class AddCompanyState extends State<AddCompany> {
  final APP_BAR_TITLE = "Nova Empresa";

  TextEditingController nameController;
  TextEditingController aboutController;
  TextEditingController cepController;
  TextEditingController cityController;
  TextEditingController stateController;
  TextEditingController addressController;
  TextEditingController numberController;
  List<Discipline> _selectedDisciplines;
  Location location;
  Company company;
  int _tabIndex = 0;
  Uint8List _image;
  final picker = ImagePicker();
  bool creating = false;

  @override
  void initState() {
    nameController = TextEditingController();
    aboutController = TextEditingController();
    cepController = TextEditingController();
    cityController = TextEditingController();
    stateController = TextEditingController();
    addressController = TextEditingController();
    numberController = TextEditingController();
    company = Company();
    location = Location();
    _selectedDisciplines = [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 4,
        initialIndex: _tabIndex,
        child:
        creating? Scaffold(body:Center(child: CircularProgressIndicator())):
        Scaffold(
          appBar: AppBar(
            title: Text(APP_BAR_TITLE),
            bottom: TabBar(
              tabs: [
                Tab(text: "Geral", icon: Icon(Icons.info_outline)),
                Tab(text: "Endereço", icon: Icon(Icons.location_on_outlined)),
                Tab(text: "Disciplinas", icon: Icon(Icons.school_outlined)),
                Tab(
                    text: "Finalização",
                    icon: Icon(Icons.check))
              ],
            ),
          ),
          body: TabBarView(
            children: [
              _buildForm(),
              _buildAddressForm(),
              Scaffold(body: DisciplinesListView(maxSelectable: 10, initialSelectedDisciplines:_selectedDisciplines, onTapDiscipline: onTapDiscipline,)),
              _buildFinalizacaoScreen()
            ],
          ),
        ));
  }

  void onTapDiscipline(context, disciplines){
    setState(() {
      this._selectedDisciplines.clear();
      this._selectedDisciplines.addAll(disciplines);
    });
  }
  
  Widget _buildImageSelector() {
    return
      Card(
          child: Container(
              padding: EdgeInsets.only(
                  top: 10.0, left: 10.0, right: 10.0, bottom: 20.0),
              child: Column(
                children: [
                  Container(
                      padding: EdgeInsets.only(bottom: 10.0),
                      child: _image == null?Icon(Icons.image_search,size: 100.0,color: Colors.grey,):Image.memory(_image,height: 100.0),
                  ),
                  ElevatedButton(onPressed: getImage, child: Text("Selecionar Logo")),
                ],
              )
          )
      );
  }

  Future getImage() async {
    PickedFile pickedFile = await picker.getImage(source: ImageSource.gallery);
    final fileBytes = await pickedFile.readAsBytes();
    setState(() {
      if (pickedFile != null) {
        _image = fileBytes;
      } else {
        print('No image selected.');
      }
    });
  }

  Widget _buildForm() {
    return ListView(children: [
      Card(
          child: Container(
              padding: EdgeInsets.only(
                  top: 10.0, left: 10.0, right: 10.0, bottom: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: nameController,
                    validator: formValidator,
                    decoration: InputDecoration(labelText: "Nome"),
                  ),
                  TextFormField(
                    controller: aboutController,
                    validator: formValidator,
                    decoration: InputDecoration(labelText: "Descrição"),
                  )
                ],
              ))),
      Card(
        child: Container(
          padding: EdgeInsets.only(
          top: 10.0, left: 10.0, right: 10.0, bottom: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _buildDropDown()
            ])
        )
      ),
      _buildImageSelector(),
    ]);
  }
  Sector dropdownValue;
  List<Sector> sectors;
  Widget _buildDropDown(){
    return FutureBuilder(
        future: listAllSectors(1, 20),

        builder: (context, snapshot) {
          if(snapshot.hasData){
            if(sectors == null){
              sectors = snapshot.data;
            }
            if(dropdownValue == null){
              dropdownValue = sectors[0];
            }
            return DropdownButton(
              isExpanded: true,
                icon: const Icon(Icons.arrow_downward),
                iconSize: 24,
                onChanged: (newValue) {
                  setState(() {
                    dropdownValue = newValue;
                  });
                },
                value: dropdownValue,
                items: sectors
                  .map<DropdownMenuItem<Sector>>((Sector value) {
                return DropdownMenuItem<Sector>(
                  value: value,
                  child: Text(value.name),
                );
              }).toList()
            );
          }else{
            return CircularProgressIndicator();
          }
        }
    );
  }

  String formValidator(value){
    if (value == null || value.isEmpty) {
      return 'Campo obrigatório';
    }
    return null;
  }

  Widget _buildAddressForm() {
    return ListView(children: [
      Card(
          child: Container(
              padding: EdgeInsets.only(
                  top: 10.0, left: 10.0, right: 10.0, bottom: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  TextFormField(
                    decoration: InputDecoration(labelText: "CEP"),
                    maxLength: 8,
                    controller: cepController,
                    onChanged: (value) async {
                      if (value.length == 8) {
                        location = await listLocationByCep(cepController.text.trim());
                        setState(() {
                          stateController.text = location.uf == null ? '' : location.uf;
                          cityController.text = location.localidade == null? '': location.localidade;
                          addressController.text = location.logradouro;
                        });

                      } else {
                        setState(() {
                          stateController.text = '';
                          cityController.text = '';
                        });
                      }
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: "Cidade",
                    ),
                    validator: formValidator,
                    controller: cityController,
                    enabled: false,
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: "Estado"),
                    validator: formValidator,
                    controller: stateController,
                    enabled: false,
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: "Endereço"),
                    validator: formValidator,
                    controller: addressController,
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: "Nº"),
                    controller: numberController,
                    keyboardType: TextInputType.number,
                    validator: formValidator,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  )
                ],
              )))
    ]);
  }
  Widget _buildFinalizacaoScreen(){
    return Scaffold(
      body:
      ListView(
        shrinkWrap: true,
        children: [
          Padding(
              padding: EdgeInsets.only(left: 5.0, top: 20.0, right: 5.0, bottom: 5.0),
              child:Text("Resumo", style: Theme.of(context).textTheme.headline6)
          ),

          Divider(indent: 5.0, endIndent: 5.0,),
          Padding(
              padding: EdgeInsets.only(left: 5.0,top: 10.0),
              child: Text("Logotipo:")
          ),
          Card(child:_showLogotipo()),
          Padding(
              padding: EdgeInsets.only(left: 5.0,top: 10.0),
              child: Text("Nome:")
          ),
          Card(child:_showName()),
          Padding(
              padding: EdgeInsets.only(left: 5.0,top: 10.0),
              child: Text("Descrição:")
          ),
          Card(child:_showAbout()),
          Padding(
              padding: EdgeInsets.only(left: 5.0,top: 10.0),
              child: Text("Setor:")
          ),
          Card(child:_showSector()),
          Padding(
              padding: EdgeInsets.only(left: 5.0,top: 10.0),
              child: Text("Cidade:")
          ),
          Card(child:_showCity()),
          Padding(
              padding: EdgeInsets.only(left: 5.0,top: 10.0),
              child: Text("Estado:")
          ),
          Card(child:_showState()),
          Padding(
              padding: EdgeInsets.only(left: 5.0,top: 10.0),
              child: Text("Endereço:")
          ),
          Card(child:_showAddress()),
          Padding(
              padding: EdgeInsets.only(left: 5.0,top: 10.0),
              child: Text("Número:")
          ),
          Card(child:_showNumber()),
          Padding(
              padding: EdgeInsets.only(left: 5.0,top: 10.0),
              child: Text("Disciplinas relacionadas:")
          ),
          _showDisciplines()
        ],
      ),
      floatingActionButton: validate() == true ?
      FloatingActionButton(child: Icon(Icons.check), backgroundColor: Colors.green,
        onPressed: finalizar
      ):
      FloatingActionButton(child: Icon(Icons.check), backgroundColor: Colors.grey,
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text("Preencha todos os campos"),
                  behavior: SnackBarBehavior.floating
              ),
            );
          },
      )
 //floatingActionButton: validate()?FloatingActionButton(child: Icon(Icons.check), onPressed: finalizar):null,
    );
  }

  Widget _showDisciplines(){
    if(_selectedDisciplines.length == 0){
      return Card(
          margin: EdgeInsets.only(bottom: 40.0),
          child:ListTile(
            leading: Icon(Icons.dangerous,color: Colors.red,),
            title: Text("Disciplina(s) não relacionadas ", style: TextStyle(color: Colors.red)),
          )
      );
    }
    return  ListView.builder(
      padding: EdgeInsets.only(bottom: 40.0),
      itemCount: _selectedDisciplines.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return Card(child:ListTile(
          title: Text(_selectedDisciplines[index].name),
        ));
      },
    );
  }

  Widget _showLogotipo(){
    return Container(
            color: Colors.blueAccent,
            padding: EdgeInsets.only(
                top: 10.0, left: 10.0, right: 10.0, bottom: 10.0),
            child: Column(
              children: [
                Container(
                  child: _image == null?Icon(Icons.image_search,size: 70.0,color: Colors.white,):Image.memory(_image,height: 70.0),
                )
              ],
            )
        );
  }

  Widget _showSector(){
    if(dropdownValue == null){
      return ListTile(
        leading: Icon(Icons.dangerous,color: Colors.red,),
        title: Text("Setor não definida.", style: TextStyle(color: Colors.red)),
      );
    }

    return ListTile(
        leading: Icon(Icons.check_circle,color: Colors.green,),
        title: Text(dropdownValue.name)
    );
  }

  Widget _showName(){
    if(nameController.text.isEmpty){
      return ListTile(
        leading: Icon(Icons.dangerous,color: Colors.red,),
        title: Text("Nome não definida.", style: TextStyle(color: Colors.red)),
      );
    }

    return ListTile(
        leading: Icon(Icons.check_circle,color: Colors.green,),
        title: Text(nameController.text)
    );
  }

  Widget _showAbout(){
    if(aboutController.text.isEmpty){
      return ListTile(
        leading: Icon(Icons.dangerous,color: Colors.red,),
        title: Text("Descrição não definido.", style: TextStyle(color: Colors.red)),
      );
    }

    return ListTile(
        leading: Icon(Icons.check_circle,color: Colors.green,),
        title: Text(aboutController.text)
    );
  }

  Widget _showCity(){
    if(cityController.text.isEmpty){
      return ListTile(
        leading: Icon(Icons.dangerous,color: Colors.red,),
        title: Text("Cidade não definido.", style: TextStyle(color: Colors.red)),
      );
    }

    return ListTile(
        leading: Icon(Icons.check_circle,color: Colors.green,),
        title: Text(cityController.text)
    );
  }

  Widget _showState(){
    if(stateController.text.isEmpty){
      return ListTile(
        leading: Icon(Icons.dangerous,color: Colors.red,),
        title: Text("Estado não definido.", style: TextStyle(color: Colors.red)),
      );
    }

    return ListTile(
        leading: Icon(Icons.check_circle,color: Colors.green,),
        title: Text(stateController.text)
    );
  }

  Widget _showAddress(){
    if(addressController.text.isEmpty){
      return ListTile(
        leading: Icon(Icons.dangerous,color: Colors.red,),
        title: Text("Endereço não definido.", style: TextStyle(color: Colors.red)),
      );
    }

    return ListTile(
        leading: Icon(Icons.check_circle,color: Colors.green,),
        title: Text(addressController.text)
    );
  }

  Widget _showNumber(){
    if(numberController.text.isEmpty){
      return ListTile(
        leading: Icon(Icons.dangerous,color: Colors.red,),
        title: Text("Número não definido.", style: TextStyle(color: Colors.red)),
      );
    }

    return ListTile(
        leading: Icon(Icons.check_circle,color: Colors.green,),
        title: Text(numberController.text)
    );
  }

  void finalizar() async{
        setState(() {
      creating = true;
    });
    Company company = Company(
    name: nameController.text,
    discipline: _selectedDisciplines,
    address: addressController.text,
    about: aboutController.text,
    sector: dropdownValue,
    city: cityController.text,
    state: stateController.text,
    number: numberController.text,
    img: base64.encode(_image)
    );
    await createCompany(company);
    setState(() {
    creating = false;
    });
    Navigator.of(context).pop();
  }

  bool validate(){
    if(nameController.text.isEmpty){
      return false;
    }
    if(aboutController.text.isEmpty){
      return false;
    }
    if(cityController.text.isEmpty){
      return false;
    }
    if(stateController.text.isEmpty){
      return false;
    }
    if(addressController.text.isEmpty){
      return false;
    }
    if(numberController.text.isEmpty){
      return false;
    }
    if(dropdownValue == null){
      return false;
    }
    if(_selectedDisciplines.length == 0){
      return false;
    }
    return true;
  }
}
