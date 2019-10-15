import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_new_relic_app/model/application.dart';
import 'package:flutter_new_relic_app/services/webservice.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mockito/mockito.dart';

class MockClient extends Mock implements Client{}

const fakeResponse = {
  'applications' : [
    {"id" : 12345,
      "name" : "Test",
      "health_status" : "neutral",
      "reporting" : false
    }
  ]
};

main(){
  group(
    'load', (){
    test(
        'returns a list of ApplicationData if call completes successfully',
        () async{
          final client = MockClient();
          when(client.get(ApplicationData.all.url, headers: ApplicationData.all.headers))
              .thenAnswer((_) async => Response(json.encode(fakeResponse), 200));

          List<ApplicationData> result = List<ApplicationData>();

          await WebService()
              .load(ApplicationData.all, client)
              .then((data) => result.addAll(data));

          //expect(result.length, 1);
          expect(result[0].id, 12345);
          expect(result[0].name, 'Test');
          expect(result[0].health, 'neutral');
          expect(result[0].reporting, false);

    });
    test(
      'throws exception if response code is other than 200',
      () async{
        final client = MockClient();
        when(client.get(ApplicationData.all.url, headers: ApplicationData.all.headers))
            .thenAnswer((_) async => Response('Not found', 404));
        expect(WebService()
              .load(ApplicationData.all, client),
            throwsException
        );
      }
    );
  }
  );
}

