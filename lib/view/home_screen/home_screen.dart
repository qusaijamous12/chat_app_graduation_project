import 'package:chat_app/controller/user_controller/user_controller.dart';
import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/shared/config/resources/color_manger.dart';
import 'package:chat_app/shared/config/resources/padding_manger.dart';
import 'package:chat_app/shared/config/resources/style_manger.dart';
import 'package:chat_app/shared/widgets/my_button.dart';
import 'package:chat_app/view/home_screen/chat_screen.dart';
import 'package:chat_app/view/home_screen/friend_requests_screen.dart';
import 'package:chat_app/view/home_screen/user_details_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_overlay/loading_overlay.dart';

import '../../shared/config/resources/font_manger.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isFriend = true;
  final _selectedTab=RxString('Friend');
  final _userController=Get.find<UserController>(tag: 'user_controller');

  @override
  void initState() {

    Future.delayed(Duration.zero,()async{
      await _userController.getAllUsers();
    });
    Future.delayed(Duration.zero,()async{
      await _userController.getMyFriends();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(()=>Scaffold(
      body: SafeArea(
        child: LoadingOverlay(isLoading: _userController.isLoading,progressIndicator: CircularProgressIndicator(color: ColorManger.kPrimaryTwo,) ,child: Column(
          children: [
            Container(
              height: 150,
              padding: EdgeInsetsDirectional.all(PaddingManger.kPadding),
              decoration: BoxDecoration(
                  borderRadius: BorderRadiusDirectional.only(
                      bottomStart: Radius.circular(PaddingManger.kPadding),
                      bottomEnd: Radius.circular(PaddingManger.kPadding)),
                  color: ColorManger.kPrimaryTwo),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        'Messages',
                        style: getMyBoldTextStyle(
                            color: Colors.white, fontSize: FontSize.s20),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: (){
                          Get.to(()=>const FriendRequestsScreen());
                        },
                        child: Container(
                            padding: EdgeInsetsDirectional.all(
                                PaddingManger.kPadding / 4),
                            decoration: BoxDecoration(
                                color: Colors.white, shape: BoxShape.circle),
                            child: Icon(
                              Icons.notifications,
                              color: ColorManger.kPrimaryTwo,
                            )),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Container(
                          padding: EdgeInsetsDirectional.all(
                              PaddingManger.kPadding / 4),
                          decoration: BoxDecoration(
                              color: Colors.white, shape: BoxShape.circle),
                          child: Icon(
                            Icons.search,
                            color: ColorManger.kPrimaryTwo,
                          ))
                    ],
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            _selectedTab('Friend');
                          },
                          child: Container(
                            alignment: AlignmentDirectional.center,
                            padding: EdgeInsetsDirectional.symmetric(
                                vertical: 7, horizontal: 10),
                            decoration: BoxDecoration(
                                color: _selectedTab.value=='Friend'
                                    ? Colors.white
                                    : ColorManger.kPrimaryTwo,
                                borderRadius: BorderRadiusDirectional.circular(
                                    PaddingManger.kPadding)),
                            child: Text(
                              'Friend',
                              style: getMyMediumTextStyle(
                                  color: _selectedTab.value=='Friend'
                                      ? ColorManger.kPrimaryTwo
                                      : Colors.white),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: PaddingManger.kPadding / 2,
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            _selectedTab('Groups');

                          },
                          child: Container(
                            alignment: AlignmentDirectional.center,
                            padding: EdgeInsetsDirectional.symmetric(
                                vertical: 7, horizontal: 10),
                            decoration: BoxDecoration(
                                color:_selectedTab.value=='Groups'?Colors.white:ColorManger.kPrimaryTwo,
                                borderRadius: BorderRadiusDirectional.circular(
                                    PaddingManger.kPadding)),
                            child: Text(
                              'Groups',
                              style: getMyMediumTextStyle(
                                  color: _selectedTab.value=='Groups'?ColorManger.kPrimaryTwo:Colors.white),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: PaddingManger.kPadding / 2,
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            _selectedTab('Users');

                          },
                          child: Container(
                            alignment: AlignmentDirectional.center,
                            padding: EdgeInsetsDirectional.symmetric(
                                vertical: 7, horizontal: 10),
                            decoration: BoxDecoration(
                                color:_selectedTab.value=='Users'?Colors.white:ColorManger.kPrimaryTwo,
                                borderRadius: BorderRadiusDirectional.circular(
                                    PaddingManger.kPadding)),
                            child: Text(
                              'Users',
                              style: getMyMediumTextStyle(
                                  color:_selectedTab.value=='Users'?ColorManger.kPrimaryTwo:Colors.white),
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(
              height: PaddingManger.kPadding / 2,
            ),
            if(_selectedTab.value=='Friend')...[
              Expanded(
                child: ListView.separated(
                    itemBuilder: (context,index)=>buildUserChat(_userController.allMyFriends[index]),
                    separatorBuilder: (context,index)=>Padding(
                      padding: const EdgeInsets.symmetric(horizontal: PaddingManger.kPadding),
                      child: Divider(
                        color: ColorManger.grey2,
                        height: 1,
                      ),
                    ),
                    itemCount: _userController.allMyFriends.length),
              )
            ]
            else if(_selectedTab.value=='Groups')...[
              Expanded(
                child: ListView.separated(
                    itemBuilder: (context,index)=>buildGroupChat(),
                    separatorBuilder: (context,index)=>Padding(
                      padding: const EdgeInsets.symmetric(horizontal: PaddingManger.kPadding),
                      child: Divider(
                        color: ColorManger.grey2,
                        height: 1,

                      ),
                    ),
                    itemCount: 5),
              )
            ]
            else...[
                Expanded(
                  child: ListView.separated(
                      itemBuilder: (context,index)=>buildAllUser(_userController.allUsers[index]),
                      separatorBuilder: (context,index)=>Padding(
                        padding: const EdgeInsets.symmetric(horizontal: PaddingManger.kPadding),
                        child: Divider(
                          color: ColorManger.grey2,
                          height: 1,

                        ),
                      ),
                      itemCount: _userController.allUsers.length),
                )

              ]

          ],
        )),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: (){
            Get.to(()=> UserDetailsScreen(isUser: true,model: _userController.userModel??UserModel(uid: '', phoneNumber: '', email: '', userName: '', status: 0),));
          },
          elevation: 0,
          backgroundColor: ColorManger.kPrimaryTwo,
          child: Icon(Icons.person_outline,color: Colors.white,)
      ),
    ));
  }

  Widget buildUserChat(UserModel model) => GestureDetector(
    onTap: (){
      Get.to(()=> ChatScreen(receiverId: model.uid??'',));
    },
    behavior: HitTestBehavior.opaque,
    child: Padding(
          padding: const EdgeInsets.all(PaddingManger.kPadding),
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    model.userName?.capitalizeFirst??'',
                    style: getMyRegulerTextStyle(color: Colors.black),
                  ),
                  const SizedBox(
                    height: PaddingManger.kPadding / 4,
                  ),
                  Text(
                    model.email??'',
                    style: getMyRegulerTextStyle(color: ColorManger.grey),
                  ),

                ],
              ),
              // const Spacer(),
              // Column(
              //   crossAxisAlignment: CrossAxisAlignment.end,
              //   children: [
              //     CircleAvatar(
              //       radius: 10,
              //       backgroundColor: ColorManger.kPrimaryTwo,
              //       child: Text(
              //         '1',
              //         style: getMyRegulerTextStyle(color: Colors.white),
              //       ),
              //     ),
              //     const SizedBox(
              //       height: PaddingManger.kPadding / 5,
              //     ),
              //     Text(
              //       '5:45 am',
              //       style: getMyRegulerTextStyle(color: ColorManger.grey),
              //     )
              //   ],
              // )
            ],
          ),
        ),
  );

  Widget buildGroupChat() => Padding(
    padding: const EdgeInsets.all(PaddingManger.kPadding),
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
              'Jobs Group',
              style: getMyRegulerTextStyle(color: Colors.black),
            ),
            const SizedBox(
              height: PaddingManger.kPadding / 4,
            ),
            Text(
              'Hello !!',
              style: getMyRegulerTextStyle(color: ColorManger.grey),
            ),
          ],
        ),
        const Spacer(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            CircleAvatar(
              radius: 10,
              backgroundColor: ColorManger.kPrimaryTwo,
              child: Text(
                '1',
                style: getMyRegulerTextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(
              height: PaddingManger.kPadding / 5,
            ),
            Text(
              '5:45 am',
              style: getMyRegulerTextStyle(color: ColorManger.grey),
            )
          ],
        )
      ],
    ),
  );

  Widget buildAllUser(UserModel userModel) => GestureDetector(
    onTap: (){
      Get.to(()=> UserDetailsScreen(model: userModel,));
    },
    behavior: HitTestBehavior.opaque,
    child: Padding(
      padding: const EdgeInsets.all(PaddingManger.kPadding),
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userModel.userName?.capitalizeFirst??'',
                style: getMyRegulerTextStyle(color: Colors.black),
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                'SoftWare Engineer',
                style: getMyRegulerTextStyle(color: ColorManger.grey),
              ),



            ],
          ),
         const  Spacer(),
          Icon(Icons.arrow_forward_ios,color: ColorManger.kPrimaryTwo,)

        ],
      ),
    ),
  );
}
