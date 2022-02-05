import 'dart:convert';

import 'package:bot_md/Models/message.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:ibm_watson_assistant/ibm_watson_assistant.dart';

class WatsonAssistantService {
  Dio dio = Dio();
  final String _username = "apikey";
  final String _key = "mMjWaLQbbgq-GncYkNUmYuMh9K3VT3NU67mB1apXu5rr";
  String sessionId = "";
  String assistantId = "86ed92aa-02cb-4354-9bef-17b9def622aa";
  String baseUrl =
      "https://api.us-south.assistant.watson.cloud.ibm.com/instances/304cb930-c9ce-4e64-a096-42d12baad05f/v2/assistants/";

  createMySession() {
    dio.options = BaseOptions(headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Basic ${base64Encode(utf8.encode('$_username:$_key'))}',
    });
    dio
        .post("$baseUrl$assistantId/sessions?version=2021-06-14",
            options: Options(headers: {
              'Content-Type': 'application/json',
              'Authorization':
                  'Basic ${base64Encode(utf8.encode('$_username:$_key'))}',
            }))
        .then((value) {
      sessionId = value.data['session_id'];
    });
  }

  Future sendInput(String input, {bool returnContext = true}) async {
    print(sessionId);
    final data = {
      'input': {
        'text': input,
        'options': {
          'return_context': returnContext,
        }
      }
    };

    final res = await dio.post(
      "$baseUrl$assistantId/sessions/$sessionId/message?version=2021-06-14",
      data: data,
    );
    print(res.data);
    if (res.data['output']['generic'][0]['response_type'] == 'text') {
      return {
        'type': 'text',
        'response_text': res.data['output']['generic'][0]['text'],
        'data': res.data
      };
    } else if (res.data['output']['generic'][0]['response_type'] ==
        'user_defined') {
      return {
        'type': 'user_defined',
        'response_text': res.data['output']['generic'][0]['user_defined']
            ['title'],
        'data': res.data,
        'value': res.data['output']['generic'][0]['user_defined']['value']
      };
    } else {
      return {
        'type': 'option',
        'title': res.data['output']['generic'][0]['title'],
        'options': res.data['output']['generic'][0]['options'],
        'data': res.data
      };
    }
  }
}
