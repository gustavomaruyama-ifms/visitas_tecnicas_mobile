class Sector{
   String id;
   String name;

   Sector({this.id, this.name});

   factory Sector.fromJson(Map<String,dynamic> json){
     return Sector(id:json["_id"], name: json["name"]);
   }
}