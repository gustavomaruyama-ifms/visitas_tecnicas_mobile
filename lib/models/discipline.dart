class Discipline{
  String id;
  String name;
  String course;

  Discipline({this.id, this.name, this.course});

  factory Discipline.fromJson(Map<String,dynamic> json){
    return Discipline(
      id: json['_id'],
      name: json['name'],
      course: json['course']
    );

  }

  Map<String, String> toJson() {
    return {
      '_id': id
    };
  }
}