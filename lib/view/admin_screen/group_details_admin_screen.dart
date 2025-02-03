import 'package:chat_app/controller/user_controller/user_controller.dart';
import 'package:chat_app/model/group_model.dart';
import 'package:chat_app/model/request_model.dart';
import 'package:chat_app/shared/config/resources/padding_manger.dart';
import 'package:chat_app/shared/widgets/my_app_bar.dart';
import 'package:chat_app/shared/widgets/no%20friends.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_overlay/loading_overlay.dart';

import '../../shared/config/resources/color_manger.dart';
import '../../shared/config/resources/style_manger.dart';

class GroupDetailsAdminScreen extends StatefulWidget {
  final GroupModel model;

  const GroupDetailsAdminScreen({super.key, required this.model});

  @override
  State<GroupDetailsAdminScreen> createState() =>
      _GroupDetailsAdminScreenState();
}

class _GroupDetailsAdminScreenState extends State<GroupDetailsAdminScreen> {
  final _userController = Get.find<UserController>(tag: 'user_controller');

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      await _userController.getAllRequests(uid: widget.model.uid);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(title: 'Group Details Screen'),
      body: Obx(()=>LoadingOverlay(
          isLoading: _userController.isLoading,
          progressIndicator: CircularProgressIndicator(color: ColorManger.kPrimaryTwo,),
          child: Column(
            children: [
              if (_userController.allRequests.isNotEmpty) ...[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(PaddingManger.kPadding),
                    child: ListView.separated(
                        itemBuilder: (context,index)=>buildFriendRequest(_userController.allRequests[index]),
                        separatorBuilder: (context,index)=>SizedBox(height: PaddingManger.kPadding/1.5,),
                        itemCount: _userController.allRequests.length),
                  ),
                )
              ]
              else...[
                Spacer(),
                NoFriends(title: 'There is no requests !'),
                Spacer()
              ]
            ],
          ))),
    );
  }

  Widget buildFriendRequest(RequestModel model) => Row(
        children: [
          CircleAvatar(
            radius: 45,
            backgroundImage: NetworkImage(model.profileImage),
          ),
          const SizedBox(
            width: 15,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                model.name ?? '',
                style: getMyMediumTextStyle(color: Colors.black),
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: () async {
                      await _userController.acceptRequest(groupUid: widget.model.uid, userUid: model.uid);
                    },
                    child: Container(
                      padding: EdgeInsetsDirectional.symmetric(
                          horizontal: 15, vertical: 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadiusDirectional.circular(15),
                          color: ColorManger.kPrimaryTwo),
                      child: Text(
                        'Accept',
                        style: getMyRegulerTextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  GestureDetector(
                    onTap: () async {
                      await _userController.declineRequest(groupUid: widget.model.uid, userUid: model.uid);

                    },
                    child: Container(
                      padding: EdgeInsetsDirectional.symmetric(
                          horizontal: 15, vertical: 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadiusDirectional.circular(15),
                          color: Colors.white,
                          border: Border.all(color: ColorManger.kPrimaryTwo)),
                      child: Text(
                        'Decline',
                        style: getMyRegulerTextStyle(
                            color: ColorManger.kPrimaryTwo),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ],
      );
}
