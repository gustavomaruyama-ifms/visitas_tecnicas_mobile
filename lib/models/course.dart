class Course{
  String id;
  String name;

  Course({this.id, this.name});

  factory Course.fromJson(Map<String,dynamic>json){
    return Course(
      id : json['_id'],
      name: json['name']
    );
  }
}