import 'dart:async';

import 'package:bot_md/Auth/login.dart';
import 'package:bot_md/Auth/signup.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../Models/message.dart';
import '../constants.dart';
import '../globals_.dart';
import '../services/watson_assistant_service.dart';

class OnBoardingChat extends StatefulWidget {
  const OnBoardingChat({Key? key}) : super(key: key);

  @override
  State<OnBoardingChat> createState() => _OnBoardingChatState();
}

class _OnBoardingChatState extends State<OnBoardingChat> {
  WatsonAssistantService bot = WatsonAssistantService();
  SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = '';
  bool listening = false;
  RxDouble animHeight = RxDouble(35);
  Rx micColor = Rx(Colors.blue);
  late Timer timer;
  String name = "";

  RxList<Message> messages = RxList([
    Message(
      data: {'type': 'text', 'response_text': "Hi", 'data': {}},
      time: "",
      other: true,
    ),
    Message(
      data: {
        'type': 'text',
        'response_text': "This is BotMD, your virtual friend",
        'data': {}
      },
      time: "",
      other: true,
    ),
    Message(
      data: {
        'type': 'text',
        'response_text': "But first things first",
        'data': {}
      },
      time: "",
      other: true,
    ),
  ]);

  startAnimation() {
    timer = Timer.periodic(const Duration(seconds: 1), (time) {
      if (animHeight.value == 35) {
        animHeight.value = 45;
        micColor.value = primaryColor;
      } else {
        animHeight.value = 35;
        micColor.value = Colors.blue;
      }
    });
  }

  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  void _startListening() async {
    print("started");
    startAnimation();
    listening = true;
    await _speechToText.listen(onResult: _onSpeechResult);
    setState(() {});
  }

  void _stopListening() async {
    print("stopped");
    listening = false;
    micColor.value = Colors.blue;
    timer.cancel();
    animHeight.value = 35;
    await _speechToText.stop();
    setState(() {});
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _lastWords = result.recognizedWords;
      inputController.text = _lastWords;
    });
  }

  final ScrollController _scrollController = ScrollController();

  var inputController = TextEditingController();

  @override
  void initState() {
    super.initState();
    initialise();
    _initSpeech();
    Timer(Duration(seconds: 2), () {
      _scrollController.animateTo(1,
          duration: const Duration(milliseconds: 250), curve: Curves.ease);
    });
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
                value.forEach((e) {
                  print(e);
                  if (e['data']['output']['intents'].length != 0 &&
                      e['data']['output']['intents'][0]['intent'] ==
                          "Get_Name") {
                    name = e['data']['output']['entities'][0]['value'];
                    print(name);
                  }
                  if (e['type'] == 'user_defined' &&
                      e['response_text'] != "Symptom Result") {
                    Timer(const Duration(seconds: 2), () {
                      Get.back();
                      launchAction(
                        getPage(
                          e[0]['value'],
                        ),
                        e[0]['value'],
                      );
                    });
                  } else if (e['response_text'] == "Aha! Logging you in then") {
                    Timer(const Duration(seconds: 2), () {
                      Get.offAll(() => const Login());
                    });
                  } else if (e['response_text'] == "Then let's sign you up!") {
                    bot.sendInput("open signup").then((value) {
                      print("My data: $value");
                      if (value[0]['type'] == 'user_defined' &&
                          value[0]['response_text'] != "Symptom Result") {
                        Timer(const Duration(seconds: 2), () {
                          launchAction(
                            getPage(
                              value[0]['value'],
                            ),
                            value[0]['value'],
                          );
                        });
                      }
                    });
                  }
                  messages.add(
                    Message(
                      data: e,
                      time: "",
                      other: true,
                    ),
                  );
                });
                animateToBottom();
              });
            },
            decoration: InputDecoration(
              hintText: "Type your message",
              hintStyle: GoogleFonts.montserrat(
                color: Colors.white,
              ),
              contentPadding: const EdgeInsets.fromLTRB(22, 12, 12, 12),
              suffix: Obx(() {
                return AnimatedContainer(
                  height: animHeight.value,
                  width: animHeight.value,
                  duration: const Duration(milliseconds: 400),
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: micColor.value,
                  ),
                  child: InkWell(
                    onTap: () {
                      if (!listening) {
                        _startListening();
                      } else {
                        _stopListening();
                      }
                    },
                    child: const Icon(
                      Icons.mic,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                );
              }),
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

  makeSymptomResults(data, other, result) {
    return Column(
      crossAxisAlignment:
          other ? CrossAxisAlignment.start : CrossAxisAlignment.end,
      children: [
        montserratText(
          text: 'Your COVID severity is: $result',
          size: 14,
          color: Colors.white,
          weight: FontWeight.w500,
          align: TextAlign.start,
        ),
        const SizedBox(
          height: 10,
        ),
        montserratText(
          text: result == "Moderate" || result == "Severe"
              ? 'Navigate to nearest COVID labs?'
              : "Open diets and remedies?",
          size: 14,
          color: Colors.white,
          weight: FontWeight.w500,
          align: TextAlign.start,
        ),
        const SizedBox(
          height: 10,
        ),
        result == "Moderate" || result == "Severe"
            ? Row(
                children: [
                  InkWell(
                    onTap: () {
                      Get.back();
                      currentIndex.value = 2;
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
                        text: "Yes",
                        weight: FontWeight.w400,
                        color: Colors.white,
                        size: 13,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      messages.add(
                        Message(
                          data: {
                            'type': 'text',
                            'response_text':
                                "Okay, but I suggest you take a COVID test",
                            'data': {},
                          },
                          time: "",
                          other: true,
                        ),
                      );
                      animateToBottom();
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
                        text: "No",
                        weight: FontWeight.w400,
                        color: Colors.white,
                        size: 13,
                      ),
                    ),
                  ),
                ],
              )
            : Row(
                children: [
                  InkWell(
                    onTap: () {
                      Get.back();
                      currentIndex.value = 1;
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
                        text: "Yes",
                        weight: FontWeight.w400,
                        color: Colors.white,
                        size: 13,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      messages.add(
                        Message(
                          data: {
                            'type': 'text',
                            'response_text':
                                "Okay, just take some good diets and you'll be good",
                            'data': {},
                          },
                          time: "",
                          other: true,
                        ),
                      );
                      animateToBottom();
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
                        text: "No",
                        weight: FontWeight.w400,
                        color: Colors.white,
                        size: 13,
                      ),
                    ),
                  ),
                ],
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
                    ? (data.data['response_text'] == 'Symptom Result'
                        ? makeSymptomResults(
                            data,
                            other,
                            data.data['data']['output']['generic'][0]
                                ['user_defined']['value']['result'])
                        : Column(
                            crossAxisAlignment: other
                                ? CrossAxisAlignment.start
                                : CrossAxisAlignment.end,
                            children: [
                              montserratText(
                                text: '${data.data['type']}',
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
                          ))
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
                                    value.forEach((e) {
                                      messages.add(
                                        Message(
                                          data: e,
                                          time: "",
                                          other: true,
                                        ),
                                      );
                                    });
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
    await bot.createMySession();
    Timer(Duration(seconds: 5), () {
      bot.sendInput('Get name for signup').then((value) {
        print(value);
        value.forEach((e) {
          messages.add(
            Message(
              data: e,
              time: "",
              other: true,
            ),
          );
        });
        animateToBottom();
      });
    });
  }

  void animateToBottom() {
    Timer(Duration(milliseconds: 250), () {
      _scrollController.animateTo(_scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 450), curve: Curves.ease);
    });
  }

  void launchAction(page, data) {
    if (page['type'] == 'index') {
      currentIndex.value = page['value'];
    } else if (page['type'] == "page") {
      if (data == 'signup') {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Signup(name)));
      } else {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => page['value']));
      }
    }
  }
}
