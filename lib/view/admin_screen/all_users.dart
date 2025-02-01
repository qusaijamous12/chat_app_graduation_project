import 'package:chat_app/controller/user_controller/user_controller.dart';
import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/shared/config/resources/color_manger.dart';
import 'package:chat_app/shared/config/resources/padding_manger.dart';
import 'package:chat_app/shared/config/resources/style_manger.dart';
import 'package:chat_app/view/admin_screen/user_details_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_overlay/loading_overlay.dart';

class AllUsers extends StatefulWidget {
  const AllUsers({super.key});

  @override
  State<AllUsers> createState() => _AllUsersState();
}

class _AllUsersState extends State<AllUsers> {
  final _userController=Get.find<UserController>(tag: 'user_controller');

  @override
  void initState() {
    Future.delayed(Duration.zero,()async{
      await _userController.getAllUsers();
    });
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorManger.kPrimaryTwo,
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
        centerTitle: true,
        title: Text(
          'Users Screen',
          style: getMyBoldTextStyle(color: Colors.white),
        ),
      ),
      body: Obx(()=>LoadingOverlay(isLoading: _userController.isLoading, child: SingleChildScrollView(
        padding: EdgeInsetsDirectional.all(PaddingManger.kPadding),
        child: Column(
          children: [
            ListView.separated(
                shrinkWrap: true,
                physics:const NeverScrollableScrollPhysics(),
                itemBuilder: (context,index)=>buildUserItem(_userController.allUsers[index]),
                separatorBuilder: (context,index)=>Padding(
                  padding: const EdgeInsets.symmetric(vertical: PaddingManger.kPadding/2),
                  child: Divider(
                    height: 2,
                    color: ColorManger.grey2,
                  ),
                ),
                itemCount: _userController.allUsers.length)
          ],
        ),
      ))),
    );
  }

  Widget buildUserItem(UserModel model) => GestureDetector(
    onTap: (){
      Get.to(()=>UserDetailsScreen(userModel: model));
    },
    behavior: HitTestBehavior.opaque,
    child: Row(
          children: [
            CircleAvatar(
              radius: 45,
              backgroundImage: NetworkImage(
                  'https://static.vecteezy.com/system/resources/thumbnails/051/948/045/small_2x/a-smiling-man-with-glasses-wearing-a-blue-sweater-poses-warmly-against-a-white-background-free-photo.jpeg'),
            ),
            const SizedBox(
              width: PaddingManger.kPadding / 2,
            ),
            Text(
              model.userName??'',
              style: getMyMediumTextStyle(color: Colors.black),
            ),
            const Spacer(),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.black,
            )
          ],
        ),
  );
}
