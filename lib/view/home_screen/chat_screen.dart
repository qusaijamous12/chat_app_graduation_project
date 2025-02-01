import 'package:chat_app/model/chat_model.dart';
import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/shared/config/resources/color_manger.dart';
import 'package:chat_app/shared/config/resources/font_manger.dart';
import 'package:chat_app/shared/config/resources/style_manger.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/user_controller/user_controller.dart';
import '../../shared/config/utils/utils.dart';



class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key,required this.receiverId});
  final String receiverId;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _userController=Get.find<UserController>(tag: 'user_controller');


  final _messageController=TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Builder(

      builder: (BuildContext context) {
        _userController.getMessages(receiverId:widget.receiverId);


        return Scaffold(
          appBar: AppBar(
            title: Text('Messages'.tr,style:const TextStyle(color: Colors.white),),backgroundColor: ColorManger.kPrimaryTwo,leading: IconButton(onPressed: (){
            Get.back();
          }, icon:const Icon(Icons.arrow_back_ios,color: Colors.white,)),),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Obx(()=>Expanded(
                  child: Container(
                    padding:const EdgeInsetsDirectional.all(20),
                    decoration: BoxDecoration(
                        color: ColorManger.kPrimaryTwo.withOpacity(0.5),
                        borderRadius: BorderRadiusDirectional.circular(20)
                    ),
                    child: ListView.separated(
                        shrinkWrap: true,


                        itemBuilder: (context,index){
                          if(_userController.listChatModel[index].senderId!=_userController.userModel?.uid)
                          {
                            return   buildMessage(_userController.listChatModel[index]);
                          }else{
                            return  buildMyMessage(_userController.listChatModel[index]);
                          }
                        },
                        separatorBuilder: (context,index)=>const SizedBox(
                          height: 20,
                        ),
                        itemCount: _userController.listChatModel.length),

                  ),
                )),
                const SizedBox(
                  height: 15,
                ),
                Container(
                  padding:const EdgeInsetsDirectional.only(
                      start: 7
                  ),
                  clipBehavior: Clip.antiAliasWithSaveLayer ,
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: Colors.grey,
                          width: 1

                      ),
                      borderRadius: BorderRadius.circular(15 )
                  ),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: (){
                          // DoctorCubit.get(context).openGalaryToSendImage();
                        },
                        child:const CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Icon(Icons.image, color: Colors.grey,),

                        ),
                      ),
                      Expanded(
                        child: TextFormField(
                          controller: _messageController,
                          decoration: InputDecoration(
                              hintText: 'Write Your Message Here'.tr,
                              border: InputBorder.none
                          ),
                        ),

                      ),
                      Container(
                        color: ColorManger.kPrimaryTwo,
                        height: 60,
                        width: 60,

                        child: IconButton(
                            onPressed: (){
                              if(_messageController.text.isNotEmpty){
                                _userController.sendMessage(receiverId: widget.receiverId, dateTime: DateTime.now().toString().substring(10,16), text: _messageController.text);
                                _messageController.clear();

                              }else{
                                Utils.myToast(title: 'Message is Requierd');
                              }

                            },
                            icon:const Icon(
                              Icons.send,
                              color: Colors.white,

                            )),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),

        );
      },//as
    );
  }
  Widget buildMessage(ChatModel model) => Align(
    alignment: AlignmentDirectional.centerStart,
    child: Row(
      mainAxisSize: MainAxisSize.min,  // Make Row shrink to fit content
      children: [
        const CircleAvatar(
          radius: 25,
          backgroundImage: NetworkImage('https://t3.ftcdn.net/jpg/02/43/12/34/360_F_243123463_zTooub557xEWABDLk0jJklDyLSGl2jrr.jpg'),
        ),
        const SizedBox(
          width: 10,
        ),
        Flexible(  // Ensure the container takes only necessary width based on content
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadiusDirectional.only(
                bottomEnd: Radius.circular(10),
                topStart: Radius.circular(10),
                topEnd: Radius.circular(10),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  model.text??'',
                  style: const TextStyle(fontSize: 18),
                  overflow: TextOverflow.visible, // Allow text to extend without clipping
                  softWrap: true,  // Enable text wrapping
                ),
                Text(
                  model.dateTime??'',
                  style: getMyLightTextStyle(color: ColorManger.grey, fontSize: FontSize.s14),
                )
              ],
            ),
          ),
        ),
      ],
    ),
  );

  Widget buildMyMessage(ChatModel model) => Align(
    alignment: AlignmentDirectional.centerEnd,
    child: Row(
      textDirection: TextDirection.rtl,
      mainAxisSize: MainAxisSize.min,
      children: [
        const CircleAvatar(
          radius: 25,
          backgroundImage: NetworkImage('https://static.vecteezy.com/system/resources/thumbnails/051/948/045/small_2x/a-smiling-man-with-glasses-wearing-a-blue-sweater-poses-warmly-against-a-white-background-free-photo.jpeg'),
        ),
        const SizedBox(
          width: 10,
        ),
        Flexible(  // Ensure the container takes only necessary width based on content
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            decoration: BoxDecoration(
              color: ColorManger.kPrimaryTwo,
              borderRadius: const BorderRadiusDirectional.only(
                bottomStart: Radius.circular(10),
                topStart: Radius.circular(10),
                topEnd: Radius.circular(10),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  model.text??'',
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                  overflow: TextOverflow.visible,  // Allow text to extend without clipping
                  softWrap: true,  // Enable text wrapping
                ),
                Text(
                  model.dateTime??'',
                  style: getMyLightTextStyle(color: Colors.white, fontSize: FontSize.s14),
                )
              ],
            ),
          ),
        ),
      ],
    ),
  );
}