import 'package:cloud_firestore/cloud_firestore.dart'; // Import this for Timestamp

class GroupChatModel {
  final String dateTime;
  final String message;
  final String profileImage;
  final String senderUid;
  final String userName;

  GroupChatModel({
    required this.profileImage,
    required this.dateTime,
    required this.senderUid,
    required this.message,
    required this.userName
  });

  factory GroupChatModel.fromJson(Map<String, dynamic> json) {
    // Check if the 'date_time' is a Timestamp and convert it to a string
    String formattedDateTime = '';
    if (json['date_time'] is Timestamp) {
      // Convert Firebase Timestamp to DateTime and then to string
      formattedDateTime = (json['date_time'] as Timestamp).toDate().toString();
    } else if (json['date_time'] is String) {
      formattedDateTime = json['date_time'];  // If it's already a String
    }

    return GroupChatModel(
      profileImage: json['profile_image'],
      dateTime: formattedDateTime,
      senderUid: json['sender_uid'],
      message: json['message'],
      userName: json['user_name']
    );
  }
}