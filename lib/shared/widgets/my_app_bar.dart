import 'package:chat_app/shared/config/resources/style_manger.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../config/resources/color_manger.dart';

PreferredSizeWidget myAppBar({required String title,bool ?showIcon=true}) => AppBar(
      backgroundColor: ColorManger.kPrimaryTwo,
      title: Text(
        title,
        style: getMyMediumTextStyle(color: Colors.white),
      ),
      leading: IconButton(
          onPressed: () {
            if(showIcon==true){
              Get.back();
            }

          },
          icon:  Icon(
            Icons.arrow_back_ios,
            color: showIcon==true?Colors.white:ColorManger.kPrimaryTwo,
          )),
    );
