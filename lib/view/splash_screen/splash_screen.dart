import 'dart:async';

import 'package:chat_app/shared/config/resources/color_manger.dart';
import 'package:chat_app/view/intro_screen/intro_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

   Timer ?_timer;
   _onStart(){
     _timer=Timer(Duration(seconds: 4), _onFinish);
   }

   _onFinish(){
     Get.offAll(()=>const IntroScreen());

   }

   @override
  void initState() {
     _onStart();

     super.initState();
  }
  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManger.kPrimary,
      body: Center(
        child: SvgPicture.asset('assets/images/logo.svg'),
      ),
    );
  }
}
