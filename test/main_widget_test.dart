import 'package:flutter/material.dart';
import 'package:flutter_new_relic_app/forms/api_form.dart';
import 'package:flutter_new_relic_app/main.dart';
import 'package:flutter_new_relic_app/services/webservice.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockWebService extends Mock implements WebService {}

main(){

    Widget buildTestableWidget(Widget widget) {
      return MediaQuery(data: MediaQueryData(), child: MaterialApp(home: widget));
    }
  
    testWidgets(
        'insert api key button navigates to api form',
        (WidgetTester tester) async {
          await tester.pumpWidget(MyApp());
          await tester.tap(find.byType(RaisedButton));
          await tester.pump();
          expect(find.byType(ApiForm), findsOneWidget);

    });
    testWidgets(
        'shows alert dialog at attempt of downloading data while there\'s no key',
        (WidgetTester tester) async{
          MockWebService mockWebService = MockWebService();
          await tester.pumpWidget(buildTestableWidget(NewRelicApplications(webService: mockWebService,)));
          await tester.pump();
          //Alert dialog shows at startup (because of initState)
          expect(find.byType(AlertDialog), findsOneWidget);
          expect(find.text('Missing API key'), findsOneWidget);
          //Dismiss initial dialog
          await tester.tap(find.byType(FlatButton));
          await tester.pump();
          //Tap refresh button
          await tester.tap(find.byKey(Key('refresh_btn')));
          await tester.pump();
          expect(find.byType(AlertDialog), findsOneWidget);
          expect(find.text('Missing API key'), findsOneWidget);
        }
    );
}