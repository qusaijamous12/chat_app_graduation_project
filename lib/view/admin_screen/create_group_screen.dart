import 'package:chat_app/controller/user_controller/user_controller.dart';
import 'package:chat_app/shared/config/resources/color_manger.dart';
import 'package:chat_app/shared/config/resources/padding_manger.dart';
import 'package:chat_app/shared/config/resources/style_manger.dart';
import 'package:chat_app/shared/widgets/my_app_bar.dart';
import 'package:chat_app/shared/widgets/my_button.dart';
import 'package:chat_app/shared/widgets/my_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_overlay/loading_overlay.dart';

import '../../shared/config/utils/utils.dart';

class CreateGroupScreen extends StatefulWidget {
  const CreateGroupScreen({super.key});

  @override
  State<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  final _groupNameController=TextEditingController();
  final _groupNumberController=TextEditingController();
  final _groupDescriptionController=TextEditingController();
  final _userController=Get.find<UserController>(tag: 'user_controller');
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Utils.hideKeyboard(context);
      },
      onVerticalDragDown: (detials){
        Utils.hideKeyboard(context);
      },
      child: Obx(()=>LoadingOverlay(isLoading: _userController.isLoading,progressIndicator: CircularProgressIndicator(color: ColorManger.kPrimaryTwo,), child: Scaffold(
        appBar: myAppBar(title: 'Create Group Screen'),
        body: Obx(()=>LoadingOverlay(
            isLoading: _userController.isLoading,
            progressIndicator: CircularProgressIndicator(color: ColorManger.kPrimaryTwo,),
            child: Center(
              child: SingleChildScrollView(
                padding:const EdgeInsetsDirectional.all(PaddingManger.kPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Fill the following fields to create a group ...',
                      style: getMyMediumTextStyle(color: Colors.black),
                    ),
                    const SizedBox(
                      height: 15,
                    ),

                    MyTextField(controller: _groupNameController, labelText: 'Group Name', prefixIcon: Icon(Icons.drive_file_rename_outline)),
                    const SizedBox(
                      height: 20,
                    ),
                    MyTextField(controller: _groupDescriptionController, labelText: 'Group Description', prefixIcon: Icon(Icons.description_outlined)),
                    const SizedBox(
                      height: 20,
                    ),
                    MyTextField(controller: _groupNumberController, labelText: 'Group Number', prefixIcon: Icon(Icons.numbers),keyBoardType: TextInputType.number,),
                    const SizedBox(
                      height: 30,
                    ),
                    MyButton(title: 'Create', onTap: ()async{
                      if(_groupNumberController.text.isEmpty&&_groupNameController.text.isEmpty&&_groupDescriptionController.text.isEmpty){
                        Utils.myToast(title: 'All Fields are required');
                      }else{
                        await _userController.createGroup(groupName: _groupNameController.text, groupNumber:int.parse(_groupNumberController.text),groupDescription: _groupDescriptionController.text);
                        _groupNumberController.clear();
                        _groupNameController.clear();
                      }

                    }, btnColor: ColorManger.kPrimaryTwo, textColor: Colors.white)

                  ],
                ),
              ),
            ))),
      ))),
    );
  }
}
