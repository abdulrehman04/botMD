import 'dart:async';

import 'package:bot_md/Dashboard/profile.dart';
import 'package:bot_md/Models/message.dart';
import 'package:bot_md/services/watson_assistant_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants.dart';
import '../globals_.dart';

class Chat extends StatefulWidget {
  const Chat({Key? key}) : super(key: key);

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  WatsonAssistantService bot = WatsonAssistantService();
  RxList<Message> messages = RxList([
    Message(
      data: {'type': 'text', 'response_text': "Hi", 'data': {}},
      time: "",
      other: true,
    ),
  ]);
  var sessionId = "";
  final ScrollController _scrollController = ScrollController();

  var inputController = TextEditingController();

  @override
  void initState() {
    super.initState();
    initialise();
    _scrollController.animateTo(1,
        duration: const Duration(milliseconds: 250), curve: Curves.ease);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(
          MediaQuery.of(context).size.height * 0.11,
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [primaryColor, secondaryColor],
              begin: Alignment.topLeft,
            ),
            boxShadow: [boxShad(5, 5, 25)],
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(25),
              bottomRight: Radius.circular(25),
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                top: height * 0.07,
                child: backButton,
              ),
              Positioned(
                top: height * 0.08,
                left: 20,
                right: 20,
                child: montserratText(
                  text: 'Bot MD',
                  color: Colors.white,
                  weight: FontWeight.w500,
                  size: 18,
                ),
              ),
            ],
          ),
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.all(15),
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            gradient: const LinearGradient(
              colors: [
                Color(0xff424242),
                Color(0xff2f2f2f),
              ],
            ),
          ),
          child: TextField(
            autofocus: true,
            controller: inputController,
            style: GoogleFonts.montserrat(
              color: Colors.white,
            ),
            onSubmitted: (text) async {
              messages.add(
                Message(
                  data: {
                    'type': 'text',
                    'response_text': text,
                    'data': {},
                  },
                  time: "",
                  other: false,
                ),
              );
              inputController.text = "";

              animateToBottom();
              bot.sendInput(text).then((value) {
                if (value['type'] == 'user_defined') {
                  Timer(const Duration(seconds: 2), () {
                    Get.back();
                    launchAction(
                      getPage(
                        value['value'],
                      ),
                    );
                  });
                  messages.add(
                    Message(
                      data: value,
                      time: "",
                      other: true,
                    ),
                  );
                } else {
                  messages.add(
                    Message(
                      data: value,
                      time: "",
                      other: true,
                    ),
                  );
                }
                animateToBottom();
              });
            },
            decoration: InputDecoration(
              hintText: "Type your message",
              hintStyle: GoogleFonts.montserrat(
                color: Colors.white,
              ),
              contentPadding: const EdgeInsets.fromLTRB(22, 12, 12, 12),
              suffix: Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blue,
                ),
                child: InkWell(
                  onTap: () {
                    // bot.createMySession();
                  },
                  child: const Icon(
                    Icons.mic,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50),
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Obx(() {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                ...(messages.map((e) {
                  return chatBubble(data: e, other: e.other);
                }).toList()),
                const SizedBox(
                  height: 80,
                )
              ],
            ),
          );
        }),
      ),
    );
  }

  chatBubble({data, bool other = true}) {
    return Row(
      mainAxisAlignment:
          other ? MainAxisAlignment.start : MainAxisAlignment.end,
      children: [
        other
            ? const CircleAvatar(
                backgroundImage: AssetImage('Assets/Bot Chat.png'),
              )
            : Container(),
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: width * .75),
          child: Container(
            margin: const EdgeInsets.all(15),
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              gradient: other
                  ? const LinearGradient(
                      colors: [
                        Color(0xff424242),
                        Color(0xff2f2f2f),
                      ],
                    )
                  : appGradient,
              boxShadow: [
                boxShad(5, 5, 25),
              ],
              borderRadius: BorderRadius.only(
                bottomLeft: other
                    ? const Radius.circular(0)
                    : const Radius.circular(25),
                bottomRight: other
                    ? const Radius.circular(25)
                    : const Radius.circular(0),
                topLeft: const Radius.circular(25),
                topRight: const Radius.circular(25),
              ),
            ),
            child: data.data['type'] == 'text'
                ? Column(
                    crossAxisAlignment: other
                        ? CrossAxisAlignment.start
                        : CrossAxisAlignment.end,
                    children: [
                      montserratText(
                        text: '${data.data['response_text']}',
                        size: 14,
                        color: Colors.white,
                        weight: FontWeight.w500,
                        align: TextAlign.start,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      montserratText(
                        text: '17:45',
                        color: Colors.white60,
                        size: 12,
                        weight: FontWeight.w300,
                      )
                    ],
                  )
                : data.data['type'] == 'user_defined'
                    ? Column(
                        crossAxisAlignment: other
                            ? CrossAxisAlignment.start
                            : CrossAxisAlignment.end,
                        children: [
                          montserratText(
                            text: '${data.data['response_text']}',
                            size: 14,
                            color: Colors.white,
                            weight: FontWeight.w500,
                            align: TextAlign.start,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          montserratText(
                            text: '17:45',
                            color: Colors.white60,
                            size: 12,
                            weight: FontWeight.w300,
                          )
                        ],
                      )
                    : Column(
                        crossAxisAlignment: other
                            ? CrossAxisAlignment.start
                            : CrossAxisAlignment.end,
                        children: [
                          montserratText(
                            text: '${data.data['title']}',
                            size: 14,
                            color: Colors.white,
                            weight: FontWeight.w500,
                            align: TextAlign.start,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Wrap(
                            children: data.data['options'].map<Widget>((e) {
                              return InkWell(
                                onTap: () {
                                  messages.add(
                                    Message(
                                      data: {
                                        'type': 'text',
                                        'response_text': e['value']['input']
                                            ['text'],
                                        'data': {},
                                      },
                                      time: "",
                                      other: false,
                                    ),
                                  );

                                  animateToBottom();
                                  bot
                                      .sendInput(e['value']['input']['text'])
                                      .then((value) {
                                    messages.add(
                                      Message(
                                        data: value,
                                        time: "",
                                        other: true,
                                      ),
                                    );
                                    animateToBottom();
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(60),
                                    border: Border.all(
                                      color: Colors.white,
                                    ),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 5,
                                    horizontal: 15,
                                  ),
                                  margin: const EdgeInsets.symmetric(
                                    vertical: 5,
                                    horizontal: 4,
                                  ),
                                  child: montserratText(
                                    text: e['label'],
                                    weight: FontWeight.w400,
                                    color: Colors.white,
                                    size: 13,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          montserratText(
                            text: '17:45',
                            color: Colors.white60,
                            size: 12,
                            weight: FontWeight.w300,
                          )
                        ],
                      ),
          ),
        ),
      ],
    );
  }

  Future<void> initialise() async {
    sessionId = (await bot.createMySession())!;
  }

  void animateToBottom() {
    _scrollController.animateTo(_scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 450), curve: Curves.ease);
  }

  void launchAction(page) {
    if (page['type'] == 'index') {
      currentIndex.value = page['value'];
    }
  }
}



// {
//   "output": {
//     "generic": [
//       {
//         "user_defined": {
//           "title": "Opening {$app_name}",
//           "value": "{$app_name}"
//         },
//         "response_type": "user_defined"
//       }
//     ]
//   }
// }