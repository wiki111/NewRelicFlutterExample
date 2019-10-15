class Application{
  final int id;
  final String name;
  final String health;
  final bool reporting;

  Application({this.id, this.name, this.health, this.reporting});

  factory Application.fromJson(Map<String, dynamic> json){
    return Application(
      id : json['id'],
      name : json['name'],
      health : json['health_status'],
      reporting: json['reporting']
    );
  }
}