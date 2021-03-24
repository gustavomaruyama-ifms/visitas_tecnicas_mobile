import 'package:visitas_tecnicas_mobile/models/error_message.dart';

class ErrorList{
  List<ErrorMessage> errors;

  ErrorList({this.errors});

  factory ErrorList.fromJson(Map<String, dynamic> json){
    return ErrorList(errors: json['errors'].cast<Map<String,dynamic>>().map<ErrorMessage>((json) => ErrorMessage.fromJson(json)).toList());
  }

  @override
  String toString() {
    String errorsStr = "";
    for(ErrorMessage error in errors){
      errorsStr += error.msg;
      if(error != errors.last){
        errorsStr += "\n";
      }
    }
    return errorsStr;
  }
}