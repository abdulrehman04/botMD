import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants.dart';
import '../globals_.dart';

class SOSContacts extends StatefulWidget {
  const SOSContacts({Key? key}) : super(key: key);

  @override
  State<SOSContacts> createState() => _SOSContactsState();
}

class _SOSContactsState extends State<SOSContacts> {
  List sosContacts = [];

  RxList<DocumentSnapshot> searchResults = RxList([]);

  RxList chatsWithUserDetails = RxList([]);

  RxBool searchByName = RxBool(true);

  getAllUsers() {
    FirebaseFirestore.instance.collection("Users").get().then((value) {
      searchResults.value = value.docs;
      print(searchResults);
    });
  }

  @override
  void initState() {
    super.initState();
    getSOSUsers();
    getAllUsers();
  }

  getSOSUsers() {
    sosContacts.clear();
    currentUserData['sos_contacts'].forEach((e) {
      FirebaseFirestore.instance.collection("Users").doc(e).get().then((value) {
        setState(() {
          sosContacts.add(value);
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                                  text: "Search Users",
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
                                        borderRadius: BorderRadius.circular(50),
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
                                          FirebaseFirestore.instance
                                              .collection("Users")
                                              .where(
                                                  searchByName.value
                                                      ? "name"
                                                      : "email",
                                                  isGreaterThanOrEqualTo: str)
                                              .where(
                                                  searchByName.value
                                                      ? "name"
                                                      : "email",
                                                  isLessThanOrEqualTo:
                                                      str + "\uf8ff")
                                              .get()
                                              .then((value) {
                                            sstMain(() {
                                              searchResults.value = value.docs;
                                            });
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                  // Expanded(
                                  //   child: InkWell(
                                  //     onTap: () {
                                  //       showModalBottomSheet(
                                  //           context: context,
                                  //           shape: const RoundedRectangleBorder(
                                  //             borderRadius: BorderRadius.only(
                                  //               topLeft: Radius.circular(15),
                                  //               topRight: Radius.circular(15),
                                  //             ),
                                  //           ),
                                  //           builder: (context) {
                                  //             return StatefulBuilder(
                                  //                 builder: (context, sst) {
                                  //               return Padding(
                                  //                 padding:
                                  //                     const EdgeInsets.all(8.0),
                                  //                 child: Column(
                                  //                   crossAxisAlignment:
                                  //                       CrossAxisAlignment
                                  //                           .start,
                                  //                   children: [
                                  //                     const SizedBox(
                                  //                       height: 20,
                                  //                     ),
                                  //                     Padding(
                                  //                       padding:
                                  //                           const EdgeInsets
                                  //                               .only(left: 12),
                                  //                       child: montserratText(
                                  //                         text: "Filters",
                                  //                         color:
                                  //                             Colors.grey[800],
                                  //                         size: 23,
                                  //                         weight:
                                  //                             FontWeight.w500,
                                  //                         align:
                                  //                             TextAlign.start,
                                  //                       ),
                                  //                     ),
                                  //                     SizedBox(
                                  //                       height: 30,
                                  //                     ),
                                  //                     Row(
                                  //                       mainAxisAlignment:
                                  //                           MainAxisAlignment
                                  //                               .spaceBetween,
                                  //                       children: [
                                  //                         Padding(
                                  //                           padding:
                                  //                               const EdgeInsets
                                  //                                       .only(
                                  //                                   left: 12),
                                  //                           child:
                                  //                               montserratText(
                                  //                             text:
                                  //                                 "Search By:",
                                  //                             color: Colors
                                  //                                 .grey[800],
                                  //                             size: 20,
                                  //                             weight: FontWeight
                                  //                                 .w400,
                                  //                             align: TextAlign
                                  //                                 .start,
                                  //                           ),
                                  //                         ),
                                  //                         Container(
                                  //                           margin:
                                  //                               const EdgeInsets
                                  //                                       .only(
                                  //                                   right: 12),
                                  //                           decoration:
                                  //                               BoxDecoration(
                                  //                             color:
                                  //                                 Colors.white,
                                  //                             boxShadow: [
                                  //                               boxShad(
                                  //                                   2, 5, 10)
                                  //                             ],
                                  //                             borderRadius:
                                  //                                 BorderRadius
                                  //                                     .circular(
                                  //                               20,
                                  //                             ),
                                  //                           ),
                                  //                           child:
                                  //                               FlutterSwitch(
                                  //                             width: 90.0,
                                  //                             height: 35.0,
                                  //                             valueFontSize:
                                  //                                 15.0,
                                  //                             toggleSize: 30.0,
                                  //                             value:
                                  //                                 searchByName
                                  //                                     .value,
                                  //                             borderRadius:
                                  //                                 30.0,
                                  //                             padding: 8.0,
                                  //                             showOnOff: true,
                                  //                             activeText:
                                  //                                 "Name",
                                  //                             activeColor:
                                  //                                 primaryColor,
                                  //                             activeTextFontWeight:
                                  //                                 FontWeight
                                  //                                     .w400,
                                  //                             inactiveTextFontWeight:
                                  //                                 FontWeight
                                  //                                     .w400,
                                  //                             inactiveText:
                                  //                                 "Email",
                                  //                             onToggle: (val) {
                                  //                               sst(() {
                                  //                                 searchByName
                                  //                                         .value =
                                  //                                     val;
                                  //                               });
                                  //                             },
                                  //                           ),
                                  //                         ),
                                  //                       ],
                                  //                     ),
                                  //                     const SizedBox(
                                  //                       height: 22,
                                  //                     ),
                                  //                     ...[
                                  //                       {
                                  //                         'title': "All Users",
                                  //                         'subtitle':
                                  //                             "Search amoung all users"
                                  //                       },
                                  //                       {
                                  //                         'title':
                                  //                             "Quarantined",
                                  //                         'subtitle':
                                  //                             "Search amoung the users that are in quarantine"
                                  //                       },
                                  //                       {
                                  //                         'title':
                                  //                             "Same Day Quarantine",
                                  //                         'subtitle':
                                  //                             "Shows users that are on same day of quarantine"
                                  //                       }
                                  //                     ].map((e) {
                                  //                       return Column(
                                  //                         children: [
                                  //                           InkWell(
                                  //                             onTap: () {
                                  //                               sstMain(() {
                                  //                                 selectedFilter
                                  //                                         .value =
                                  //                                     e['title']!;
                                  //                               });
                                  //                               if (e['title'] ==
                                  //                                   "All Users") {
                                  //                                 getAllUsers();
                                  //                               } else if (e[
                                  //                                       'title'] ==
                                  //                                   "Quarantined") {
                                  //                                 getQuarantinedUsers();
                                  //                               } else {
                                  //                                 getSameDayUsers();
                                  //                               }
                                  //                               Get.back();
                                  //                             },
                                  //                             child: Container(
                                  //                               decoration:
                                  //                                   BoxDecoration(
                                  //                                 color: primaryColor.withOpacity(
                                  //                                     selectedFilter.value ==
                                  //                                             e['title']
                                  //                                         ? 0.3
                                  //                                         : 0.1),
                                  //                                 borderRadius:
                                  //                                     BorderRadius
                                  //                                         .circular(
                                  //                                             15),
                                  //                                 // boxShadow: [boxShad(5, 5, 5)],
                                  //                               ),
                                  //                               child: ListTile(
                                  //                                 title:
                                  //                                     montserratText(
                                  //                                   text: e[
                                  //                                       'title'],
                                  //                                   color: selectedFilter.value ==
                                  //                                           e[
                                  //                                               'title']
                                  //                                       ? primaryColor
                                  //                                       : Colors
                                  //                                           .black,
                                  //                                   align: TextAlign
                                  //                                       .start,
                                  //                                   weight:
                                  //                                       FontWeight
                                  //                                           .w600,
                                  //                                   size: 16,
                                  //                                 ),
                                  //                                 subtitle:
                                  //                                     montserratText(
                                  //                                   text: e[
                                  //                                       'subtitle'],
                                  //                                   color: selectedFilter.value ==
                                  //                                           e[
                                  //                                               'title']
                                  //                                       ? secondaryColor
                                  //                                       : Colors
                                  //                                           .grey,
                                  //                                   align: TextAlign
                                  //                                       .start,
                                  //                                   weight:
                                  //                                       FontWeight
                                  //                                           .w400,
                                  //                                   size: 13,
                                  //                                 ),
                                  //                               ),
                                  //                             ),
                                  //                           ),
                                  //                           SizedBox(
                                  //                             height: 7,
                                  //                           ),
                                  //                         ],
                                  //                       );
                                  //                     }).toList()
                                  //                   ],
                                  //                 ),
                                  //               );
                                  //             });
                                  //           });
                                  //     },
                                  //     child: Container(
                                  //       padding: const EdgeInsets.all(10),
                                  //       decoration: BoxDecoration(
                                  //         color: Colors.white,
                                  //         shape: BoxShape.circle,
                                  //         boxShadow: [
                                  //           boxShad(3, 5, 10),
                                  //         ],
                                  //       ),
                                  //       child: const Icon(
                                  //         Icons.filter_list_outlined,
                                  //       ),
                                  //     ),
                                  //   ),
                                  // )
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
                                      // checkChatExists(e);
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
                                    trailing: currentUserData['sos_contacts']
                                            .contains(e.id)
                                        ? InkWell(
                                            onTap: () {
                                              FirebaseFirestore.instance
                                                  .collection("Users")
                                                  .doc(currentUser.id)
                                                  .update({
                                                'sos_contacts':
                                                    FieldValue.arrayRemove(
                                                        [e.id]),
                                              }).then((value) {
                                                sstMain(() {});
                                                getSOSUsers();
                                              });
                                            },
                                            child: const Icon(
                                              Icons.check,
                                              color: Colors.lightGreen,
                                              size: 30,
                                            ),
                                          )
                                        : InkWell(
                                            onTap: () {
                                              FirebaseFirestore.instance
                                                  .collection("Users")
                                                  .doc(currentUser.id)
                                                  .update({
                                                'sos_contacts':
                                                    FieldValue.arrayUnion(
                                                        [e.id]),
                                              }).then((value) {
                                                sstMain(() {});
                                                getSOSUsers();
                                              });
                                            },
                                            child: const Icon(
                                              Icons.add,
                                              size: 30,
                                            ),
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
      body: SafeArea(
        child: Column(
          children: [
            gradientAppBar(context: context, title: "Emergency Contacts"),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: sosContacts.map((data) {
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
                        // Get.to(() => Chat(other: data, chat: e.id));
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
                }).toList(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
