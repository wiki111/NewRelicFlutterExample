import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_new_relic_app/services/webservice.dart';

class ApplicationData{
  final int id;
  final String name;
  final String health;
  final bool reporting;

  ApplicationData({this.id, this.name, this.health, this.reporting});

  factory ApplicationData.fromJson(Map<String, dynamic> json){
    return ApplicationData(
      id : json['id'],
      name : json['name'],
      health : json['health_status'],
      reporting: json['reporting']
    );
  }

  static Resource<List<ApplicationData>> all(String apiKey) {
    return Resource(
      url : 'https://api.eu.newrelic.com/v2/applications.json',
      headers: {'X-Api-Key' : apiKey},
      parse: (response){
        Map<String, dynamic> parsedJson = json.decode(response.body);
        var list = parsedJson['applications'] as List;
        return list.map((i) => ApplicationData.fromJson(i)).toList();
      }
    );
  }
}