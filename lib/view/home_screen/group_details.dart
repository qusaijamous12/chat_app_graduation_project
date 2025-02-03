import 'package:chat_app/controller/user_controller/user_controller.dart';
import 'package:chat_app/model/group_model.dart';
import 'package:chat_app/shared/config/resources/color_manger.dart';
import 'package:chat_app/shared/config/resources/padding_manger.dart';
import 'package:chat_app/shared/config/resources/style_manger.dart';
import 'package:chat_app/shared/config/utils/utils.dart';
import 'package:chat_app/shared/widgets/my_app_bar.dart';
import 'package:chat_app/shared/widgets/my_button.dart';
import 'package:chat_app/shared/widgets/my_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GroupDetails extends StatefulWidget {
  final GroupModel model;
  const GroupDetails({super.key,required this.model});

  @override
  State<GroupDetails> createState() => _GroupDetailsState();
}

class _GroupDetailsState extends State<GroupDetails> {
  final _groupNameController = TextEditingController();
  final _groupNumberController = TextEditingController();
  final _groupDescriptionController = TextEditingController();
  bool _isTermsAccepted = false;
  final _userController=Get.find<UserController>(tag: 'user_controller');

  @override
  void initState() {
    _groupNameController.text=widget.model.title;
    _groupNumberController.text=widget.model.member.toString();
    _groupDescriptionController.text=widget.model.groupDescription;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(title: 'Group Details'),
      body: SingleChildScrollView(
        padding: const EdgeInsetsDirectional.all(PaddingManger.kPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Please Read the following terms information about group before you join',
              style: getMySemiBoldTextStyle(color: Colors.black),
            ),
            const SizedBox(
              height: 25,
            ),
            Text(
              'Group Name',
              style: getMyMediumTextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 5),
            MyTextField(
              controller: _groupNameController,
              labelText: 'Group Name',
              prefixIcon: Icon(Icons.drive_file_rename_outline),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              'Group Members',
              style: getMyMediumTextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 5),
            MyTextField(
              controller: _groupNumberController,
              labelText: 'Group Member',
              prefixIcon: Icon(Icons.group),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              'Group Description',
              style: getMyMediumTextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 5),
            MyTextField(
              controller: _groupDescriptionController,
              labelText: 'Group Description',
              prefixIcon: Icon(Icons.description_outlined),
            ),
            const SizedBox(
              height: 20,
            ),
            Divider(
              height: 1,
              thickness: 2,
              color: Colors.black,
            ),
            const SizedBox(
              height: 20,
            ),
            // Terms Acceptance Section
            Text(
              'Please Read The following terms and then you must accept them to join the group',
              style: getMyMediumTextStyle(color: Colors.grey),
            ),

            const SizedBox(
              height: 15,
            ),
            Text(
              'Terms and Conditions:',
              style: getMyMediumTextStyle(color: Colors.black),
            ),
            const SizedBox(
              height: 10,
            ),


            Text(
              '''1. You agree to follow the group rules and regulations.  
2. You will not share inappropriate or offensive content.
3. Respect other group members and their opinions.
4. Violation of group rules may result in removal from the group.''',
              style: getMyRegulerTextStyle(color: Colors.black),
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              children: [
                Checkbox(

                  value: _isTermsAccepted,
                  onChanged: (value) {
                    setState(() {
                      _isTermsAccepted = value ?? false;
                    });
                  },
                  activeColor: ColorManger.kPrimaryTwo,
                ),
                Expanded(
                  child: Text(
                    'I accept the terms and conditions.',
                    style: getMyMediumTextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            // Button to join group (only enabled if terms are accepted)
            // ElevatedButton(
            //   onPressed: _isTermsAccepted
            //       ? () {
            //     // Logic to send a join group request
            //     print('User accepted terms and wants to join the group');
            //     // Add the group joining logic here
            //   }
            //       : null,
            //   style: ElevatedButton.styleFrom(
            //     padding: const EdgeInsets.symmetric(vertical: 15),
            //     backgroundColor: _isTermsAccepted ? Colors.blue : Colors.grey,
            //   ),
            //   child: Text('Join Group'),
            // ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 90),
              child: MyButton(title: 'Join Group', onTap: ()async{
                if(_isTermsAccepted){
                  await _userController.sendRequestToJoinGroup(uid: widget.model.uid);
                }else{
                  Utils.myToast(title: 'You Have to accept the terms');
                }
              }, btnColor: _isTermsAccepted?ColorManger.kPrimaryTwo:ColorManger.kPrimaryTwo.withOpacity(0.2), textColor: Colors.white),
            )
          ],
        ),
      ),
    );
  }
}
