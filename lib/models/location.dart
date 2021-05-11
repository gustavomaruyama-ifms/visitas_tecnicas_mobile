class Location{
  String cep;
  String uf;
  String localidade;
  String  logradouro;

  Location({this.cep, this.uf, this.localidade, this.logradouro});

  factory Location.fromJson(Map<String,dynamic> json){
    return Location(cep:json['cep'],uf: json['uf'], localidade: json['localidade'], logradouro: json['logradouro']);
  }
}