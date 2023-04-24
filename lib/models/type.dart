/// Class representing an ecospot's type object
class Type{

  final String id;
  String name;
  String color;
  String logoUrl;
  List<String> associatedSpots;

  Type({
    required this.id,
    required this.name,
    required this.color,
    required this.logoUrl,
    required this.associatedSpots
  });

}