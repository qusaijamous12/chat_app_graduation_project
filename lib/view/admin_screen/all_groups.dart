import 'package:chat_app/controller/user_controller/user_controller.dart';
import 'package:chat_app/shared/widgets/my_app_bar.dart';
import 'package:chat_app/shared/widgets/no%20friends.dart';
import 'package:chat_app/view/admin_screen/group_details_admin_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_overlay/loading_overlay.dart';

import '../../model/group_model.dart';
import '../../shared/config/resources/color_manger.dart';
import '../../shared/config/resources/padding_manger.dart';
import '../../shared/config/resources/style_manger.dart';

class AllGroupsScreen extends StatefulWidget {
  const AllGroupsScreen({super.key});

  @override
  State<AllGroupsScreen> createState() => _AllGroupsScreenState();
}

class _AllGroupsScreenState extends State<AllGroupsScreen> {
  final _userController = Get.find<UserController>(tag: 'user_controller');

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      await _userController.getAllGroups();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(title: 'All Groups Screen'),
      body: Obx(()=>LoadingOverlay(isLoading: _userController.isLoading,progressIndicator: CircularProgressIndicator(color: ColorManger.kPrimaryTwo,), child: Column(
        children: [
          if (_userController.allGroups.isNotEmpty) ...[
            Expanded(
              child: ListView.separated(
                  itemBuilder: (context,index)=>buildGroupChat(_userController.allGroups[index]),
                  separatorBuilder: (context,index)=>const SizedBox(height: 15,),
                  itemCount: _userController.allGroups.length),
            )
          ]else...[
            Spacer(),
            NoFriends(title: 'There is no groups'),
            Spacer()
          ]
        ],
      ))),
    );
  }

  Widget buildGroupChat(GroupModel model) => GestureDetector(
        onTap: () {
          Get.to(()=> GroupDetailsAdminScreen(model: model,));
        },
        behavior: HitTestBehavior.opaque,
        child: Padding(
          padding: EdgeInsets.all(PaddingManger.kPadding),
          child: Row(
            children: [
              CircleAvatar(
                radius: 45,
                backgroundImage: NetworkImage(
                    'https://st2.depositphotos.com/3591429/8813/i/450/depositphotos_88134246-stock-photo-group-of-diversity-people.jpg'),
              ),
              const SizedBox(
                width: PaddingManger.kPadding / 2,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    model.title,
                    style: getMyRegulerTextStyle(color: Colors.black),
                  ),
                ],
              ),
              const Spacer(),
             Icon(Icons.arrow_forward_ios_outlined,color: ColorManger.kPrimaryTwo,)
            ],
          ),
        ),
      );
}
