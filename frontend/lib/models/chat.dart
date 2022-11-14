class Chat {
  final int id;
  final String userid;
  final String content;
  final String datetime;

  Chat({required this.id, required this.userid, required this.content, required this.datetime});

  Map<String, dynamic> toMap(){
    return {
      'id' : id,
      'userid' : userid,
      'content' : content,
      'datetime' : datetime
    };
  }
  @override
  String toString(){
    return 'Chat{id : $id , userid : $userid, content : $content, datetime : $datetime}';
  }
}