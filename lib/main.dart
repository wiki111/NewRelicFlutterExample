import 'package:flutter/material.dart';
import 'package:flutter_new_relic_app/forms/api_form.dart';
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
  String _apiKey;

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
      body: Column(
        children: <Widget>[
            Expanded(
              child: _buildList(),
            ),
            RaisedButton(
              child: Text('Input API key'),
              color: Colors.brown[300],
              onPressed: () {_showFormGetApiKey(context);},
            )
        ],
      ),
    );
  }

    _showFormGetApiKey(BuildContext context) async{
    final result = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ApiForm())
    );
    _apiKey = result;
    _downloadApplicationData();
  }

  @override
  void initState() {
    super.initState();
  }

  void _downloadApplicationData(){
    _applications.clear();
    Client client = Client();
    if(_apiKey != null){
      try{
        WebService().load(ApplicationData.all(_apiKey), client).then((data) => {
          setState(() => {
            _applications.addAll(data)
          })
        });
      }catch(e){
        showDialog(context: context,
        builder: (BuildContext context) =>
        _buildAlertDialog(
            'Connection error.',
            'Unable to fetch data from New Relic API. '
            + 'Most probable cause is invalid API key. '
            + 'Please try to input API key again.')
        );
      }

    }else{
      showDialog(
        context: context,
        builder: (BuildContext context) =>
            _buildAlertDialog(
                "Missing API key",
                "You have to specify an API key "
                + "to download data from New Relic API")
      );
    }
  }

  Widget _buildAlertDialog(String title, String message){
    return new AlertDialog(
      title: Text(title),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(message)
        ],
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: (){Navigator.of(context).pop();},
          child: Text('Okay.'),
      )
      ],
    );
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
