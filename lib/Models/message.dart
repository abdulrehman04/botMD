class Message {
  Map data;
  String time;
  bool other;

  Message({this.data = const {}, this.time = "", this.other = false});

  // factory Message.fromJson(Map<String, dynamic> json) {
  //   return Message(
  //     text: json['text'],
  //   );
  // }
}
