class Coordinate{
  
  final String city;
  final String state;
  final double latitude;
  final double longitude;

   const Coordinate({this.city,this.state,this.latitude,this.longitude});

   factory Coordinate.fromJson(var json){
     return Coordinate(
       city : json['city'] as String,
       state : json['state'] as String,
       latitude: json['latitude'] as double,
       longitude: json['longitude'] as double,
     );
   }
}