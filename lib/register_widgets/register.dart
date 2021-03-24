import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Register extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RegisterStepper(),
    );
  }
}

class RegisterStepper extends StatefulWidget {
  @override
  _RegisterStepperState createState() {
    return _RegisterStepperState();
  }
}

class _RegisterStepperState extends State<RegisterStepper> {
  int _currentStep = 0;
  int _curso = 1;

  @override
  Widget build(BuildContext context) {
    return Stepper(
      steps: [_buildStepOne(), _buildStepTwo(), _buildStepThree()],
      onStepTapped: (value) {
        setState(() {
          _currentStep = value;
        });
      },
      onStepContinue: () {
        setState(() {
          _currentStep = _currentStep + 1;
        });
      },
      currentStep: _currentStep,
    );
  }

  Step _buildStepOne() {
    return Step(
        title: Text("Informe seus dados pessoais"),
        content: Column(children: [
          TextFormField(decoration: InputDecoration(labelText: "Nome")),
          TextFormField(decoration: InputDecoration(labelText: "Celular")),
          TextFormField(decoration: InputDecoration(labelText: "E-mail")),
        ]));
  }

  Step _buildStepTwo() {
    return Step(
        title: Text("Qual é o seu campus?"),
        content: Column(children: [
          DropdownButtonFormField(
            items: [
              DropdownMenuItem(
                child: Text("Campus Coxim"),
                value: 1,
              ),
              DropdownMenuItem(
                child: Text("Campus Campo Grande"),
                value: 2,
              ),
              DropdownMenuItem(
                child: Text("Campus Corumbá"),
                value: 3,
              )
            ],
            value: _curso,
            onChanged: (value) {
              setState(() {
                _curso = value;
              });
            },
          )
        ]));
  }

  Step _buildStepThree() {
    return Step(
        title: Text("Passo 3"),
        content: Center(
          child: Text("3"),
        ));
  }
}
