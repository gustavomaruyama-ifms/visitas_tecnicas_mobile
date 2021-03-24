class ErrorMessage{
  String msg;

  ErrorMessage({this.msg});

  factory ErrorMessage.fromJson(Map<String,dynamic> json){
    return ErrorMessage(msg: json['msg']);
  }
  
}