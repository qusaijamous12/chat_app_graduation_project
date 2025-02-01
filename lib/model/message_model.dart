class MessageModel{
  final String ?message;
  final String ?name;
  final String ?userId;
  MessageModel({
    this.message,
    this.userId,
    this.name
  });
  factory MessageModel.fromJson(Map<String,dynamic> json){
    return MessageModel(
        message: json['message'],
        name: json['name'],
        userId: json['user_id']
    );
  }


}