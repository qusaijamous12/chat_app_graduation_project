import 'package:chat_app/shared/config/utils/utils.dart';
import 'package:chat_app/view/admin_screen/all_groups.dart';
import 'package:chat_app/view/admin_screen/all_users.dart';
import 'package:chat_app/view/admin_screen/create_group_screen.dart';
import 'package:chat_app/view/login_screen/login_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../shared/config/resources/color_manger.dart';
import '../../shared/config/resources/font_manger.dart';
import '../../shared/config/resources/padding_manger.dart';
import '../../shared/config/resources/style_manger.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Utils.hideKeyboard(context);
      },
      onVerticalDragDown: (details){
        Utils.hideKeyboard(context);
      },
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 0,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: ColorManger.kPrimaryTwo,
            statusBarIconBrightness: Brightness.light
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 180,
                padding: EdgeInsetsDirectional.all(PaddingManger.kPadding),
                decoration: BoxDecoration(
                    borderRadius: BorderRadiusDirectional.only(
                        bottomStart: Radius.circular(PaddingManger.kPadding),
                        bottomEnd: Radius.circular(PaddingManger.kPadding)),
                    color: ColorManger.kPrimaryTwo),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Messages',
                          style: getMyBoldTextStyle(
                              color: Colors.white, fontSize: FontSize.s20),
                        ),
                        Spacer(),
                        CircleAvatar(
                          radius: 20,
                            backgroundColor: Colors.white,
                            child: Icon(Icons.login_outlined,color: ColorManger.kPrimaryTwo,))

                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      'Welcome Admin',
                      style: getMyRegulerTextStyle(
                          color: Colors.white, fontSize: FontSize.s20),
                    ),
                    const Spacer(),
                    Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadiusDirectional.circular(PaddingManger.kPadding)
                      ),
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: TextFormField(
                        onTap: (){
                          Get.to(()=>const AllUsers());
                        },
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          labelText: 'Search',
                          labelStyle: getMyMediumTextStyle(color: ColorManger.grey),
                          prefixIcon: Icon(Icons.search,color: ColorManger.grey,)
                        ),
                      ),
                    ),


                  ],
                ),
              ),
              const SizedBox(
                height: PaddingManger.kPadding,
              ),
              Padding(
                padding: const EdgeInsets.all(PaddingManger.kPadding),
                child: Column(
                  children: [
                    Text(
                      'Hello Admin Lets Start to create a group chat',
                      style: getMyBoldTextStyle(color: ColorManger.grey),
                    ),
                    const SizedBox(
                      height:PaddingManger.kPadding*2,
                    ),
                    GestureDetector(
                      onTap: (){
                        Get.to(()=>const CreateGroupScreen());
                      },
                      child: Container(
                        height: 100,
                        padding: EdgeInsetsDirectional.all(PaddingManger.kPadding/2),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadiusDirectional.circular(PaddingManger.kPadding),
                          color: ColorManger.grey2
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.group,color: ColorManger.kPrimaryTwo,size: 60,),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              'Create Group',
                              style: getMyMediumTextStyle(color: Colors.black),
                            ),
                            Spacer(),
                            Icon(Icons.arrow_forward_ios,color: Colors.black,)
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: PaddingManger.kPadding,
                    ),

                    GestureDetector(
                      onTap: (){
                        Get.to(()=>const AllUsers());
                      },
                      child: Container(
                        height: 100,
                        padding: EdgeInsetsDirectional.all(PaddingManger.kPadding/2),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadiusDirectional.circular(PaddingManger.kPadding),
                            color: ColorManger.grey2
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.supervised_user_circle_outlined,color: ColorManger.kPrimaryTwo,size: 60,),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              'All Users',
                              style: getMyMediumTextStyle(color: Colors.black),
                            ),
                            Spacer(),
                            Icon(Icons.arrow_forward_ios,color: Colors.black,)
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: PaddingManger.kPadding,
                    ),

                    GestureDetector(
                      onTap: (){
                        Get.to(()=>const AllGroupsScreen());
                      },
                      child: Container(
                        height: 100,
                        padding: EdgeInsetsDirectional.all(PaddingManger.kPadding/2),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadiusDirectional.circular(PaddingManger.kPadding),
                            color: ColorManger.grey2
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.group_add_sharp,color: ColorManger.kPrimaryTwo,size: 60,),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              'All Groups',
                              style: getMyMediumTextStyle(color: Colors.black),
                            ),
                            Spacer(),
                            Icon(Icons.arrow_forward_ios,color: Colors.black,)
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: PaddingManger.kPadding,
                    ),

                    GestureDetector(
                      onTap: (){
                        Get.offAll(()=>const LoginScreen());
                      },
                      child: Container(
                        height: 100,
                        padding: EdgeInsetsDirectional.all(PaddingManger.kPadding/2),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadiusDirectional.circular(PaddingManger.kPadding),
                            color: ColorManger.grey2
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.logout,color: ColorManger.kPrimaryTwo,size: 60,),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              'LogOut',
                              style: getMyMediumTextStyle(color: Colors.black),
                            ),
                            Spacer(),
                            Icon(Icons.arrow_forward_ios,color: Colors.black,)
                          ],
                        ),
                      ),
                    ),

                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
