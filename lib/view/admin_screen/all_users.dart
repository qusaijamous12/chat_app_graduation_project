import 'package:chat_app/controller/user_controller/user_controller.dart';
import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/shared/config/resources/color_manger.dart';
import 'package:chat_app/shared/config/resources/padding_manger.dart';
import 'package:chat_app/shared/config/resources/style_manger.dart';
import 'package:chat_app/shared/config/utils/utils.dart';
import 'package:chat_app/shared/widgets/my_app_bar.dart';
import 'package:chat_app/view/admin_screen/user_details_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_overlay/loading_overlay.dart';

import '../../shared/widgets/my_text_field.dart';

class AllUsers extends StatefulWidget {
  const AllUsers({super.key});

  @override
  State<AllUsers> createState() => _AllUsersState();
}

class _AllUsersState extends State<AllUsers> {
  final _userController=Get.find<UserController>(tag: 'user_controller');
  final _searchController=TextEditingController();
  List<UserModel> filteredUsers = [];

  @override
  void initState() {
    Future.delayed(Duration.zero,()async{
      await _userController.getAllUsers();
      filteredUsers = _userController.allUsers;
    });
    _searchController.addListener(_onSearchTextChanged);

    super.initState();

  }


  void _onSearchTextChanged() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      filteredUsers = _userController.allUsers
          .where((user) {
        return user.userName?.toLowerCase().contains(query) ?? false ||
            user.major!.toLowerCase().contains(query);
      })
          .toList();
    });
  }

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
        appBar: myAppBar(title: 'Users Screen'),
        body: Obx(()=>LoadingOverlay(isLoading: _userController.isLoading,progressIndicator: CircularProgressIndicator(color: ColorManger.kPrimaryTwo,), child: SingleChildScrollView(
          padding: EdgeInsetsDirectional.all(PaddingManger.kPadding),
          child: Column(
            children: [
              MyTextField(
                controller: _searchController,
                labelText: 'Search',
                prefixIcon: Icon(Icons.search),
              ),
              const SizedBox(
                height: 20,
              ),
              ListView.separated(
                  shrinkWrap: true,
                  physics:const NeverScrollableScrollPhysics(),
                  itemBuilder: (context,index)=>buildUserItem(filteredUsers[index]),
                  separatorBuilder: (context,index)=>Padding(
                    padding: const EdgeInsets.symmetric(vertical: PaddingManger.kPadding/2),
                    child: Divider(
                      height: 2,
                      color: ColorManger.grey2,
                    ),
                  ),
                  itemCount: filteredUsers.length)
            ],
          ),
        ))),
      ),
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
              backgroundImage: NetworkImage(model.profileImage!),
            ),
            const SizedBox(
              width: PaddingManger.kPadding / 2,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  model.userName??'',
                  style: getMyMediumTextStyle(color: Colors.black),
                ),
               const  SizedBox(
                  height: 10,
                ),
                Text(
                  model.email??'',
                  style: getMyRegulerTextStyle(color: Colors.grey),
                ),
              ],
            ),
            const Spacer(),

            Icon(
              Icons.arrow_forward_ios,
              color: ColorManger.kPrimaryTwo,
            )
          ],
        ),
  );
}
