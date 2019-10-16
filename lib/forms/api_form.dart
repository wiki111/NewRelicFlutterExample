import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ApiForm extends StatefulWidget{

  @override
  State createState() {
    return ApiFormState();
  }
}

class ApiFormState extends State<ApiForm>{

  final _formKey = GlobalKey<FormState>();
  String _apiKey;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Input API key'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.arrow_back),
            color: Colors.white,
            onPressed: () {Navigator.pop(context);},
          )
        ],
      ),
      body: _buildForm(),
    );
  }

  Widget _buildForm(){
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          TextFormField(
            validator: (value) {
              if(value.isEmpty || value.length != 47){
                return 'Please enter valid API key';
              }
              return null;
            },
            onSaved: (String value){
              _apiKey = value;
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: RaisedButton(
              onPressed: (){
                if(_formKey.currentState.validate()){
                  _formKey.currentState.save();
                  Navigator.pop(context, _apiKey);
                }
              },
              child: Text('Submit'),
            ),
          )
        ],
      )
    );
  }
}