import 'package:flutter/material.dart';
import 'package:flutter_new_relic_app/model/application.dart';
import 'package:flutter_new_relic_app/services/webservice.dart';
import 'package:http/http.dart';

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

  final _applications = List<ApplicationData>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter & New Relic App'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _downloadApplicationData,
          )
        ],
      ),
      body: _buildList(),
    );
  }


  @override
  void initState() {
    super.initState();
    _downloadApplicationData();
  }

  void _downloadApplicationData(){
    _applications.clear();
    Client client = Client();
    WebService().load(ApplicationData.all, client).then((data) => {
      setState(() => {
        _applications.addAll(data)
      })
    });
  }


  Widget _buildList(){
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (context, index){
        return Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text('App id : ${_applications[index].id}'),
              )
            ),
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text('App name : ${_applications[index].name}'),
                )
            ),
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Health : ${_applications[index].health}'),
                )
            ),
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Reporting : ${_applications[index].reporting}'),
                )
            ),
            Divider(
              height: 10.0,
              color: Colors.blue[900],
              thickness: 1.0,
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
