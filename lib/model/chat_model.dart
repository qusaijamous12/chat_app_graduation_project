import 'package:intl/intl.dart';

class ChatModel {
  late final DateTime? createdAt;
  String? senderId;
  String? reciverId;
  String? dateTime;
  String? text;

  ChatModel({
    this.createdAt,
    this.senderId,
    this.reciverId,
    this.dateTime,
    this.text,
  });

  // The fromJson constructor now formats the time.
  ChatModel.fromJson(Map<String, dynamic> json) {
    senderId = json['senderId'];
    createdAt = json['createdAt'] ?? DateTime.now();


    dateTime = json['dateTime'];
    //DateFormat('h:mm a').format(createdAt!); // Using 12-hour format with AM/PM

    reciverId = json['reciverId'];
    text = json['text'];
  }

  // When converting to Map, store the formatted time as a string in `dateTime`
  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'createdAt': createdAt,
      'reciverId': reciverId,
      'dateTime': dateTime,  // Now contains formatted time
      'text': text,
    };
  }
}