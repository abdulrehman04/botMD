import 'package:bot_md/Auth/login.dart';
import 'package:bot_md/Dashboard/main_nav.dart';
import 'package:bot_md/onBoarding/on_boarding_1.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bot MD',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: OnBoarding1(),
      // home: FutureBuilder(
      //   initialData: FirebaseAuth.instance.currentUser,
      //   builder: (context, snapshot) {
      //     if (!snapshot.hasData) {
      //       return Login();
      //     } else {
      //       return MainNav();
      //     }
      //   },
      // ),
    );
  }
}

// class AssistantChat extends StatefulWidget {
//   const AssistantChat({Key? key}) : super(key: key);

//   @override
//   _AssistantChatState createState() => _AssistantChatState();
// }

// class _AssistantChatState extends State<AssistantChat> {
//   WatsonAssistantV2Credential credential = WatsonAssistantV2Credential(
//       username: "apikey",
//       version: "2019-02-28",
//       apikey: "mMjWaLQbbgq-GncYkNUmYuMh9K3VT3NU67mB1apXu5rr",
//       url:
//           "https://api.us-south.assistant.watson.cloud.ibm.com/instances/304cb930-c9ce-4e64-a096-42d12baad05f/v2/assistants/86ed92aa-02cb-4354-9bef-17b9def622aa/sessions/v2",
//       assistantID: "86ed92aa-02cb-4354-9bef-17b9def622aa");

//   WatsonAssistantContext watsonContext = WatsonAssistantContext(context: {});

//   late WatsonAssistantApiV2 assistant;
//   @override
//   void initState() {
//     super.initState();
//     start();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: [
//           MaterialButton(
//             onPressed: () async {
//               assistant.sendMessage("Hello", watsonContext).then((value) {
//                 print(value.resultText);
//               });
//             },
//             color: Colors.red,
//           ),
//         ],
//       ),
//     );
//   }

//   Future<void> start() async {
//     assistant = WatsonAssistantApiV2(watsonAssistantCredential: credential);
//   }
// }
