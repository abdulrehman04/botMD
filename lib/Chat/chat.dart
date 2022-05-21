import 'dart:io';

import 'package:bot_md/Models/message.dart';
import 'package:bot_md/constants.dart';
import 'package:bot_md/services/watson_assistant_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../globals_.dart';

class Chat extends StatefulWidget {
  late DocumentSnapshot<Map> otherUser;
  late String? chatID;

  Chat({Key? key, other, chat}) : super(key: key) {
    otherUser = other;
    this.chatID = chat;
  }

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  WatsonAssistantService bot = WatsonAssistantService();
  RxList<Message> messages = RxList([]);
  final ScrollController _scrollController = ScrollController();

  late File file;
  RxBool updatingImage = RxBool(false);
  var inputController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.chatID != null) {
      readPrevChats();
    }
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
                  text: widget.otherUser.get("name"),
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
              sendMessage();
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
                  onTap: () async {
                    getGalleryImage(context);
                  },
                  child: const Icon(
                    Icons.image,
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
            ? CircleAvatar(
                backgroundColor: Colors.white,
                backgroundImage: NetworkImage(
                  widget.otherUser.get('image') ??
                      "https://www.pngall.com/wp-content/uploads/5/User-Profile-PNG.png",
                ),
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
                        text: '${data.data['data']}',
                        size: 14,
                        color: Colors.white,
                        weight: FontWeight.w500,
                        align: TextAlign.start,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      montserratText(
                        text: data.time,
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
                    : data.data['type'] == 'image'
                        ? Column(
                            crossAxisAlignment: other
                                ? CrossAxisAlignment.start
                                : CrossAxisAlignment.end,
                            children: [
                              Image.network('${data.data['data']}'),
                              // montserratText(
                              //   text: '${data.data['data']}',
                              //   size: 14,
                              //   color: Colors.white,
                              //   weight: FontWeight.w500,
                              //   align: TextAlign.start,
                              // ),
                              const SizedBox(
                                height: 10,
                              ),
                              montserratText(
                                text: data.time,
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
                                      // bot
                                      //     .sendInput(e['value']['input']['text'])
                                      //     .then((value) {
                                      //   messages.add(
                                      //     Message(
                                      //       data: value,
                                      //       time: "",
                                      //       other: true,
                                      //     ),
                                      //   );
                                      //   animateToBottom();
                                      // });
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

  void animateToBottom() {
    _scrollController.animateTo(_scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 450), curve: Curves.ease);
  }

  void readPrevChats() {
    FirebaseFirestore.instance
        .collection("Chats")
        .doc(widget.chatID!)
        .collection("messages")
        .orderBy('time', descending: false)
        .snapshots()
        .listen((event) {
      print(event.docs);
      messages.value = [];
      event.docs.forEach((element) {
        messages.value.add(Message(
            data: {
              'data': element['data'],
              'type': element['type'],
            },
            time: DateFormat('hh:mm a').format(element['time'].toDate()),
            other: element['from'] == currentUser.id ? false : true));
      });
      _scrollController.animateTo(1,
          duration: const Duration(milliseconds: 250), curve: Curves.ease);
    });
  }

  void sendMessage({type = 'text', image}) {
    if (widget.chatID == null) {
      FirebaseFirestore.instance.collection("Chats").add({
        'users': [widget.otherUser.id, currentUser.id]
      }).then((chat) {
        FirebaseFirestore.instance
            .collection("Chats")
            .doc(chat.id)
            .collection("messages")
            .add(type == 'text'
                ? {
                    'data': inputController.text.trim(),
                    'time': DateTime.now(),
                    'type': 'text',
                    'from': currentUser.id,
                  }
                : {
                    'data': image,
                    'time': DateTime.now(),
                    'type': 'image',
                    'from': currentUser.id,
                  })
            .then((_) {
          if (widget.otherUser.data()!['token'] != null) {
            sendNotif(
              currentUserData['name'],
              inputController.text,
              widget.otherUser.get("token"),
            );
          }
          widget.chatID = chat.id;
          readPrevChats();
          inputController.text = "";
          animateToBottom();
        });
      });
    } else {
      FirebaseFirestore.instance
          .collection("Chats")
          .doc(widget.chatID!)
          .collection("messages")
          .add(type == 'text'
              ? {
                  'data': inputController.text.trim(),
                  'time': DateTime.now(),
                  'type': 'text',
                  'from': currentUser.id,
                }
              : {
                  'data': image,
                  'time': DateTime.now(),
                  'type': 'image',
                  'from': currentUser.id,
                })
          .then((_) {
        if (widget.otherUser.data()!['token'] != null) {
          sendNotif(
            currentUserData['name'],
            inputController.text,
            widget.otherUser.get("token"),
          );
        }
        inputController.text = "";
        animateToBottom();
      });
    }
  }

  Future getGalleryImage(context) async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      file = File(pickedFile.path);
      cropper(context);
    } else {
      print('No image selected.');
    }
  }

  cropper(context) async {
    await ImageCropper()
        .cropImage(
            sourcePath: file.path,
            aspectRatioPresets: [
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio16x9
            ],
            androidUiSettings: const AndroidUiSettings(
                toolbarTitle: 'Crop',
                toolbarColor: Colors.white,
                toolbarWidgetColor: Colors.black,
                initAspectRatio: CropAspectRatioPreset.original,
                lockAspectRatio: false),
            iosUiSettings: const IOSUiSettings(
              minimumAspectRatio: 1.0,
            ))
        .then((value) async {
      updatingImage.value = true;
      var ref = await FirebaseStorage.instance
          .ref()
          .child('${value!.path}${DateTime.now()}');
      var upload = await ref.putFile(value);

      await ref.getDownloadURL().then((value) {
        sendMessage(type: 'image', image: value);
      });
    });
  }
}
