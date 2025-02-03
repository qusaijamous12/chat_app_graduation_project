import 'package:chat_app/shared/widgets/my_app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatGroupScreen extends StatelessWidget {
  const ChatGroupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(title: 'Chat Group Screen'),
    );
  }
}
