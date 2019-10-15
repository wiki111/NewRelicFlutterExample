import 'package:http/http.dart';

class Resource<T> {
  final String url;
  final Map<String, String> headers;
  T Function(Response response) parse;

  Resource({this.url, this.headers, this.parse});
}

class WebService {
  Future<T> load<T>(Resource<T> resource, Client client) async{
    final response = await client.get(resource.url, headers: resource.headers);

    if(response.statusCode == 200){
      return resource.parse(response);
    }else{
      throw Exception('Failed to load data from New Relic !');
    }
  }
}