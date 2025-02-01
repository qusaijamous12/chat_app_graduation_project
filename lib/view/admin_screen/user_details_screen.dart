import 'package:chat_app/controller/user_controller/user_controller.dart';
import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/shared/config/resources/padding_manger.dart';
import 'package:chat_app/shared/widgets/my_button.dart';
import 'package:chat_app/view/admin_screen/admin_screen.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../shared/config/resources/color_manger.dart';
import '../../shared/config/resources/style_manger.dart';

class UserDetailsScreen extends StatefulWidget {
  final UserModel userModel;
  const UserDetailsScreen({super.key,required this.userModel});

  @override
  State<UserDetailsScreen> createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  final _userNameController=TextEditingController();
  final _emailController=TextEditingController();
  final _userUid=TextEditingController();
  final _userPhoneNumber=TextEditingController();
  final _userController=Get.find<UserController>(tag: 'user_controller');

  @override
  void initState() {
    super.initState();
    _userNameController.text=widget.userModel.userName!;
    _emailController.text=widget.userModel.email!;
    _userPhoneNumber.text=widget.userModel.phoneNumber!;
    _userUid.text=widget.userModel.uid!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorManger.kPrimaryTwo,
        leading: IconButton(
            onPressed: () {
             Get.offAll(()=>const AdminScreen());
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
        centerTitle: true,
        title: Text(
          'Users Details',
          style: getMyBoldTextStyle(color: Colors.white),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsetsDirectional.all(PaddingManger.kPadding),
          child: Column(
            children: [
              CircleAvatar(
                radius: 60,
                backgroundImage: NetworkImage('https://static.vecteezy.com/system/resources/thumbnails/051/948/045/small_2x/a-smiling-man-with-glasses-wearing-a-blue-sweater-poses-warmly-against-a-white-background-free-photo.jpeg'),
              ),
              const SizedBox(
                height: PaddingManger.kPadding*2,
              ),
              Container(
                height: 50,
                decoration: BoxDecoration(
                    borderRadius: BorderRadiusDirectional.circular(
                        PaddingManger.kPadding),
                    color: ColorManger.grey2
                ),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: TextFormField(
                  enabled: false,
                  keyboardType: TextInputType.emailAddress,
                  controller: _userNameController,
                  decoration: InputDecoration(
                      labelText: 'User Name',
                      prefixIcon: Icon(Icons.person_outline),
                      border: InputBorder.none


                  ),
                ),
              ),
              const SizedBox(
                height: PaddingManger.kPadding,
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadiusDirectional.circular(
                              PaddingManger.kPadding),
                          color: ColorManger.grey2
                      ),
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: TextFormField(
                        enabled: false,
                        keyboardType: TextInputType.emailAddress,
                        controller: _emailController,
                        decoration: InputDecoration(
                            labelText: 'Email Address',
                            prefixIcon: Icon(Icons.email_outlined),
                            border: InputBorder.none


                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: PaddingManger.kPadding/2,
                  ),
                  GestureDetector(
                    onTap: _sendEmail,
                    child: Container(
                      padding: EdgeInsetsDirectional.all(PaddingManger.kPadding/2),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: ColorManger.kPrimaryTwo
                      ),
                      child: Icon(
                        Icons.email,color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: PaddingManger.kPadding,
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadiusDirectional.circular(
                              PaddingManger.kPadding),
                          color: ColorManger.grey2
                      ),
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: TextFormField(
                        enabled: false,
                        keyboardType: TextInputType.emailAddress,
                        controller: _userPhoneNumber,
                        decoration: InputDecoration(
                            labelText: 'Phone Number',
                            prefixIcon: Icon(Icons.phone),
                            border: InputBorder.none
                    
                    
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: PaddingManger.kPadding/2,
                  ),
                  GestureDetector(
                    onTap: _makePhoneCall,
                    child: Container(
                      padding: EdgeInsetsDirectional.all(PaddingManger.kPadding/2),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: ColorManger.kPrimaryTwo
                      ),
                      child: Icon(
                        Icons.phone,color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: PaddingManger.kPadding,
              ),
              Container(
                height: 50,
                decoration: BoxDecoration(
                    borderRadius: BorderRadiusDirectional.circular(
                        PaddingManger.kPadding),
                    color: ColorManger.grey2
                ),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: TextFormField(
                  enabled: false,
                  keyboardType: TextInputType.emailAddress,
                  controller: _userUid,
                  decoration: InputDecoration(
                      labelText: 'Uid',
                      prefixIcon: Icon(Icons.qr_code),
                      border: InputBorder.none


                  ),
                ),
              ),
              const SizedBox(
                height: PaddingManger.kPadding*2,
              ),
             Obx(()=> ConditionalBuilder(
                 condition:_userController.isLoading ,
                 builder: (context)=>Center(child: CircularProgressIndicator(color: ColorManger.kPrimaryTwo,)),
                 fallback: (context)=>MyButton(title: 'Delete', onTap: ()async{
                   await _userController.deleteUser(uid: widget.userModel.uid!);
                 }, btnColor: ColorManger.kPrimaryTwo, textColor: Colors.white)))

            ],
          ),
        ),
      ),
    );
  }
  Future<void> _makePhoneCall() async {
    final phoneNumber = _userPhoneNumber.text;
    final url = 'tel:$phoneNumber';

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
  Future<void> _sendEmail() async {
    final email = _emailController.text;
    final encodedEmail = Uri.encodeFull(email);
    final subject = Uri.encodeFull("Hello");
    final body = Uri.encodeFull("Please find the details below");

    final url = 'mailto:$encodedEmail?subject=$subject&body=$body';

    try {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch email client';
      }
    } catch (e) {
      print(e);
    }
  }

}
