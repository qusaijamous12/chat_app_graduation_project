import 'package:chat_app/controller/user_controller/user_controller.dart';
import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/shared/config/resources/font_manger.dart';
import 'package:chat_app/shared/config/resources/padding_manger.dart';
import 'package:chat_app/shared/config/resources/style_manger.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_overlay/loading_overlay.dart';

import '../../shared/config/resources/color_manger.dart';

class FriendRequestsScreen extends StatefulWidget {
  const FriendRequestsScreen({super.key});

  @override
  State<FriendRequestsScreen> createState() => _FriendRequestsScreenState();
}

class _FriendRequestsScreenState extends State<FriendRequestsScreen> {
  final _userController=Get.find<UserController>(tag: 'user_controller');
  
  @override
  void initState() {
    Future.delayed(Duration.zero,()async{
      await _userController.getAllFriendsRequest();
    });
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorManger.kPrimaryTwo,
        title: Text(
          'Friend Requests', style: getMyMediumTextStyle(color: Colors.white),),
        leading: IconButton(
            onPressed: () {
              Get.back();
            }, icon: const Icon(Icons.arrow_back_ios, color: Colors.white,)),
      ),
      body: Obx(()=>LoadingOverlay(isLoading: _userController.isLoading,progressIndicator: CircularProgressIndicator(color: ColorManger.kPrimaryTwo,), child: Padding(
        padding: const EdgeInsets.all(PaddingManger.kPadding),
        child: Column(
          children: [
            if(_userController.allFriendRequest.length!=0)
            Expanded(
              child: ListView.separated(

                  itemBuilder:(context,index)=>buildFriendRequest(_userController.allFriendRequest[index]),
                  separatorBuilder: (context,index)=>Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Divider(
                      height: 1,
                      color: ColorManger.grey1.withOpacity(0.3),
                      thickness: 1,

                    ),
                  ),
                  itemCount: _userController.allFriendRequest.length),
            ),
            if(_userController.allFriendRequest.length==0)...[
              const Spacer(),
              Column(
                children: [
                  Icon(Icons.person_outline,color: ColorManger.kPrimaryTwo,size: 150,),
                  const SizedBox(
                    height: 15,
                  ),
                  Align(
                    alignment: AlignmentDirectional.center,
                    child: Text(
                      'There is No Friends Requests!',
                      style: getMyMediumTextStyle(color: Colors.black,fontSize: FontSize.s20),
                    ),
                  ),
                ],
              ),
              const Spacer(),

            ]

          ],
        ),
      ))),

    );
  }

  Widget buildFriendRequest(UserModel model) =>
      Row(
        children: [
          CircleAvatar(
            radius: 45,
            backgroundImage: NetworkImage(
                'https://static.vecteezy.com/system/resources/thumbnails/051/948/045/small_2x/a-smiling-man-with-glasses-wearing-a-blue-sweater-poses-warmly-against-a-white-background-free-photo.jpeg'),
          ),
          const SizedBox(
            width: 15,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                model.userName??'',
                style: getMyMediumTextStyle(color: Colors.black),

              ),
              SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: () async{
                      await _userController.acceptFriendsRequest(model);

                    },
                    child: Container(
                      padding: EdgeInsetsDirectional.symmetric(
                          horizontal: 15, vertical: 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadiusDirectional.circular(15),
                          color: ColorManger.kPrimaryTwo
                      ),
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
                    onTap: ()async {
                      await _userController.declineFriendsRequest(model);
                    },
                    child: Container(
                      padding: EdgeInsetsDirectional.symmetric(
                          horizontal: 15, vertical: 10),

                      decoration: BoxDecoration(
                          borderRadius: BorderRadiusDirectional.circular(15),
                          color: Colors.white,
                          border: Border.all(
                              color: ColorManger.kPrimaryTwo
                          )
                      ),
                      child: Text(
                        'Accept',
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
