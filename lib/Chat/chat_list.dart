import 'package:bot_md/Chat/chat.dart';
import 'package:bot_md/constants.dart';
import 'package:bot_md/globals_.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatList extends StatefulWidget {
  ChatList({Key? key}) : super(key: key);

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  RxList<DocumentSnapshot> users = RxList([]);

  RxList<DocumentSnapshot> searchResults = RxList([]);

  RxList<DocumentSnapshot> previousChatsWithUsers = RxList([]);

  RxString selectedFilter = RxString("All Users");

  RxList chatsWithUserDetails = RxList([]);

  RxBool searchByName = RxBool(true);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllUsers();
    getPreviousChatUsers();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          backgroundColor: primaryColor,
          onPressed: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              builder: (context) {
                return StatefulBuilder(builder: (context, sstMain) {
                  return DraggableScrollableSheet(
                    snap: true,
                    expand: false,
                    initialChildSize: 0.85,
                    minChildSize: 0.31,
                    maxChildSize: 0.9,
                    builder: (context, cont) {
                      return SingleChildScrollView(
                        controller: cont,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Obx(() {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 20,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 18),
                                  child: montserratText(
                                    text: selectedFilter.value,
                                    color: Colors.grey[800],
                                    size: 23,
                                    weight: FontWeight.w500,
                                    align: TextAlign.start,
                                  ),
                                ),
                                const SizedBox(
                                  height: 22,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 4,
                                      child: Container(
                                        height: 40,
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 7),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          gradient: const LinearGradient(
                                            colors: [
                                              Color(0xff424242),
                                              Color(0xff2f2f2f),
                                            ],
                                          ),
                                        ),
                                        child: TextField(
                                          // controller: inputController,
                                          style: GoogleFonts.montserrat(
                                            color: Colors.white,
                                          ),

                                          decoration: InputDecoration(
                                            hintText: "Search",
                                            hintStyle: GoogleFonts.montserrat(
                                              color: Colors.white,
                                            ),
                                            contentPadding:
                                                const EdgeInsets.fromLTRB(
                                                    22, 0, 12, 0),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                            ),
                                          ),
                                          onChanged: (str) {
                                            if (selectedFilter == "All Users") {
                                              FirebaseFirestore.instance
                                                  .collection("Users")
                                                  .where(
                                                      searchByName.value
                                                          ? "name"
                                                          : "email",
                                                      isGreaterThanOrEqualTo:
                                                          str)
                                                  .where(
                                                      searchByName.value
                                                          ? "name"
                                                          : "email",
                                                      isLessThanOrEqualTo:
                                                          str + "\uf8ff")
                                                  .get()
                                                  .then((value) {
                                                sstMain(() {
                                                  searchResults.value =
                                                      value.docs;
                                                });
                                              });
                                            } else if (selectedFilter ==
                                                "Same Day Quarantine") {
                                              print("change");
                                              FirebaseFirestore.instance
                                                  .collection("Users")
                                                  .where("isolatedOn",
                                                      isEqualTo:
                                                          currentUserData[
                                                              'isolatedOn'])
                                                  .where(
                                                      searchByName.value
                                                          ? "name"
                                                          : "email",
                                                      isGreaterThanOrEqualTo:
                                                          str)
                                                  .where(
                                                      searchByName.value
                                                          ? "name"
                                                          : "email",
                                                      isLessThanOrEqualTo:
                                                          str + "\uf8ff")
                                                  .get()
                                                  .then((value) {
                                                print(value.docs.length);
                                                sstMain(() {
                                                  searchResults.value =
                                                      value.docs;
                                                });
                                              });
                                            } else {
                                              FirebaseFirestore.instance
                                                  .collection("Users")
                                                  .where('isolated',
                                                      isEqualTo: true)
                                                  .where(
                                                      searchByName.value
                                                          ? "name"
                                                          : "email",
                                                      isGreaterThanOrEqualTo:
                                                          str)
                                                  .where(
                                                      searchByName.value
                                                          ? "name"
                                                          : "email",
                                                      isLessThanOrEqualTo:
                                                          str + "\uf8ff")
                                                  .get()
                                                  .then((value) {
                                                sstMain(() {
                                                  searchResults.value =
                                                      value.docs;
                                                });
                                              });
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: InkWell(
                                        onTap: () {
                                          showModalBottomSheet(
                                              context: context,
                                              shape:
                                                  const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(15),
                                                  topRight: Radius.circular(15),
                                                ),
                                              ),
                                              builder: (context) {
                                                return StatefulBuilder(
                                                    builder: (context, sst) {
                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        const SizedBox(
                                                          height: 20,
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 12),
                                                          child: montserratText(
                                                            text: "Filters",
                                                            color: Colors
                                                                .grey[800],
                                                            size: 23,
                                                            weight:
                                                                FontWeight.w500,
                                                            align:
                                                                TextAlign.start,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 30,
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left: 12),
                                                              child:
                                                                  montserratText(
                                                                text:
                                                                    "Search By:",
                                                                color: Colors
                                                                    .grey[800],
                                                                size: 20,
                                                                weight:
                                                                    FontWeight
                                                                        .w400,
                                                                align: TextAlign
                                                                    .start,
                                                              ),
                                                            ),
                                                            Container(
                                                              margin:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      right:
                                                                          12),
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Colors
                                                                    .white,
                                                                boxShadow: [
                                                                  boxShad(
                                                                      2, 5, 10)
                                                                ],
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                  20,
                                                                ),
                                                              ),
                                                              child:
                                                                  FlutterSwitch(
                                                                width: 90.0,
                                                                height: 35.0,
                                                                valueFontSize:
                                                                    15.0,
                                                                toggleSize:
                                                                    30.0,
                                                                value:
                                                                    searchByName
                                                                        .value,
                                                                borderRadius:
                                                                    30.0,
                                                                padding: 8.0,
                                                                showOnOff: true,
                                                                activeText:
                                                                    "Name",
                                                                activeColor:
                                                                    primaryColor,
                                                                activeTextFontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                inactiveTextFontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                inactiveText:
                                                                    "Email",
                                                                onToggle:
                                                                    (val) {
                                                                  sst(() {
                                                                    searchByName
                                                                            .value =
                                                                        val;
                                                                  });
                                                                },
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                          height: 22,
                                                        ),
                                                        ...[
                                                          {
                                                            'title':
                                                                "All Users",
                                                            'subtitle':
                                                                "Search amoung all users"
                                                          },
                                                          {
                                                            'title':
                                                                "Quarantined",
                                                            'subtitle':
                                                                "Search amoung the users that are in quarantine"
                                                          },
                                                          {
                                                            'title':
                                                                "Same Day Quarantine",
                                                            'subtitle':
                                                                "Shows users that are on same day of quarantine"
                                                          }
                                                        ].map((e) {
                                                          return Column(
                                                            children: [
                                                              InkWell(
                                                                onTap: () {
                                                                  sstMain(() {
                                                                    selectedFilter
                                                                            .value =
                                                                        e['title']!;
                                                                  });
                                                                  if (e['title'] ==
                                                                      "All Users") {
                                                                    getAllUsers();
                                                                  } else if (e[
                                                                          'title'] ==
                                                                      "Quarantined") {
                                                                    getQuarantinedUsers();
                                                                  } else {
                                                                    getSameDayUsers();
                                                                  }
                                                                  Get.back();
                                                                },
                                                                child:
                                                                    Container(
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: primaryColor.withOpacity(selectedFilter.value ==
                                                                            e['title']
                                                                        ? 0.3
                                                                        : 0.1),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            15),
                                                                    // boxShadow: [boxShad(5, 5, 5)],
                                                                  ),
                                                                  child:
                                                                      ListTile(
                                                                    title:
                                                                        montserratText(
                                                                      text: e[
                                                                          'title'],
                                                                      color: selectedFilter.value ==
                                                                              e['title']
                                                                          ? primaryColor
                                                                          : Colors.black,
                                                                      align: TextAlign
                                                                          .start,
                                                                      weight: FontWeight
                                                                          .w600,
                                                                      size: 16,
                                                                    ),
                                                                    subtitle:
                                                                        montserratText(
                                                                      text: e[
                                                                          'subtitle'],
                                                                      color: selectedFilter.value ==
                                                                              e['title']
                                                                          ? secondaryColor
                                                                          : Colors.grey,
                                                                      align: TextAlign
                                                                          .start,
                                                                      weight: FontWeight
                                                                          .w400,
                                                                      size: 13,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                height: 7,
                                                              ),
                                                            ],
                                                          );
                                                        }).toList()
                                                      ],
                                                    ),
                                                  );
                                                });
                                              });
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle,
                                            boxShadow: [
                                              boxShad(3, 5, 10),
                                            ],
                                          ),
                                          child: const Icon(
                                            Icons.filter_list_outlined,
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 25,
                                ),
                                ...searchResults.value.map((e) {
                                  return Container(
                                    margin: const EdgeInsets.only(bottom: 12),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.white,
                                      boxShadow: [
                                        boxShad(0, 5, 10, opacity: 0.15),
                                      ],
                                    ),
                                    child: ListTile(
                                      onTap: () {
                                        checkChatExists(e);
                                      },
                                      leading: CircleAvatar(
                                        radius: 30,
                                        backgroundColor: Colors.white,
                                        backgroundImage: NetworkImage(
                                          e['image'] ??
                                              "https://www.pngall.com/wp-content/uploads/5/User-Profile-PNG.png",
                                        ),
                                      ),
                                      title: montserratText(
                                        text: e['name'],
                                        color: Colors.black,
                                        align: TextAlign.start,
                                        size: 17,
                                      ),
                                      subtitle: montserratText(
                                        text: e['email'],
                                        size: 13,
                                        align: TextAlign.start,
                                        color: Colors.grey[500],
                                        weight: FontWeight.w400,
                                      ),
                                      trailing: const Icon(
                                        Icons.navigate_next_rounded,
                                        size: 30,
                                      ),
                                    ),
                                  );
                                }).toList()
                              ],
                            );
                          }),
                        ),
                      );
                    },
                  );
                });
              },
            );
          },
        ),
        body: Column(
          children: [
            gradientAppBar(context: context, title: "Chats"),
            Padding(
              padding: const EdgeInsets.only(top: 15, left: 10, right: 10),
              child: Obx(() {
                return chats.value.length == 0
                    ? Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 45),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              montserratText(
                                text: "No Messages Here!",
                                size: 16,
                                color: Colors.grey[700],
                                weight: FontWeight.w400,
                              ),
                              const SizedBox(
                                height: 7,
                              ),
                              montserratText(
                                text:
                                    "Chat with anyone and all your messages will appear here!",
                                size: 13,
                                color: Colors.grey[500],
                                weight: FontWeight.w300,
                              ),
                            ],
                          ),
                        ),
                      )
                    : Column(
                        children: chats.value.map((e) {
                          int myIndex = e.get('users').indexOf(currentUser.id);
                          return StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection("Users")
                                .doc(myIndex == 0
                                    ? e.get('users')[1]
                                    : e.get('users')[0])
                                .snapshots(),
                            builder: (context, snap) {
                              if (!snap.hasData) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              DocumentSnapshot data =
                                  snap.data as DocumentSnapshot<Object?>;

                              // return Text("OO{");
                              return Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white,
                                  boxShadow: [
                                    boxShad(0, 5, 10, opacity: 0.15),
                                  ],
                                ),
                                child: ListTile(
                                  onTap: () {
                                    Get.to(() => Chat(other: data, chat: e.id));
                                  },
                                  leading: CircleAvatar(
                                    radius: 30,
                                    backgroundColor: Colors.white,
                                    backgroundImage: NetworkImage(
                                      data.get('image') ??
                                          "https://www.pngall.com/wp-content/uploads/5/User-Profile-PNG.png",
                                    ),
                                  ),
                                  title: montserratText(
                                    text: data.get('name'),
                                    color: Colors.black,
                                    align: TextAlign.start,
                                    size: 17,
                                  ),
                                  subtitle: montserratText(
                                    text: data.get('email'),
                                    size: 13,
                                    align: TextAlign.start,
                                    color: Colors.grey[500],
                                    weight: FontWeight.w400,
                                  ),
                                  trailing: const Icon(
                                    Icons.navigate_next_rounded,
                                    size: 30,
                                  ),
                                ),
                              );
                            },
                          );
                        }).toList(),
                      );
              }),
            )
          ],
        ),
      ),
    );
  }

  getAllUsers() {
    FirebaseFirestore.instance.collection("Users").get().then((value) {
      searchResults.value = value.docs;
      print(searchResults);
    });
  }

  getQuarantinedUsers() {
    FirebaseFirestore.instance
        .collection("Users")
        .where('isolated', isEqualTo: true)
        .get()
        .then((value) {
      searchResults.value = value.docs;
      print(searchResults);
    });
  }

  getSameDayUsers() {
    FirebaseFirestore.instance
        .collection("Users")
        .where("isolatedOn", isEqualTo: currentUserData['isolatedOn'])
        .get()
        .then((value) {
      searchResults.value = value.docs;
      print(searchResults);
    });
  }

  void checkChatExists(DocumentSnapshot<Object?> e) {
    if (chats.value.length == 0) {
      print("eedar");
      Get.to(() => Chat(
            chat: null,
            other: e,
          ));
    } else {
      print("Ni tha");
      bool found = false;
      chats.value.forEach((element) {
        if (element.get("users").contains(e.id)) {
          found = true;
          Get.to(
            () => Chat(
              chat: element.id,
              other: e,
            ),
          );
        }
      });
      if (found == false) {
        Get.to(
          () => Chat(
            chat: null,
            other: e,
          ),
        );
      }
    }
  }

  void getPreviousChatUsers() {
    print("Heree");
    print("Chats are: ${chats.value}");
    chats.value.forEach((element) {
      int myIndex = element.get('users').indexOf(currentUser.id);
      FirebaseFirestore.instance
          .collection("Users")
          .doc(myIndex == 0 ? element.get('users')[1] : element.get('users')[0])
          .get()
          .then((value) {
        chatsWithUserDetails.value.add({'user': value, 'chat': element});
      });
    });
  }
}
