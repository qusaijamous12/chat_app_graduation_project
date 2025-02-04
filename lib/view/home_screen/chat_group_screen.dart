import 'package:chat_app/model/group_model.dart';
import 'package:chat_app/shared/widgets/my_app_bar.dart';
import 'package:chat_app/view/home_screen/all_users_group_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_overlay/loading_overlay.dart';

import '../../controller/user_controller/user_controller.dart';
import '../../model/chat_model.dart';
import '../../model/group_chat_model.dart';
import '../../shared/config/resources/color_manger.dart';
import '../../shared/config/resources/font_manger.dart';
import '../../shared/config/resources/style_manger.dart';
import '../../shared/config/utils/utils.dart';

class ChatGroupScreen extends StatefulWidget {
  final GroupModel model;

  const ChatGroupScreen({super.key, required this.model});

  // final String receiverId;

  @override
  State<ChatGroupScreen> createState() => _ChatGroupScreenState();
}

class _ChatGroupScreenState extends State<ChatGroupScreen> {
  final _userController = Get.find<UserController>(tag: 'user_controller');
  final _messageController = TextEditingController();
  ScrollController _scrollController = ScrollController();  // Add a scroll controller

  @override
  void dispose() {
    _scrollController.dispose(); // Dispose of the controller when the widget is disposed.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (BuildContext context) {
        _userController.getMessagesGroup(uid: widget.model.uid); // Fetch messages

        return Obx(() => LoadingOverlay(
          isLoading: _userController.isLoading,
          progressIndicator: CircularProgressIndicator(color: ColorManger.kPrimaryTwo,),
          child: GestureDetector(
            onTap: () {
              Utils.hideKeyboard(context);
            },
            onVerticalDragDown: (details) {
              Utils.hideKeyboard(context);
            },
            child: Scaffold(
              appBar: AppBar(
                title: Text(
                  'Messages'.tr,
                  style: const TextStyle(color: Colors.white),
                ),
                actions: [
                  IconButton(onPressed: (){
                    Get.to(()=>AllUsersGroupScreen(groupUid: widget.model.uid));

                  }, icon: Icon(Icons.group,color: Colors.white,))
                ],
                backgroundColor: ColorManger.kPrimaryTwo,
                leading: IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                    )),
              ),
              body: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsetsDirectional.all(20),
                        decoration: BoxDecoration(
                            color: ColorManger.kPrimaryTwo.withOpacity(0.5),
                            borderRadius: BorderRadiusDirectional.circular(20)),
                        child: SingleChildScrollView(
                          controller: _scrollController,  // Assign the scroll controller here
                          child: Column(
                            children: [
                              CircleAvatar(
                                radius: 60,
                                backgroundImage: NetworkImage(
                                    'https://st2.depositphotos.com/3591429/8813/i/450/depositphotos_88134246-stock-photo-group-of-diversity-people.jpg'),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                widget.model.title,
                                style: getMyMediumTextStyle(color: Colors.white),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                widget.model.groupDescription,
                                style: getMyRegulerTextStyle(
                                    color: ColorManger.grey),
                              ),
                              const SizedBox(height: 20),
                              ListView.separated(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  if (_userController.allChatGroupMessages[index].senderUid != _userController.userModel?.uid) {
                                    return buildMessage(_userController.allChatGroupMessages[index]);
                                  } else {
                                    return buildMyMessage(_userController.allChatGroupMessages[index]);
                                  }
                                },
                                separatorBuilder: (context, index) =>
                                const SizedBox(height: 20),
                                itemCount: _userController.allChatGroupMessages.length,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Container(
                      padding: const EdgeInsetsDirectional.only(start: 7),
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey, width: 1),
                          borderRadius: BorderRadius.circular(15)),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              // Open gallery to send image if necessary
                            },
                            child: const CircleAvatar(
                              backgroundColor: Colors.white,
                              child: Icon(
                                Icons.image,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          Expanded(
                            child: TextFormField(
                              controller: _messageController,
                              decoration: InputDecoration(
                                  hintText: 'Write Your Message Here'.tr,
                                  border: InputBorder.none),
                            ),
                          ),
                          Container(
                            color: ColorManger.kPrimaryTwo,
                            height: 60,
                            width: 60,
                            child: IconButton(
                              onPressed: () async {
                                if (_messageController.text.isNotEmpty) {
                                  await _userController.sendMessageGroup(
                                      uid: widget.model.uid,
                                      message: _messageController.text,
                                      senderUid: _userController.userModel!.uid!,
                                      userName: _userController.userModel!.userName!,
                                      profileImage: _userController.userModel!.profileImage ?? '');
                                  _messageController.clear();
                                  // After sending the message, scroll to the bottom
                                  _scrollController.animateTo(
                                    _scrollController.position.maxScrollExtent,
                                    duration: Duration(milliseconds: 300),
                                    curve: Curves.easeOut,
                                  );
                                }
                              },
                              icon: const Icon(Icons.send, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
      },
    );
  }

Widget buildMessage(GroupChatModel model) =>
    Align(
      alignment: AlignmentDirectional.centerStart,
      child: Row(
        mainAxisSize: MainAxisSize.min, // Make Row shrink to fit content
        children: [
          Expanded(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundImage: NetworkImage(model.profileImage ?? ""),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  model.userName,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: getMyRegulerTextStyle(color: Colors.white),
                )
              ],
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Flexible(
            flex: 3,
            // Ensure the container takes only necessary width based on content
            child: Container(
              padding:
              const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadiusDirectional.only(
                  bottomEnd: Radius.circular(10),
                  topStart: Radius.circular(10),
                  topEnd: Radius.circular(10),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    model.message ?? '',
                    style: const TextStyle(fontSize: 18),
                    overflow: TextOverflow.visible,
                    // Allow text to extend without clipping
                    softWrap: true, // Enable text wrapping
                  ),
                  Text(
                    model.dateTime?.substring(10, 16) ?? '',
                    style: getMyLightTextStyle(
                        color: ColorManger.grey, fontSize: FontSize.s14),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );

Widget buildMyMessage(GroupChatModel model) =>
    Align(
      alignment: AlignmentDirectional.centerEnd,
      child: Row(
        textDirection: TextDirection.rtl,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundImage: NetworkImage(model.profileImage ?? ""),
                ),
            
                Text(
                  model.userName,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: getMyRegulerTextStyle(color: Colors.white),
                )
              ],
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Flexible(
            flex: 3,
            // Ensure the container takes only necessary width based on content
            child: Container(

              padding:
              const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              decoration: BoxDecoration(
                color: ColorManger.kPrimaryTwo,
                borderRadius: const BorderRadiusDirectional.only(
                  bottomStart: Radius.circular(10),
                  topStart: Radius.circular(10),
                  topEnd: Radius.circular(10),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    model.message ?? '',
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                    overflow: TextOverflow.visible,
                    // Allow text to extend without clipping
                    softWrap: true, // Enable text wrapping
                  ),
                  Text(
                    model.dateTime ?? '',
                    style: getMyLightTextStyle(
                        color: Colors.white, fontSize: FontSize.s14),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );


}

