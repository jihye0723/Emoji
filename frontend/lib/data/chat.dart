class Chat {
  final String userid;
  final String content;
  final String datetime;

  Chat({required this.userid, required this.content, required this.datetime});

  Map<String, dynamic> toMap() {
    return {'userid': userid, 'content': content, 'datetime': datetime};
  }

  @override
  String toString() {
    return 'Chat{userid : $userid, content : $content, datetime : $datetime}';
  }
}
