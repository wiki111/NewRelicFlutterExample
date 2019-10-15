import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_new_relic_app/model/application.dart';
import 'package:http/http.dart' as http;


void main() => runApp(MyApp());

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "New Relic & Flutter",
      theme: ThemeData(
        primaryColor: Colors.brown[300]
      ),
      home: NewRelicApplications(),
    );
  }
}

class NewRelicApplicationsState extends State<NewRelicApplications>{

  final _applications = List<Application>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter & New Relic App'),
      ),
      body: FutureBuilder<List<Application>>(
        future: fetchApplicationsData(),
        builder: (context, snapshot){
          if(snapshot.hasData){
            _applications.clear();
            _applications.addAll(snapshot.data);
            return _buildApplicationsList();
          }else if(snapshot.hasError){
            return Text("${snapshot.error}");
          }

          return CircularProgressIndicator();
        },
      ),
    );
  }

  Future<List<Application>> fetchApplicationsData() async{
    Map<String, String> headers = {
      'X-Api-Key' : 'b50ba7909bbe16d17a7412848280be9f350f10f39790d72'
    };

    final response = await http.get('https://api.eu.newrelic.com/v2/applications.json', headers: headers);

    if(response.statusCode == 200){
      Map<String, dynamic> parsedJson = json.decode(response.body);
      var list = parsedJson['applications'] as List;
      return list.map((i) => Application.fromJson(i)).toList();
    }else{
      throw Exception('Couldn\' fetch data from New Relic');
    }
  }

  Widget _buildApplicationsList(){
    return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemBuilder: (context, index){
          return Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('App id : ${_applications[index].id}'),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('App name : ${_applications[index].name}'),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Health : ${_applications[index].health}'),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Reporting : ${_applications[index].reporting}'),
              ),
              Divider(
                height: 3.0,
                color: Colors.green[200],
              )
            ],
          );
        },
      itemCount: _applications.length,
    );
  }
}

class NewRelicApplications extends StatefulWidget{
  @override
  State createState() => NewRelicApplicationsState();
}
