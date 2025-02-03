import 'package:chat_app/shared/config/resources/style_manger.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../config/resources/color_manger.dart';

PreferredSizeWidget myAppBar({required String title}) => AppBar(
      backgroundColor: ColorManger.kPrimaryTwo,
      title: Text(
        title,
        style: getMyMediumTextStyle(color: Colors.white),
      ),
      leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          )),
    );
