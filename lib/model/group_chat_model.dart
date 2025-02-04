class GroupChatModel {

  final String dateTime;
  final String message;
  final String profileImage;
  final String senderUid;


  GroupChatModel({
    required this.profileImage,
    required this.dateTime,
    required this.senderUid,
    required this.message
  });

  factory GroupChatModel.fromJson(Map<String, dynamic> json){
    return GroupChatModel(profileImage: json['profile_image'],
        dateTime: json['date_time'],
        senderUid: json['sender_uid'],
        message: json['message']);
  }

}