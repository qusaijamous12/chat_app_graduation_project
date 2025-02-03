import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/shared/config/resources/color_manger.dart';
import 'package:chat_app/shared/config/utils/utils.dart';
import 'package:chat_app/shared/widgets/my_button.dart';
import 'package:chat_app/shared/widgets/my_text_field.dart';
import 'package:chat_app/view/home_screen/home_screen.dart';
import 'package:chat_app/view/login_screen/login_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_overlay/loading_overlay.dart';

import '../../controller/user_controller/user_controller.dart';
import '../../shared/widgets/my_app_bar.dart';

class UserDetailsScreen extends StatefulWidget {
  final bool isUser;
  final UserModel model;
  const UserDetailsScreen({super.key,this.isUser=false,required this.model});

  @override
  State<UserDetailsScreen> createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  final nameController=TextEditingController();
  final emailController=TextEditingController();
  final ageController=TextEditingController();
  final idNumberController=TextEditingController();
  final phoneController=TextEditingController();
  final _descriptionController=TextEditingController();
  final _majorController=TextEditingController();
  final _userController=Get.find<UserController>(tag: 'user_controller');

  @override
  void initState() {
    nameController.text=widget.model.userName??'';
    idNumberController.text=widget.model.uid??'';
    ageController.text=widget.model.age??"";
    emailController.text=widget.model.email??'';
    phoneController.text=widget.model.phoneNumber??'';
    _majorController.text=widget.model.major??"";
    _descriptionController.text=widget.model.description??"";

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Obx(()=>LoadingOverlay(isLoading: _userController.isLoading,progressIndicator: CircularProgressIndicator(color: ColorManger.kPrimaryTwo,), child:
    GestureDetector(
      onTap: (){
        Utils.hideKeyboard(context);
      },
      onVerticalDragDown: (details){
        Utils.hideKeyboard(context);
      },
      child: Scaffold(
        appBar: myAppBar(title: 'User Details Screen'),
        body: Center(
          child: SingleChildScrollView(
            padding:const EdgeInsetsDirectional.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  alignment: AlignmentDirectional.bottomEnd,
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: ColorManger.kPrimaryTwo,
                      backgroundImage: NetworkImage(widget.model.profileImage??''),

                    ),
                    if(widget.isUser)
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: Colors.white,
                      child: IconButton(onPressed: (){}, icon:const Icon(Icons.edit,color: ColorManger.kPrimaryTwo,)),
                    )
                  ],
                ),
                const  SizedBox(
                  height: 40,
                ),

                MyTextField(controller: nameController, labelText: 'User Name', prefixIcon: Icon(Icons.person_outline),enabled: widget.isUser,),

                const SizedBox(
                  height: 20,
                ),

                MyTextField(controller: emailController, labelText: 'Email Address', prefixIcon: Icon(Icons.email_outlined),enabled: false),

                const SizedBox(
                  height: 20,
                ),

                MyTextField(controller: ageController, labelText: 'User Age', prefixIcon: Icon(Icons.person_outline),enabled: widget.isUser),


                if(widget.isUser)...[
                  const SizedBox(
                    height: 20,
                  ),

                  MyTextField(controller: idNumberController, labelText: 'User Id', prefixIcon: Icon(Icons.numbers),enabled: false),
                ],


                const SizedBox(
                  height: 20,
                ),

                MyTextField(controller: _majorController, labelText: 'Major', prefixIcon: Icon(Icons.book),enabled: widget.isUser),

                const SizedBox(
                  height: 20,
                ),

                MyTextField(controller: _descriptionController, labelText: 'Description', prefixIcon: Icon(Icons.description),enabled: widget.isUser),


                if(widget.isUser)...[
                  const SizedBox(
                    height: 20,
                  ),
                  MyTextField(controller: phoneController, labelText: 'Mobile Number', prefixIcon: Icon(Icons.phone),enabled: widget.isUser),
                ],

                const SizedBox(
                  height: 40,
                ),


                Row(
                  children: [
                    Expanded(child: MyButton(title: widget.isUser?'Update Profile':'Add Friend', onTap: ()async{
                      if(widget.isUser){
                        if(nameController.text.isNotEmpty&&phoneController.text.isNotEmpty){
                          await  _userController.updateUserData(name: nameController.text, phone: phoneController.text);
                          Get.offAll(()=>const HomeScreen());

                        }else{
                          Utils.myToast(title: 'The name and phone must not be empty !');
                        }
                      }
                      else{
                        await _userController.addFriend(userName: widget.model.userName??"", uid: widget.model.uid??'', emailAddress: widget.model.email??'');
                      }
                    }, btnColor: ColorManger.kPrimaryTwo, textColor: Colors.white)),
                    if(widget.isUser)...[
                      const SizedBox(
                        width: 15,
                      ),
                      Expanded(child: MyButton(title: 'Log Out', onTap: (){
                        Get.offAll(()=>const LoginScreen());
                      }, btnColor: Colors.white, textColor: ColorManger.kPrimaryTwo)),

                    ]
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    )));


  }

}